//
//  LogInViewController.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/10/27.
//

import UIKit
import RxSwift
import RxCocoa

final class LogInViewController: UIViewController {
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
    
    private let logInButton: UIButton = .init(type: .system)
    private let appleLogInButton: UIButton = .init(type: .system)
    private let kakaoLogInButton: UIButton = .init(type: .system)
    private let googleLogInButton: UIButton = .init(type: .system)
    private let naverLogInButton: UIButton = .init(type: .system)
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
    
    private let viewModel: LogInViewModel
    private let disposeBag: DisposeBag
    
    init(viewModel: LogInViewModel) {
        self.viewModel = viewModel
        self.disposeBag = .init()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureRootView()
        configureButtons()
        setSubviews()
        setConstraints()
        setBindings()
    }
    
    private func configureRootView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureButtons() {
        let buttons = [logInButton, appleLogInButton, googleLogInButton,
         naverLogInButton, kakaoLogInButton]
        
        buttons.forEach { $0.tintColor = .systemBlue }
        logInButton.setTitle("로그인", for: .normal)
        appleLogInButton.setTitle("애플로그인", for: .normal)
        googleLogInButton.setTitle("구글로그인", for: .normal)
        naverLogInButton.setTitle("네이버로그인", for: .normal)
        kakaoLogInButton.setTitle("카카오로그인", for: .normal)
    }
    
    private func setSubviews() {
        buttonStackView.addArrangedSubview(logInButton)
        buttonStackView.addArrangedSubview(appleLogInButton)
        buttonStackView.addArrangedSubview(kakaoLogInButton)
        buttonStackView.addArrangedSubview(googleLogInButton)
        buttonStackView.addArrangedSubview(naverLogInButton)
        
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
    
    private func setBindings() {
        let email = emailTextField.textField.rx.text.orEmpty.distinctUntilChanged()
        let password = passwordTextField.textField.rx.text.orEmpty.distinctUntilChanged()
        let logInButtonTapped = logInButton.rx.tap.asObservable()
        let kakaoLogInButtonTapped = kakaoLogInButton.rx.tap.asObservable()
        
        let input = LogInViewModel.Input(email: email,
                                         password: password,
                                         logInButtonTapped: logInButtonTapped,
                                         kakaoLogInButtonTapped: kakaoLogInButtonTapped)
        
        let output = viewModel.transform(input)
        
        output.userInputsValidation.drive(with: self, onNext: { owner, validationResult in
            owner.emailTextField.setTextFieldBorder(isRed: validationResult.0)
            owner.passwordTextField.setTextFieldBorder(isRed: validationResult.1)
        })
        .disposed(by: disposeBag)
        
        output.isEnableLogInButton.drive(with: self, onNext: { owner, isEnableLogInButton in
            owner.logInButton.isEnabled = isEnableLogInButton
        })
        .disposed(by: disposeBag)
        
        output.kakaoLogIn
            .subscribe()
            .disposed(by: disposeBag)
        
        output.logInSucceeded
            .subscribe()
            .disposed(by: disposeBag)
    }
}
