//
//  ViewController.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/10/26.
//

import UIKit
import RxSwift
import RxCocoa

final class WelcomeViewController: UIViewController {
    private let viewModel: WelcomeViewModel
    private let disposeBag = DisposeBag()
    
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
        stackView.distribution = .fillEqually
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
        button.setTitle("로그인", for: .normal)
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
        button.setTitle("회원가입", for: .normal)
        button.titleLabel?.textColor = .label
        button.titleLabel?.font = .preferredFont(forTextStyle: .subheadline)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    init(welcomeViewModel: WelcomeViewModel) {
        self.viewModel = welcomeViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureRootView()
        setSubViews()
        setConstraint()
        setBindings()
    }
    
    private func configureRootView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setSubViews() {
        buttonStackView.addArrangedSubview(loginButton)
        buttonStackView.addArrangedSubview(signUpButton)
        
        view.addSubview(welcomeImageView)
        view.addSubview(welcomeLabel)
        view.addSubview(buttonStackView)
    }
    
    private func setConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            welcomeImageView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            welcomeImageView.bottomAnchor.constraint(equalTo: welcomeLabel.topAnchor,
                                                     constant: -30),
            welcomeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor,
                                                 constant: -300),
            
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -30),
            buttonStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            buttonStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
        ])
    }
    
    private func setBindings() {
        let input = WelcomeViewModel.Input(
            loginButtonTapped: loginButton.rx.tap.asObservable(),
            signUpButtonTapped: signUpButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        output.socialLoginPushed
            .drive()
            .disposed(by: disposeBag)
        
        output.signUpPushed
            .drive()
            .disposed(by: disposeBag)
    }
}