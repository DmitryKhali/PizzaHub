//
//  StoryFullscreenCell.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 04.02.2026.
//

import UIKit
import SnapKit

final class StoryFullscreenCell: UICollectionViewCell {
    
    static let reuseId = "StoryFullscreenCell"
    var currentStory: Story? = nil
    
    private var progressAnimator: UIViewPropertyAnimator?
    private var targetProgress: Float = 0
    
    var onCloseTapped: (() -> Void)?
    var onHoldBegan: (() -> Void)?
    var onHoldEnded: (() -> Void)?
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        
        return view
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
        button.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: config), for: .normal)
        button.alpha = 0.8
        button.tintColor = .white
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
        return button
    }()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = 0.0
        progressView.progressTintColor = .white
        progressView.backgroundColor = .white.withAlphaComponent(0.5)
        
        return progressView
    }()
    
    private var longPressGesture: UILongPressGestureRecognizer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
        setupGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("!!! deinited !!!")
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        resetProgress()
//    }
}

// MARK: - Setup
extension StoryFullscreenCell {
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(closeButton)
        contentView.addSubview(progressView)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.left.right.equalTo(contentView.safeAreaLayoutGuide)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(20)
        }
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(imageView).inset(15)
            make.right.equalTo(imageView).inset(15)
        }
        progressView.snp.makeConstraints { make in
            make.top.equalTo(imageView).inset(28)
            make.left.equalTo(imageView).inset(15)
            make.right.equalTo(imageView).inset(55)
        }
    }
    
    private func setupGestures() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPress.minimumPressDuration = 0.1
        longPress.delegate = self
        contentView.addGestureRecognizer(longPress)
        self.longPressGesture = longPress
    }
}

// MARK: - Public
extension StoryFullscreenCell {
    func configure(with story: Story) {
        currentStory = story
        imageView.image = UIImage(named: story.imageName)
    }
    
    func startProgress(duration: TimeInterval = 5.0, completion: @escaping (() -> Void)) {
//        print("### startProgress for story \()")
        resetProgress()
        progressView.progress = 0
        targetProgress = 1.0

        progressAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) { [weak self] in
            guard let self else { return }
            self.progressView.progress = self.targetProgress
            self.progressView.layoutIfNeeded()
        }
        
        progressAnimator?.addCompletion {_ in
            print("startProgress() - completion()")
            completion()
        }
        
        progressAnimator?.startAnimation()
        
//        self.progressView.progress = 1.0
//        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear) {
//            self.progressView.layoutIfNeeded()
//        } completion: { finished in
//            completion?()
//        }
    }
    
    func pauseProgress() {
        print("pauseProgress()")
        progressAnimator?.pauseAnimation()
        
        let currentProgress = progressView.progress
        targetProgress = 1.0 - currentProgress
        
//        print("pauseProgress()")
//        progressView.layer.removeAllAnimations()
        
//        let currentProgress = progressView.progress
//        progressView.setProgress(currentProgress, animated: false)
    }
    
    func resumeProgress(duration: TimeInterval = 5.0, completion: (() -> Void)? = nil) {
//        let currentProgress = progressView.progress
//        let remainingTime = TimeInterval(1.0 - currentProgress) * duration
        
        progressAnimator?.startAnimation()
        
//        self.progressView.progress = 1.0
//        UIView.animate(withDuration: remainingTime, delay: 0, options: .curveLinear) {
//            self.progressView.layoutIfNeeded()
//        } completion: { finished in
//            if finished {
//                completion?()
//            }
//        }
    }
    
    func resetProgress() {
        print("resetProgress()")
//        progressView.layer.removeAllAnimations()
//        progressView.setProgress(0, animated: false)
        
        guard let progressAnimator = progressAnimator else { return }
        
        if progressAnimator.isRunning {
            self.progressAnimator?.stopAnimation(true)
            self.progressAnimator = nil
            
            progressView.progress = 0
            progressView.layer.removeAllAnimations()
        }
    }
}

// MARK: - Private
extension StoryFullscreenCell {
    @objc private func closeTapped() {
        onCloseTapped?()
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            onHoldBegan?()
        case .ended, .cancelled:
            onHoldEnded?()
        default:
            break
        }
    }
}

extension StoryFullscreenCell: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
