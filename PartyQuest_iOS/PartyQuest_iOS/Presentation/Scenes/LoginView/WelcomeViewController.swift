//
//  ViewController.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/10/26.
//

import UIKit

final class WelcomeViewController: UIViewController {
    private let welcomeImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "welcome")
        imageView.frame = CGRect(x: 0, y: 0, width: 104, height: 136)
        imageView.image = image
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let welcomeLabel = {
        let label = UILabel()
        label.text = "환영합니다."
        label.font = .preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let buttonStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()
    
    private let loginButton = {
        let button = UIButton()
        button.layer.backgroundColor = UIColor(red: 0.329,
                                               green: 0.247,
                                               blue: 0.827,
                                               alpha: 1).cgColor
        button.layer.cornerRadius = 14
        button.titleLabel?.text = "로그인"
        button.titleLabel?.textColor = UIColor(red: 0.949,
                                               green: 0.949,
                                               blue: 0.965,
                                               alpha: 1)
        button.titleLabel?.font = .preferredFont(forTextStyle: .subheadline)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let signUpButton = {
        let button = UIButton()
        button.layer.backgroundColor = UIColor(red: 0.949,
                                               green: 0.949,
                                               blue: 0.969,
                                               alpha: 1).cgColor
        button.layer.cornerRadius = 14
        button.titleLabel?.text = "회원가입"
        button.titleLabel?.textColor = .label
        button.titleLabel?.font = .preferredFont(forTextStyle: .subheadline)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubViews()
        setConstraint()
    }
    
    private func setSubViews() {
        buttonStackView.addArrangedSubview(loginButton)
        buttonStackView.addArrangedSubview(signUpButton)
        
        view.addSubview(welcomeImageView)
        view.addSubview(welcomeLabel)
        view.addSubview(buttonStackView)
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            welcomeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeImageView.centerYAnchor.constraint(equalTo: view.topAnchor,
                                                      constant: view.frame.height / 8),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor,
                                                  constant: view.frame.height / 6),
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            buttonStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
        ])
    }
}
