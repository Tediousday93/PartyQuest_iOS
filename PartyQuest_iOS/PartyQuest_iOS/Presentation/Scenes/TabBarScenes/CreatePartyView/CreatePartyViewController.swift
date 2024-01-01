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
    
    private let completeButton: UIBarButtonItem = {
        let item = UIBarButtonItem(
            title: "완료",
            style: .plain,
            target: nil,
            action: nil
        )
        item.isEnabled = false
        
        return item
    }()
    
    private let partyNameTextField: TitledTextField = {
        let titledTextField = TitledTextField()
        titledTextField.setTitle("파티 이름")
        titledTextField.setTextFieldBorder(color: .systemGray4)
        
        return titledTextField
    }()
    
    private let introductionTextView: TitledTextView = {
        let textView = TitledTextView()
        textView.setTitle("파티 소개")
        textView.setTextViewBorder(color: .systemGray4)
        
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
        let button = DropDownButton(menuItems: menuItems,
                                    menuHeight: 200)
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
        setBindings()
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
            dropDownButton.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func setBindings() {
        let cancelBarButtonTapped = cancelButton.rx.tap.map { _ in }
        let partyName = partyNameTextField.textField.rx.text
            .orEmpty
            .distinctUntilChanged()
        let introduction = introductionTextView.textView.rx.text
            .orEmpty
            .distinctUntilChanged()
        let memberCount = dropDownButton.tableView.rx.itemSelected
            .withUnretained(self)
            .compactMap { owner, _ in
                owner.dropDownButton.titleButton.currentTitle
            }
            .distinctUntilChanged()
        let willDeallocated = self.rx.deallocating
        
        let input = CreatePartyViewModel.Input(
            cancelBarButtonTapped: cancelBarButtonTapped,
            partyName: partyName,
            introduction: introduction,
            memberCount: memberCount,
            willDeallocated: willDeallocated
        )
        let output = viewModel.transform(input)
        
        output.dismiss
            .drive()
            .disposed(by: disposeBag)
        
        output.isEnableCompleteBarButton
            .drive(with: self, onNext: { owner, isEnable in
                owner.completeButton.isEnabled = isEnable
            })
            .disposed(by: disposeBag)
        
        output.coordinatorFinished
            .subscribe()
            .disposed(by: disposeBag)
        
        partyNameTextField.textField.rx.controlEvent(.editingDidBegin)
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.partyNameTextField.setTextFieldBorder(color: PQColor.buttonMain)
            })
            .disposed(by: disposeBag)
        
        partyNameTextField.textField.rx.controlEvent(.editingDidEnd)
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.partyNameTextField.setTextFieldBorder(color: .systemGray4)
            })
            .disposed(by: disposeBag)
        
        introductionTextView.textView.rx.didBeginEditing
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.introductionTextView.setTextViewBorder(color: PQColor.buttonMain)
            })
            .disposed(by: disposeBag)
        
        introductionTextView.textView.rx.didEndEditing
            .asDriver()
            .drive(with: self, onNext: { owner, _ in
                owner.introductionTextView.setTextViewBorder(color: .systemGray4)
            })
            .disposed(by: disposeBag)
    }
}
