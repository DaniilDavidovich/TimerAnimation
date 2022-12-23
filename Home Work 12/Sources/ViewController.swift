//
//  ViewController.swift
//  Home Work 12
//
//  Created by Daniil Davidovich on 23.12.22.
//

import UIKit

class ViewController: UIViewController {
    //MARK: - UI elements
   
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var startStopButton: UIButton = {
        let button = UIButton(type: .system)
        
        return button
    }()
    
    private lazy var viewForImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var playImage: UIImage = {
        let image = UIImage(named: "play")!
        return image
    }()
    
    private lazy var pausaImage: UIImage = {
        let image = UIImage(named: "pause.fill")!
        
        return image
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
                        startStopButton,
                        viewForImage,
        ]
        subviews.forEach({ view.addSubview($0) })
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70),
            
            startStopButton.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor, constant: 100),
            startStopButton.centerXAnchor.constraint(equalTo: timeLabel.centerXAnchor)
            
        ])
        
    }
    
    //MARK: - Action
    


}

