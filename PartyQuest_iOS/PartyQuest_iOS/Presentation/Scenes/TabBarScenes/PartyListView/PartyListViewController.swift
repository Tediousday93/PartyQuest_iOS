//
//  PartyListViewController.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/11/29.
//

import UIKit
import RxSwift
import RxCocoa

final class PartyListViewController: UIViewController {
    private let collectionViewController: PartyCardCollectionViewController = .init()
    
    private let plusButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "floatingPlus_button")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let viewModel: PartyListViewModel
    private let disposeBag: DisposeBag
    
    init(viewModel: PartyListViewModel) {
        self.viewModel = viewModel
        self.disposeBag = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        let navigationTitleLabel = UILabel()
        navigationTitleLabel.textAlignment = .left
        navigationTitleLabel.font = .boldSystemFont(ofSize: 20)
        navigationTitleLabel.text = "파티 목록"
        navigationTitleLabel.textColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationTitleLabel)
    }
    
    private func configureRootView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setSubviews() {
        view.addSubview(collectionViewController.view)
        view.addSubview(plusButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            collectionViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            plusButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            plusButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    
    private func setBindings() {
        let viewWillAppearEvent = self.rx.viewWillAppear
        let plusButtonTapped = plusButton.rx.tap.map { _ in }
        let input = PartyListViewModel.Input(
            viewWillAppearEvent: viewWillAppearEvent,
            plusButtonTapped: plusButtonTapped
        )
        let output = viewModel.transform(input)
        
        output.partyItems
            .bind(to: collectionViewController.items)
            .disposed(by: disposeBag)
        
        output.createPartyPushed
            .drive()
            .disposed(by: disposeBag)
    }
}
