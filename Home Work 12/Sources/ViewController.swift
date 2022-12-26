//
//  ViewController.swift
//  Home Work 12
//
//  Created by Daniil Davidovich on 23.12.22.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Elements To Timer and Animation
    
    enum TimerNumber {
        static let timeWork = 3
        static let timeRelax = 3
    }

    private var timer = Timer()
    private var time = TimerNumber.timeWork
    private var durationTimer = 1000
    
    private var isWorkTime = false
    private var isStarted = false
    private var woorkLoop = true
    
    private let shapeLayer = CAShapeLayer()
    
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
        label.text = ("\(time)")
        label.text = formatTimer()
        label.font = .boldSystemFont(ofSize: 60)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var shapeView: UIImageView = {
        let ellipse = UIImageView()
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 3.7, weight: .medium, scale: .large)
//        let image = UIImage(systemName: "circle", withConfiguration: imageConfiguration)
//        ellipse.image = image
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
        self.colorsElements()
        self.creatingCircularPath()
        
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
    
    func formatTimer() -> String {
        let time = Double(time)
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return formatter.string(from: time) ?? "00:00"
    }
    
    @objc private func buttonPlayPressed() {
        if isStarted == false {
            timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerActive), userInfo: nil, repeats: true)
            timerLabel.text = formatTimer()
            isStarted = true
            buttonPlayView.image = UIImage(systemName: "pause")
            progressAnimation(duration: TimeInterval(time))
            print("start timer")
        } else if isStarted == true {
            timer.invalidate()
            if let presentation = progressLayer.presentation() {
                progressLayer.strokeEnd = presentation.strokeEnd
            }
            progressLayer.removeAnimation(forKey: "progressAnimation")
            buttonPlayView.image = UIImage(systemName: "play")
            isStarted = false
            print("pause timer")
            
        }
        
    }
    
    @objc func timerActive() {
        
        if durationTimer > 0 {
            durationTimer -= 1
            return
        }
        
        durationTimer = 1000
        
        
        time -= 1
        timerLabel.text = formatTimer()
        print(time)
        
        if time < 1 && woorkLoop == true {
            print("timer to relax loop")
            statusLabel.text = "Relaxing"
            time = TimerNumber.timeRelax
            timerLabel.text = ("\(time)")
            woorkLoop = false
            colorsElements()
            progressAnimation(duration: TimeInterval(time))
            
        } else if time < 1 && woorkLoop == false {
            print("timer to works loop")
            statusLabel.text = "Working"
            time = TimerNumber.timeWork
            timerLabel.text = ("\(time)")
            woorkLoop = true
            colorsElements()
            progressAnimation(duration: TimeInterval(time))
        }
        timerLabel.text = formatTimer()
        
    }
    
    @objc func buttonResetPressed() {
        durationTimer = 1000
        if woorkLoop == true {
            time = TimerNumber.timeWork
            timerLabel.text = ("\(time)")
            isStartedCheck()
        } else {
            durationTimer = 1000
            time = TimerNumber.timeRelax
            timerLabel.text = ("\(time)")
            isStartedCheck()
        }
        timerLabel.text = formatTimer()
        print("reset timer")
        
    }
    
    func isStartedCheck() {
        if isStarted {
            progressAnimation(duration: TimeInterval(time))
        }
    }
    
    //MARK: - Animate
    
    private let circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)
    
    
        func creatingCircularPath() {
        
        let center: CGPoint = CGPoint(x: shapeView.frame.height / 2, y: shapeView.frame.width / 2)
        let circularPath = UIBezierPath(arcCenter: center, radius: 128, startAngle: startPoint, endAngle: endPoint, clockwise: false)
        
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 23
        circleLayer.strokeEnd = 1
        shapeView.layer.addSublayer(circleLayer)
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .butt
        progressLayer.lineWidth = 23
        progressLayer.strokeEnd = 1
        shapeView.layer.addSublayer(progressLayer)
        
    }
    
    func progressAnimation(duration: TimeInterval) {
        let circularAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularAnimation.duration = duration
        circularAnimation.toValue = 0
        circularAnimation.fillMode = .forwards
        circularAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularAnimation, forKey: "progressAnimation")
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
            
            progressLayer.strokeColor = fiveColorWork.cgColor
            circleLayer.strokeColor = fourColorWork.cgColor
            
            statusLabel.textColor = fiveColorWork
            timerLabel.textColor = fiveColorWork
            buttonPlayView.tintColor = fiveColorWork
            buttonResetView.tintColor = fiveColorWork
        } else {
            view.backgroundColor = oneColorRelaxing
            
            progressLayer.strokeColor = fiveColorRelaxing.cgColor
            circleLayer.strokeColor = fourColorRelaxing.cgColor
            
            statusLabel.textColor = fiveColorRelaxing
            timerLabel.textColor = fiveColorRelaxing
            buttonPlayView.tintColor = fiveColorRelaxing
            buttonResetView.tintColor = fiveColorRelaxing
        }
    }
  
}


