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
        let cancelBarButtonTapped = cancelButton.rx.tap.asObservable()
        
        let modifyButtonTapped = modifyingListViewController.collectionView.rx
            .willDisplayCell
            .compactMap { cell, indexPath in
                if let modifyingListCell = cell as? ModifyingListCell {
                    return (modifyingListCell, indexPath)
                }
                return nil
            }
            .flatMap { (modifyingListCell, indexPath) in
                modifyingListCell.modifyButton.rx.tap.asObservable()
                    .flatMap { event in
                        Observable.just((event: event, itemIndex: indexPath.item))
                    }
            }
        
        let willDeallocated = self.rx.deallocating
        
        let input = CreatePartyViewModel.Input(
            cancelBarButtonTapped: cancelBarButtonTapped,
            modifyButtonTapped: modifyButtonTapped,
            willDeallocated: willDeallocated
        )
        let output = viewModel.transform(input)
        
        output.partyInfoItems
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, items in
                owner.modifyingListViewController.applySnapshot(with: items)
            })
            .disposed(by: disposeBag)
        
        output.dismiss
            .drive()
            .disposed(by: disposeBag)
        
        output.modifyingViewPresented
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
    }
}
