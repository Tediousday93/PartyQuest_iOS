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
    
    private let partyItemView: PartyItemView = {
        let partyItemView = PartyItemView()
        partyItemView.translatesAutoresizingMaskIntoConstraints = false
        
        return partyItemView
    }()
    
    private let modifyingListViewController: ModifyingListViewController = {
        let viewController = ModifyingListViewController()
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return viewController
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
        view.backgroundColor = .systemGray6
    }
    
    private func setSubviews() {
        [partyItemView, modifyingListViewController.view].forEach {
            view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        let modifyingListView = modifyingListViewController.view!
        
        NSLayoutConstraint.activate([
            partyItemView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            partyItemView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            partyItemView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            modifyingListView.topAnchor.constraint(equalTo: partyItemView.bottomAnchor, constant: 16),
            modifyingListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            modifyingListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            modifyingListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
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
