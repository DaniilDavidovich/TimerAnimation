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
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "\(durationTimer)"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 60)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
        
    private lazy var circleView: UIImageView = {
        let ellipse = UIImageView(image: (UIImage(systemName: "circle")))
        ellipse.translatesAutoresizingMaskIntoConstraints = false
        return ellipse
    }()
    
    private lazy var imageView: UIImageView = {
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
    
    //MARK: - Setups
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func setupHierarchy() {
        let subviews = [timeLabel,
                        button,
                        imageView,
                        circleView
                     
        ]
        subviews.forEach({ view.addSubview($0) })
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            
            circleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            circleView.heightAnchor.constraint(equalToConstant: 300),
            circleView.widthAnchor.constraint(equalToConstant: 300),
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 90),
            imageView.heightAnchor.constraint(equalToConstant: 90),
            
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200),
            button.widthAnchor.constraint(equalToConstant: 90),
            button.heightAnchor.constraint(equalToConstant: 90)
    
        ])
        
    }
    
    //MARK: - Action
    @objc private func buttonPressed() {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerActive), userInfo: nil, repeats: true)

    }
    
    @objc func timerActive() {
            imageView.image = UIImage(systemName: "pause")
            durationTimer -= 1
            timeLabel.text = "\(durationTimer)"
            print(durationTimer)
        
        if durationTimer == 0 {
            timer.invalidate()
            imageView.image = UIImage(systemName: "play")
        }
      
    }
}
