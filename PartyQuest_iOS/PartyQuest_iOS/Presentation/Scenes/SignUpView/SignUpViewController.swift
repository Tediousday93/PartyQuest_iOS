//
//  SignUpViewController.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/01.
//

import UIKit

final class SignUpViewController: UIViewController {
    private let emailTextField: TitledTextfield = {
        let textField = TitledTextfield()
        textField.setTitle("이메일")
        
        return textField
    }()
    
    private let passwordTextField: TitledTextfield = {
        let textField = TitledTextfield()
        textField.setTitle("패스워드")
        
        return textField
    }()
    
    private let birthDateTextField: TitledTextfield = {
        let textField = TitledTextfield()
        textField.setTitle("생년월일")
        
        return textField
    }()
    
    private let nickNameTextField: TitledTextfield = {
        let textField = TitledTextfield()
        textField.setTitle("닉네임")
        
        return textField
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("가입하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let viewModel: SignUpViewModel
    
    init(signUpViewModel: SignUpViewModel) {
        viewModel = signUpViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureRootView()
        setSubviews()
        setConstraints()
        setBindings()
    }
    
    private func configureNavigationBar() {
        self.title = "회원가입"
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    private func configureRootView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setSubviews() {
        let textFileds = [emailTextField, passwordTextField, birthDateTextField, nickNameTextField]
        textFileds.forEach { stackView.addArrangedSubview($0) }
        
        view.addSubview(stackView)
        view.addSubview(signUpButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: signUpButton.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            
            signUpButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }
    
    private func setBindings() {
        
    }
}