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
    
    private lazy var buttonPlayView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "play"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var buttonPlay: UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonPlayPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonResetView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "goforward"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var buttonReset: UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonResetPressed), for: .touchUpInside)
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
                        buttonPlay,
                        buttonPlayView,
                        buttonReset,
                        buttonResetView,
                        shapeView
        ]
        subviews.forEach({ view.addSubview($0) })
        
        shapeView.addSubview(timerLabel)
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -260),
            
            timerLabel.centerXAnchor.constraint(equalTo: shapeView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: shapeView.centerYAnchor),
            
            shapeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shapeView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            shapeView.heightAnchor.constraint(equalToConstant: 305),
            shapeView.widthAnchor.constraint(equalToConstant: 305),
            
            buttonPlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            buttonPlayView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 250),
            buttonPlayView.widthAnchor.constraint(equalToConstant: 90),
            buttonPlayView.heightAnchor.constraint(equalToConstant: 90),
            
            buttonPlay.centerXAnchor.constraint(equalTo: buttonPlayView.centerXAnchor),
            buttonPlay.centerYAnchor.constraint(equalTo: buttonPlayView.centerYAnchor),
            buttonPlay.widthAnchor.constraint(equalToConstant: 90),
            buttonPlay.heightAnchor.constraint(equalToConstant: 90),
            
            buttonResetView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
            buttonResetView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 250),
            buttonResetView.widthAnchor.constraint(equalToConstant: 90),
            buttonResetView.heightAnchor.constraint(equalToConstant: 90),

            buttonReset.centerXAnchor.constraint(equalTo: buttonResetView.centerXAnchor),
            buttonReset.centerYAnchor.constraint(equalTo: buttonResetView.centerYAnchor),
            buttonReset.widthAnchor.constraint(equalToConstant: 90),
            buttonReset.heightAnchor.constraint(equalToConstant: 90)
//
        ])
        
    }
    
    //MARK: - Action Timer
    
    @objc private func buttonPlayPressed() {
        if isStarted == false && isWorkTime == false {
            basicAnimation()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerActive), userInfo: nil, repeats: true)
            isStarted = true
            isWorkTime = true
            buttonPlayView.image = UIImage(systemName: "pause")
            print("start")
        } else if isStarted == true && isWorkTime == true {
            buttonPlayView.image = UIImage(systemName: "play")
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
            buttonPlayView.image = UIImage(systemName: "pause")
        }
        
    }
    
    @objc func buttonResetPressed() {
        if isStarted == true && isWorkTime == false && woorkLoop == true {
            timer.invalidate()
            resetAnimation()
            durationTimer = 10
            timerLabel.text = "\(durationTimer)"
        } else if isStarted == true && isWorkTime == false && woorkLoop == false {
            timer.invalidate()
            resetAnimation()
            durationTimer = 5
            timerLabel.text = "\(durationTimer)"
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
            buttonPlayView.image = UIImage(systemName: "play")
            statusLabel.text = "Relaxing"
            
            isStarted = false
            isWorkTime = false
            woorkLoop = false
            
        } else if durationTimer == 0 && woorkLoop == false {
            print("timer to works loop")
            durationTimer = 10
            timerLabel.text = "\(durationTimer)"
            timer.invalidate()
            buttonPlayView.image = UIImage(systemName: "play")
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
        
        let cercularPath = UIBezierPath(arcCenter: center, radius: 123.07, startAngle: startEngel, endAngle: endEngel, clockwise: false)
        
        shapeLayer.path = cercularPath.cgPath
        shapeLayer.lineWidth = 24.7
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = CAShapeLayerLineCap.round

        shapeView.layer.addSublayer(shapeLayer)
    }
    
    private func basicAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 0
        basicAnimation.duration = CFTimeInterval(self.durationTimer)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = true
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    
    }
    
    func resetAnimation() {
        basicAnimation()
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
    
    //MARK: - Setups Colors
    
    var oneColorWork = #colorLiteral(red: 0.8627452254, green: 0.8627452254, blue: 0.8627452254, alpha: 1)
    var twoColorWork = #colorLiteral(red: 0.4151946008, green: 0.395400703, blue: 0.3654464483, alpha: 1)
    var threeColorWork = #colorLiteral(red: 0.9264768958, green: 0.6883662343, blue: 0.1297983527, alpha: 1)
    var fourColorWork = #colorLiteral(red: 0.4151946008, green: 0.395400703, blue: 0.3654464483, alpha: 1)
    var fiveColorWork = #colorLiteral(red: 0.1088501438, green: 0.1340978444, blue: 0.1635158956, alpha: 1)
    
    var oneColorRelaxing = #colorLiteral(red: 0.9678950906, green: 0.8792178035, blue: 0.958201468, alpha: 1)
    var twoColorRelaxing = #colorLiteral(red: 0.875171721, green: 0.825748384, blue: 0.9209445119, alpha: 1)
    var threeColorRelaxing = #colorLiteral(red: 0.8918094039, green: 0.67772609, blue: 0.7940873504, alpha: 1)
    var fourColorRelaxing = #colorLiteral(red: 0.6169006824, green: 0.7127228379, blue: 0.7795686126, alpha: 1)
    var fiveColorRelaxing = #colorLiteral(red: 0.8242189884, green: 0.3782162666, blue: 0.5488271117, alpha: 1)

    func colorsElements() {
        if woorkLoop {
            view.backgroundColor = oneColorWork
            
            shapeView.tintColor = twoColorWork
            shapeLayer.strokeColor = threeColorWork.cgColor
   
            statusLabel.textColor = fiveColorWork
            timerLabel.textColor = fiveColorWork
            buttonPlayView.tintColor = fiveColorWork
            buttonResetView.tintColor = fiveColorWork
        } else {
            view.backgroundColor = oneColorRelaxing
            
            shapeView.tintColor = twoColorRelaxing
            shapeLayer.strokeColor = threeColorRelaxing.cgColor
   
            statusLabel.textColor = fiveColorRelaxing
            timerLabel.textColor = fiveColorRelaxing
            buttonPlayView.tintColor = fiveColorRelaxing
            buttonResetView.tintColor = fiveColorRelaxing
        }
    }
  
}


