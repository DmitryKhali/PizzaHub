//
//  StoriesFullscreenViewController.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 25.01.2026.
//

import UIKit
import SnapKit

final class StoriesFullscreenViewController: UIViewController {
    
    private var stories: [Story] = []
    private var currentStoryIndex: Int = 0
    private var isStoryPaused = false
    private var currentProgressDuration: TimeInterval = 5.0
    private var isManualScrolling: Bool = false
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = view.bounds.size
        layout.minimumLineSpacing = 0
        
        var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(StoryFullscreenCell.self, forCellWithReuseIdentifier: StoryFullscreenCell.reuseId)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        setupGestureRecognizer()
    }
    
    override func viewDidLayoutSubviews() { // TODO: дергается 2 раза, обсудить
        super.viewWillLayoutSubviews()
                
        if !stories.isEmpty {
            scrollToCurrentStory()
        }
    }
    
    private func getCurrentCell() -> StoryFullscreenCell? {
        let indexPath = IndexPath(item: currentStoryIndex, section: 0)
        return collectionView.cellForItem(at: indexPath) as? StoryFullscreenCell
    }
    
    private func startCurrentStory() {
        isStoryPaused = false
        
        guard let cell = getCurrentCell() else { return }
        
        cell.startProgress(duration: currentProgressDuration) { [weak self] in
            guard let self else { return }
            self.goToNexStory()
        }
    }
    
    private func pauseCurrentStory() {
        isStoryPaused = true
        getCurrentCell()?.pauseProgress()
    }
    
    private func resumeCurrentStory() {
        guard isStoryPaused else { return }
        
        isStoryPaused = false
        
        guard let cell = getCurrentCell() else { return }
        
        cell.resumeProgress(duration: currentProgressDuration) { [weak self] in
            guard let self else { return }
            self.goToNexStory()
        }
    }
    
    private func stopCurrentStory() {
        let oldIndex = currentStoryIndex
        if let oldCell = collectionView.cellForItem(at: IndexPath(item: oldIndex, section: 0)) as? StoryFullscreenCell {
            oldCell.resetProgress() // Останавливаем её анимацию
        }
//        getCurrentCell()?.resetProgress()
    }
}

// MARK: - CollectionView Delegate
extension StoriesFullscreenViewController: UICollectionViewDelegate {
    
}

extension StoriesFullscreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        stories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryFullscreenCell.reuseId, for: indexPath) as? StoryFullscreenCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: stories[indexPath.row])
        cell.onCloseTapped = { [weak self] in
            guard let self else { return }
            self.dismiss(animated: true)
        }
        cell.onHoldBegan = { [weak self] in
            guard let self else { return }
            self.pauseCurrentStory()
        }
        cell.onHoldEnded = { [weak self] in
            guard let self else { return }
            self.resumeCurrentStory()
        }
        return cell
    }
}

// MARK: - Setup
extension StoriesFullscreenViewController {
    private func setupViews() {
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
}

// MARK: - Public
extension StoriesFullscreenViewController {
    func setup(with stories: [Story], selectedStoryIndex: Int) {
        self.stories = stories
        self.currentStoryIndex = selectedStoryIndex
    }
}

// MARK: - Tap handling & scroll
extension StoriesFullscreenViewController {
        
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        let screenWith = view.bounds.width
        
        if location.x < screenWith * 0.3 {
            goToPreviousStory()
        }
        else if  location.x > screenWith * 0.7 {
            goToNexStory()
        }
        else {
            toggleCurrentStoryPlayback()
        }
    }
    
    @objc private func handleSwipeDown(_ gesture: UISwipeGestureRecognizer) {
        dismiss(animated: true)
    }
    
    private func goToPreviousStory() {
        let prevIndex = currentStoryIndex - 1
        guard prevIndex >= 0 else { return }
        
        swipeToStory(at: prevIndex)
    }
    
    private func goToNexStory() {
        let nextIndex = currentStoryIndex + 1
        guard nextIndex < stories.count else {
            dismiss(animated: true)
            return
        }
                
        swipeToStory(at: nextIndex)
    }
    
    private func toggleCurrentStoryPlayback() {
        
    }
    
    private func swipeToStory(at index: Int) {
        stopCurrentStory()
        
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        currentStoryIndex = index
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self, !self.isStoryPaused else { return }
            self.startCurrentStory()
        }
    }
    
    private func scrollToCurrentStory() {
        print("scrollToCurrentStory() \(currentStoryIndex)")

        let indexPath = IndexPath(item: currentStoryIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.startCurrentStory()
        }
    }
}

// MARK: - UIScrollViewDelegate
extension StoriesFullscreenViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        print("scrollViewWillBeginDragging")
        // 1. Немедленно останавливаем и сбрасываем текущий прогресс
//        stopCurrentStory()
        
//        // 2. Ставим флаг, что идёт ручной скролл
//        isManualScrolling = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
        
        let pageWidth = collectionView.bounds.width
        let newIndex = Int(collectionView.contentOffset.x / pageWidth)
        
        if newIndex != currentStoryIndex {
            
            self.stopCurrentStory()
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.startCurrentStory()
            }
        }
    }
}
