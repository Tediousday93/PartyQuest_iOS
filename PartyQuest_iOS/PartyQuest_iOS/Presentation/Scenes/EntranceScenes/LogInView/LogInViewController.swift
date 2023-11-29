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
        let textField = TitledTextfield()
        textField.setTitle("이메일")
        textField.setPlaceholder("username@example.com")
        textField.setCaption(" ")
        
        return textField
    }()
    
    private let passwordTextField: TitledTextfield = {
        let textField = TitledTextfield()
        textField.setTitle("패스워드")
        textField.setPlaceholder("영문 대/소문자, 특수문자 한 개 이상 포함 8~15자")
        textField.setCaption(" ")
        textField.textField.isSecureTextEntry = true
        
        return textField
    }()
    
    private let logInButton: UIButton = .init(type: .system)
    private let appleLogInButton: UIButton = SocialLogInButton(platform: .apple)
    private let kakaoLogInButton: UIButton = SocialLogInButton(platform: .kakao)
    private let googleLogInButton: UIButton = SocialLogInButton(platform: .google)
    private let naverLogInButton: UIButton = SocialLogInButton(platform: .naver)
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 20, left: 20, bottom: 20, right: 20)
        
        return stackView
    }()
    
    private let outterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 20
        stackView.layoutMargins = .init(top: 0, left: 10, bottom: 0, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
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
        logInButton.setTitle("로그인", for: .normal)
    }
    
    private func setSubviews() {
        [appleLogInButton, kakaoLogInButton,
         googleLogInButton, naverLogInButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        outterStackView.addArrangedSubview(titleLabel)
        outterStackView.addArrangedSubview(descriptionLabel)
        outterStackView.addArrangedSubview(emailTextField)
        outterStackView.addArrangedSubview(passwordTextField)
        outterStackView.addArrangedSubview(logInButton)
        outterStackView.addArrangedSubview(buttonStackView)
        
        view.addSubview(outterStackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            outterStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            outterStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            outterStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }
    
    private func setBindings() {
        let email = emailTextField.textField.rx.text
            .orEmpty
            .distinctUntilChanged()
        let password = passwordTextField.textField.rx.text
            .orEmpty
            .distinctUntilChanged()
        let logInButtonTapped = logInButton.rx.tap.asObservable()
        let kakaoLogInButtonTapped = kakaoLogInButton.rx.tap.asObservable()
        
        let input = LogInViewModel.Input(email: email,
                                         password: password,
                                         logInButtonTapped: logInButtonTapped,
                                         kakaoLogInButtonTapped: kakaoLogInButtonTapped)
        
        let output = viewModel.transform(input)
        
        output.inputStates
            .drive(with: self, onNext: { owner, inputStates in
                owner.emailTextField.inputStateRelay.accept(inputStates.0)
                owner.passwordTextField.inputStateRelay.accept(inputStates.1)
            })
            .disposed(by: disposeBag)
        
        output.isEnableLogInButton
            .drive(with: self, onNext: { owner, isEnableLogInButton in
                owner.logInButton.isEnabled = isEnableLogInButton
            })
            .disposed(by: disposeBag)
        
        output.jwtSaved
            .subscribe()
            .disposed(by: disposeBag)
            
        output.logInSucceeded
            .subscribe()
            .disposed(by: disposeBag)
    }
}
