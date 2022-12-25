//
//  ViewController.swift
//  Home Work 12
//
//  Created by Daniil Davidovich on 23.12.22.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Elements To Timer and Animation

    private var timer = Timer()
    private var durationTimer = 10
    
    private var isWorkTime = false
    private var isStarted = false
    private var woorkLoop = true
    
    private let shapeLayer = CAShapeLayer()
    private var elapsed: CFTimeInterval = 0
    
    //MARK: - UI elements
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "\(durationTimer)"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 60)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var shapeView: UIImageView = {
        let ellipse = UIImageView()
        ellipse.image = UIImage(systemName: "circle")
        ellipse.translatesAutoresizingMaskIntoConstraints = false
        return ellipse
    }()
    
    private lazy var buttonView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "play"))
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: - Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.animationCircular()
        self.colorAnimation()
        
    }
    
    //MARK: - Setups
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func setupHierarchy() {
        let subviews = [timerLabel,
                        button,
                        buttonView,
                        shapeView
                        
        ]
        subviews.forEach({ view.addSubview($0) })
        
        shapeView.addSubview(timerLabel)
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: shapeView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: shapeView.centerYAnchor),
            
            shapeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shapeView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            shapeView.heightAnchor.constraint(equalToConstant: 300),
            shapeView.widthAnchor.constraint(equalToConstant: 300),
            
            buttonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200),
            buttonView.widthAnchor.constraint(equalToConstant: 90),
            buttonView.heightAnchor.constraint(equalToConstant: 90),
            
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200),
            button.widthAnchor.constraint(equalToConstant: 90),
            button.heightAnchor.constraint(equalToConstant: 90)
            
        ])
        
    }
    
    //MARK: - Action
    @objc private func buttonPressed() {
        if isStarted == false && isWorkTime == false {
            basicAnimation()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerActive), userInfo: nil, repeats: true)
            isStarted = true
            isWorkTime = true
            buttonView.image = UIImage(systemName: "pause")
            print("start")
        } else if isStarted == true && isWorkTime == true {
            buttonView.image = UIImage(systemName: "play")
            timer.invalidate()
            isWorkTime = false
            print("pause")
            pauseAnimation()
        } else if isStarted == true && isWorkTime == false {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerActive), userInfo: nil, repeats: true)
            resumeAnimation()
            isStarted = true
            isWorkTime = true
            print("start after pause ")
            buttonView.image = UIImage(systemName: "pause")
        }
        
    }
    
    @objc func timerActive() {
        
        durationTimer -= 1
        timerLabel.text = "\(durationTimer)"
        print(durationTimer)
        
        if durationTimer == 0 && woorkLoop == true {
            print("timer to relax loop")
            durationTimer = 5
            timerLabel.text = "\(durationTimer)"
            timer.invalidate()
            buttonView.image = UIImage(systemName: "play")
            
            isStarted = false
            isWorkTime = false
            woorkLoop = false
            
        } else if durationTimer == 0 && woorkLoop == false {
            print("timer to works loop ")
            durationTimer = 10
            timerLabel.text = "\(durationTimer)"
            timer.invalidate()
            buttonView.image = UIImage(systemName: "play")
            
            isStarted = false
            isWorkTime = false
            woorkLoop = true
        }
        
        func colorAnimation() {
            if woorkLoop == true {
                shapeLayer.strokeColor = UIColor.black.cgColor
            } else {
                shapeLayer.strokeColor = UIColor.green.cgColor
            }
        }
        
    }
    
    //MARK: - Animation
    private func animationCircular() {
        
        let center = CGPoint(x: shapeView.frame.height / 2, y: shapeView.frame.width / 2)
        
        let endEngel = (-CGFloat.pi / 2)
        let startEngel = 2 * CGFloat.pi + endEngel
        
        let cercularPath = UIBezierPath(arcCenter: center, radius: 121, startAngle: startEngel, endAngle: endEngel, clockwise: false)
        
        shapeLayer.path = cercularPath.cgPath
        shapeLayer.lineWidth = 21
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = CAShapeLayerLineCap.round

        shapeView.layer.addSublayer(shapeLayer)
    }
    
    private func basicAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 0
        basicAnimation.duration = CFTimeInterval(durationTimer)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = true
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    
    }
    
    func colorAnimation() {
        if woorkLoop == true {
            shapeLayer.strokeColor = UIColor.black.cgColor
        } else {
            shapeLayer.strokeColor = UIColor.green.cgColor
        }
    }
    
    
    func pauseAnimation(){
        print("pause animation")
        let pausedTime = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        shapeLayer.speed = 0.0
        shapeLayer.timeOffset = pausedTime
    }
    
    func resumeAnimation() {
        print("rusume animation")
        let pausedTime = shapeLayer.timeOffset
        shapeLayer.speed = 1.0
        shapeLayer.timeOffset = 0.0
        shapeLayer.beginTime = 0.0
        let timeSincePause = shapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        shapeLayer.beginTime = timeSincePause
    }
    
    
}


//func pause() {
//        guard
//            isRunning,
//            let presentation = progressShapeLayer.presentation()
//        else {
//            return
//        }
//
//        elapsed += CACurrentMediaTime() - startTime
//        progressShapeLayer.strokeEnd = presentation.strokeEnd
//        progressShapeLayer.removeAnimation(forKey: animationKey)
//    }
//
//    func resume() {
//        guard !isRunning else { return }
//
//        isRunning = true
//        startTime = CACurrentMediaTime()
//        let animation = CABasicAnimation(keyPath: "strokeEnd")
//        animation.fromValue = elapsed / duration
//        animation.toValue = 1
//        animation.duration = duration - elapsed
//        animation.delegate = self
//        progressShapeLayer.strokeEnd = 1
//        progressShapeLayer.add(animation, forKey: animationKey)
//    }

