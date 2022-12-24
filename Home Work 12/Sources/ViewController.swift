//
//  ViewController.swift
//  Home Work 12
//
//  Created by Daniil Davidovich on 23.12.22.
//

import UIKit

class ViewController: UIViewController {
    //MARK: - UI elements
    
    private var timer = Timer()
    private var durationTimer = 10
    
    private var isWorkTime = false
    private var isStarted = false
    
    let shapeLayer = CAShapeLayer()
    
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
        } else if isStarted == true && isWorkTime == true {
            buttonView.image = UIImage(systemName: "play")
            timer.invalidate()
            isWorkTime = false
        } else if isStarted == true && isWorkTime == false {
            basicAnimation()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerActive), userInfo: nil, repeats: true)
            isStarted = true
            isWorkTime = true
            buttonView.image = UIImage(systemName: "pause")
        }

    }
    
    @objc func timerActive() {
            
            durationTimer -= 1
            timerLabel.text = "\(durationTimer)"
            print(durationTimer)
        
        if durationTimer == 0 && isStarted == true && isWorkTime == false {
            durationTimer = 10
            timerLabel.text = "\(durationTimer)"
            timer.invalidate()
            buttonView.image = UIImage(systemName: "play")
            
            isStarted = false
            isWorkTime = false
        } else if (durationTimer == 0 && isStarted == false && isWorkTime == false) || (durationTimer == 0 && isStarted == true && isWorkTime == true) {
            durationTimer = 7
            timerLabel.text = "\(durationTimer)"
            timer.invalidate()
            buttonView.image = UIImage(systemName: "play")
            print("one")
            
            isStarted = true
            isWorkTime = false
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
        shapeLayer.strokeColor = UIColor.black.cgColor
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
}
