//
//  SignUpViewController.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/01.
//

import UIKit
import RxSwift
import RxCocoa

final class SignUpViewController: UIViewController {
    private let emailTextField: TitledTextfield = {
        let textField = TitledTextfield()
        textField.setTitle("이메일")
        
        return textField
    }()
    
    private let passwordTextField: TitledTextfield = {
        let textField = TitledTextfield()
        textField.setTitle("패스워드")
        textField.textField.isSecureTextEntry = true
        
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
        let button = UIButton(type: .system)
        button.setTitle("가입하기", for: .normal)
        button.tintColor = .label
        button.backgroundColor = .systemGray5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let viewModel: SignUpViewModel
    private var disposeBag: DisposeBag
    
    init(signUpViewModel: SignUpViewModel) {
        viewModel = signUpViewModel
        disposeBag = .init()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        disposeBag = .init()
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
        let email = emailTextField.textField.rx.text
            .orEmpty
            .distinctUntilChanged()
        let password = passwordTextField.textField.rx.text
            .orEmpty
            .distinctUntilChanged()
        let birthDate = birthDateTextField.textField.rx.text
            .orEmpty
            .distinctUntilChanged()
        let nickname = nickNameTextField.textField.rx.text
            .orEmpty
            .distinctUntilChanged()
        
        let input = SignUpViewModel.Input(
            email: email,
            password: password,
            birthDate: birthDate,
            nickname: nickname,
            signUpButtonTapped: signUpButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input)
        
        output.userInputsValidation
            .drive(with: self, onNext: { owner, validationResult in
                owner.emailTextField.setTextFieldBorder(isRed: validationResult.0)
                owner.passwordTextField.setTextFieldBorder(isRed: validationResult.1)
                owner.nickNameTextField.setTextFieldBorder(isRed: validationResult.2)
                owner.birthDateTextField.setTextFieldBorder(isRed: validationResult.3)
            })
            .disposed(by: disposeBag)
        
        output.isEnableSignUpButton
            .drive(with: self, onNext: { owner, isEnableSignUpButton in
                owner.signUpButton.isEnabled = isEnableSignUpButton
            })
            .disposed(by: disposeBag)
        
        output.signUpSucceeded
            .subscribe()
            .disposed(by: disposeBag)
    }
}
