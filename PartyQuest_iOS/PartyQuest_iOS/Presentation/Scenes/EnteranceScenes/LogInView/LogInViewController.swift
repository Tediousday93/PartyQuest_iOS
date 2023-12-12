//
//  LogInViewController.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/10/27.
//

import UIKit
import RxSwift
import RxCocoa
import GoogleSignIn

final class LogInViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.text = "PartyQuest 로그인"
        label.textColor = .black
        label.numberOfLines = 1
        
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
    
    private let logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 0.329,
                                         green: 0.247,
                                         blue: 0.827,
                                         alpha: 1)
        button.layer.cornerRadius = 15
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.titleLabel?.tintColor = .systemBackground
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let logInStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let findIDButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("아이디 찾기", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        button.tintColor = .gray
        
        return button
    }()
    
    private let findPWButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("비밀번호 찾기", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        button.tintColor = .gray
        
        return button
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원가입", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        button.tintColor = .gray
        
        return button
    }()
    
    private let findStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 3
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 0, left: 0, bottom: 60, right: 0)
        stackView.translatesAutoresizingMaskIntoConstraints = false
                
        return stackView
    }()
    
    private let appleLogInButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "appleid_button_black"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    private let kakaoLogInButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "kakaoid_button"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowRadius = 2
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private let googleLogInButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "googleid_button"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowRadius = 2
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private let naverLogInButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "naverid_button"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowRadius = 2
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    private let socialLoginStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let outterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 0, left: 20, bottom: 10, right: 20)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let viewModel: LogInViewModel
    private var disposeBag: DisposeBag
    
    init(viewModel: LogInViewModel) {
        self.viewModel = viewModel
        self.disposeBag = .init()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        disposeBag = .init()
        print("LogInViewContorller deinited")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureRootView()
        setSubviews()
        setConstraints()
        setBindings()
    }
    
    private func configureNavigationBar() {
        self.title = "PartyQuest 로그인"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func configureRootView() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
    }
    
    private func setSubviews() {
        logInStackView.addArrangedSubview(titleLabel)
        logInStackView.addArrangedSubview(descriptionLabel)
        logInStackView.addArrangedSubview(emailTextField)
        logInStackView.addArrangedSubview(passwordTextField)
        logInStackView.addArrangedSubview(logInButton)
        
        [findIDButton, findPWButton, signUpButton].forEach {
            findStackView.addArrangedSubview($0)
        }
        
        [appleLogInButton, kakaoLogInButton,
         googleLogInButton, naverLogInButton].forEach {
            socialLoginStackView.addArrangedSubview($0)
        }
        
        outterStackView.addArrangedSubview(logInStackView)
        outterStackView.addArrangedSubview(findStackView)
        outterStackView.addArrangedSubview(socialLoginStackView)
        scrollView.addSubview(outterStackView)
    }
    
    private func setConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        let buttonHeight = safeArea.layoutFrame.height * 0.065
        let socialLoginButtonHeight = safeArea.layoutFrame.height * 0.058
        let scrollContentGuide = scrollView.contentLayoutGuide
        let scrollFrameGuide = scrollView.frameLayoutGuide
        
        NSLayoutConstraint.activate([
            logInButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            appleLogInButton.heightAnchor.constraint(equalToConstant: socialLoginButtonHeight),
            kakaoLogInButton.heightAnchor.constraint(equalToConstant: socialLoginButtonHeight),
            googleLogInButton.heightAnchor.constraint(equalToConstant: socialLoginButtonHeight),
            naverLogInButton.heightAnchor.constraint(equalToConstant: socialLoginButtonHeight),
            
            outterStackView.topAnchor.constraint(equalTo: scrollContentGuide.topAnchor),
            outterStackView.leadingAnchor.constraint(equalTo: scrollContentGuide.leadingAnchor),
            outterStackView.trailingAnchor.constraint(equalTo: scrollContentGuide.trailingAnchor),
            outterStackView.bottomAnchor.constraint(equalTo: scrollContentGuide.bottomAnchor),
            
            outterStackView.leadingAnchor.constraint(equalTo: scrollFrameGuide.leadingAnchor),
            outterStackView.trailingAnchor.constraint(equalTo: scrollFrameGuide.trailingAnchor),
            
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
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
        let naverLogInButtonTapped = naverLogInButton.rx.tap.asObservable()
        let googleLogInButtonTapped = googleLogInButton.rx.tap.asObservable()
        
        let input = LogInViewModel.Input(
            email: email,
            password: password,
            logInButtonTapped: logInButtonTapped,
            kakaoLogInButtonTapped: kakaoLogInButtonTapped,
            googleLogInButtonTapped: googleLogInButtonTapped,
            naverLogInButtonTapped: naverLogInButtonTapped
        )
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
    }
}
