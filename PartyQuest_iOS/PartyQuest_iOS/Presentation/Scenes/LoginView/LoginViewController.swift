//
//  LoginViewController.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/10/27.
//

import UIKit

final class LoginViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.text = "PartyQuest 로그인"
        label.textColor = .black
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.text = """
        PartyQuest에 등록된 계정으로 로그인해 주세요.
        아래 서비스와 계정을 연동한 경우 해당 서비스를 통해 로그인할 수 있습니다.
        """
        label.textColor = .black
        label.numberOfLines = .zero
        
        return label
    }()
    
    private let emailTextField: TitledTextfield = {
        let titledTextField = TitledTextfield()
        titledTextField.setTitle("이메일")
        
        return titledTextField
    }()
    
    private let passwordTextField: TitledTextfield = {
        let titledTextField = TitledTextfield()
        titledTextField.setTitle("패스워드")
        
        return titledTextField
    }()
    
    private let appleLoginButton: UIButton = .init()
    private let kakaoLoginButton: UIButton = .init()
    private let googleLoginButton: UIButton = .init()
    private let naverLoginButton: UIButton = .init()
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        
        return stackView
    }()
    
    private let outterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureRootView()
        configureButtons()
        setSubviews()
        setConstraints()
    }
    
    private func configureRootView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureButtons() {
        let buttons = [appleLoginButton, googleLoginButton,
         naverLoginButton, kakaoLoginButton]
        
        buttons.forEach { $0.setTitleColor(.systemBlue, for: .normal) }
        appleLoginButton.setTitle("애플로그인", for: .normal)
        googleLoginButton.setTitle("구글로그인", for: .normal)
        naverLoginButton.setTitle("네이버로그인", for: .normal)
        kakaoLoginButton.setTitle("카카오로그인", for: .normal)
    }
    
    private func setSubviews() {
        buttonStackView.addArrangedSubview(appleLoginButton)
        buttonStackView.addArrangedSubview(kakaoLoginButton)
        buttonStackView.addArrangedSubview(googleLoginButton)
        buttonStackView.addArrangedSubview(naverLoginButton)
        
        outterStackView.addArrangedSubview(titleLabel)
        outterStackView.addArrangedSubview(descriptionLabel)
        outterStackView.addArrangedSubview(emailTextField)
        outterStackView.addArrangedSubview(passwordTextField)
        outterStackView.addArrangedSubview(buttonStackView)
        
        view.addSubview(outterStackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            outterStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            outterStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            outterStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            outterStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }
}