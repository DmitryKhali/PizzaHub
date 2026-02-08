//
//  StoryProgressView.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 05.02.2026.
//

import UIKit

final class StoryProgressView: UIView {
    private let progressLayer = CALayer()
    private var animationStartTime: CFTimeInterval = 0
    private var pausedTime: CFTimeInterval = 0
    private var duration: TimeInterval = 5.0
    
    // MARK: - Public API
    
    func start(duration: TimeInterval, completion: @escaping () -> Void) {
        self.duration = duration
        reset()
        
        // Настраиваем слой
        progressLayer.backgroundColor = UIColor.white.cgColor
        progressLayer.frame = CGRect(x: 0, y: 0, width: 0, height: 5)
        layer.addSublayer(progressLayer)
        
        // Анимация
        let animation = CABasicAnimation(keyPath: "bounds.size.width")
        animation.fromValue = 10
        animation.toValue = 300
        animation.duration = duration
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.delegate = AnimationDelegate(onFinish: completion)
        
        progressLayer.add(animation, forKey: "progress")
        animationStartTime = CACurrentMediaTime()
    }
    
    func pause() {
        let paused = CACurrentMediaTime()
        pausedTime = paused - animationStartTime
        
        // Останавливаем анимацию
        progressLayer.speed = 0.0
        progressLayer.timeOffset = pausedTime
    }
    
    func resume() {
        // Возобновляем анимацию
        progressLayer.speed = 1.0
        progressLayer.beginTime = CACurrentMediaTime() - pausedTime
        animationStartTime = CACurrentMediaTime() - pausedTime
    }
    
    func reset() {
        progressLayer.removeAllAnimations()
        progressLayer.removeFromSuperlayer()
        pausedTime = 0
    }
    
    // MARK: - Helper
    
    private class AnimationDelegate: NSObject, CAAnimationDelegate {
        private let onFinish: () -> Void
        
        init(onFinish: @escaping () -> Void) {
            self.onFinish = onFinish
        }
        
        func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
            if flag {
                onFinish()
            }
        }
    }
}
