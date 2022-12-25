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
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Working"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 50)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "\(durationTimer)"
        label.font = .boldSystemFont(ofSize: 60)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var shapeView: UIImageView = {
        let ellipse = UIImageView()
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 3.7, weight: .medium, scale: .large)
        let image = UIImage(systemName: "circle", withConfiguration: imageConfiguration)
        ellipse.image = image
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
        setupHierarchy()
        setupLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.animationCircular()
        self.colorsElements()
        
    }
    
    //MARK: - Setups
    
    private func setupHierarchy() {
        let subviews = [statusLabel,
                        timerLabel,
                        button,
                        buttonView,
                        shapeView
        ]
        subviews.forEach({ view.addSubview($0) })
        
        shapeView.addSubview(timerLabel)
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -280),
            
            timerLabel.centerXAnchor.constraint(equalTo: shapeView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: shapeView.centerYAnchor),
            
            shapeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shapeView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            shapeView.heightAnchor.constraint(equalToConstant: 305),
            shapeView.widthAnchor.constraint(equalToConstant: 305),
            
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
    
    //MARK: - Action Timer
    
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
            statusLabel.text = "Relaxing"
            
            isStarted = false
            isWorkTime = false
            woorkLoop = false
            
        } else if durationTimer == 0 && woorkLoop == false {
            print("timer to works loop")
            durationTimer = 10
            timerLabel.text = "\(durationTimer)"
            timer.invalidate()
            buttonView.image = UIImage(systemName: "play")
            statusLabel.text = "Working"
            
            isStarted = false
            isWorkTime = false
            woorkLoop = true
        }
        
    }
    
    //MARK: - Animation
    
    private func animationCircular() {
        
        let center = CGPoint(x: shapeView.frame.height / 2, y: shapeView.frame.width / 2)
        
        let endEngel = (-CGFloat.pi / 2)
        let startEngel = 2 * CGFloat.pi + endEngel
        
        let cercularPath = UIBezierPath(arcCenter: center, radius: 123, startAngle: startEngel, endAngle: endEngel, clockwise: false)
        
        shapeLayer.path = cercularPath.cgPath
        shapeLayer.lineWidth = 24.2
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
    
    func pauseAnimation(){
        print("pause animation")
        let pausedTime = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        shapeLayer.speed = 0.0
        shapeLayer.timeOffset = pausedTime
    }
    
    func resumeAnimation() {
        print("rusume animation")
        let pausedTime = shapeLayer.timeOffset
        shapeLayer.speed = 1
        shapeLayer.timeOffset = 0.0
        shapeLayer.beginTime = 0.0
        let timeSincePause = shapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        shapeLayer.beginTime = timeSincePause
    }
    
    //MARK: - Setups Color
    
    var oneColorWork = #colorLiteral(red: 0.09821208566, green: 0.2465203106, blue: 0.4332227409, alpha: 1)
    var twoColorWork = #colorLiteral(red: 0.09821208566, green: 0.2465203106, blue: 0.4332227409, alpha: 1)
    var threeColorWork = #colorLiteral(red: 0.09821208566, green: 0.2465203106, blue: 0.4332227409, alpha: 1)
    var fourColorWork = #colorLiteral(red: 0.09821208566, green: 0.2465203106, blue: 0.4332227409, alpha: 1)
    var fiveColorWork = #colorLiteral(red: 0.09821208566, green: 0.2465203106, blue: 0.4332227409, alpha: 1)
    
    var oneColorRelaxing = #colorLiteral(red: 0.09821208566, green: 0.2465203106, blue: 0.4332227409, alpha: 1)
    var twoColorRelaxing = #colorLiteral(red: 0.09821208566, green: 0.2465203106, blue: 0.4332227409, alpha: 1)
    var threeColorRelaxing = #colorLiteral(red: 0.09821208566, green: 0.2465203106, blue: 0.4332227409, alpha: 1)
    var fourColorRelaxing = #colorLiteral(red: 0.09821208566, green: 0.2465203106, blue: 0.4332227409, alpha: 1)
    var fiveColorRelaxing = #colorLiteral(red: 0.09821208566, green: 0.2465203106, blue: 0.4332227409, alpha: 1)
    
    func colorsElements() {
        if woorkLoop {
            view.backgroundColor = oneColorWork
            
            shapeView.tintColor = twoColorWork
            shapeLayer.strokeColor = threeColorWork.cgColor
   
            statusLabel.textColor = fiveColorWork
            timerLabel.textColor = fiveColorWork
            buttonView.tintColor = fiveColorWork
        } else {
            view.backgroundColor = oneColorRelaxing
            
            shapeView.tintColor = twoColorRelaxing
            shapeLayer.strokeColor = threeColorRelaxing.cgColor
   
            statusLabel.textColor = fiveColorRelaxing
            timerLabel.textColor = fiveColorRelaxing
            buttonView.tintColor = fiveColorRelaxing
        }
    }
  
}


