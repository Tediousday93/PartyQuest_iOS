//
//  CreatePartyViewController.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/12/19.
//

import UIKit
import RxSwift
import RxCocoa

final class CreatePartyViewController: UIViewController {
    private let cancelButton: UIBarButtonItem = .init(
        title: "취소",
        style: .plain,
        target: nil,
        action: nil
    )
    private let completeButton: UIBarButtonItem = .init(
        title: "완료",
        style: .plain,
        target: nil,
        action: nil
    )
    
    private let partyNameTextField: TitledTextfield = {
        let titledTextField = TitledTextfield()
        titledTextField.setTitle("파티 이름")
        
        return titledTextField
    }()
    
    private let introductionTextView: TitledTextView = {
        let textView = TitledTextView()
        textView.setTitle("파티 소개")
        textView.setTextFieldBorder(flag: true)
        
        return textView
    }()
    
    private let memberCountLabel: UILabel = {
        let label = UILabel()
        label.text = "인원 수"
        label.font = .preferredFont(forTextStyle: .callout)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var dropDownButton: DropDownButton = {
        let menuItems = Array(1...30).map { String($0) }
        let button = DropDownButton(menuItems: menuItems)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = PQSpacing.margin
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let viewModel: CreatePartyViewModel
    private var disposeBag: DisposeBag
    
    init(viewModel: CreatePartyViewModel) {
        self.viewModel = viewModel
        self.disposeBag = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        disposeBag = .init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureRootView()
        setSubviews()
        setConstraints()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "파티만들기"
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = completeButton
    }
    
    private func configureRootView() {
        view.backgroundColor = UIColor.systemGray6
    }
    
    private func setSubviews() {
        stackView.addArrangedSubview(partyNameTextField)
        stackView.addArrangedSubview(introductionTextView)
        
        view.addSubview(stackView)
        view.addSubview(memberCountLabel)
        view.addSubview(dropDownButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: memberCountLabel.topAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            memberCountLabel.leadingAnchor.constraint(equalTo: partyNameTextField.leadingAnchor),
            memberCountLabel.bottomAnchor.constraint(equalTo: dropDownButton.topAnchor, constant: -3),
            
            dropDownButton.leadingAnchor.constraint(equalTo: partyNameTextField.leadingAnchor),
            dropDownButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.3),
            dropDownButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
