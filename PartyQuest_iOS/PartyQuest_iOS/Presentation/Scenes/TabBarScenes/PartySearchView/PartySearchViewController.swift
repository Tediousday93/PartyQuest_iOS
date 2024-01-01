//
//  PartySearchViewController.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2024/01/01.
//

import UIKit
import RxSwift
import RxCocoa

final class PartySearchViewController: UIViewController {
    private let dropDownButton: DropDownButton = {
        let menuItems = ["파티 이름", "파티장"]
        let button = DropDownButton(menuItems: menuItems, menuHeight: 100)
        button.setButton(title: "검색기준")
        button.setTitleInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.tintColor = .placeholderText
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 0, left: 8, bottom: 0, right: 8)
        stackView.addArrangedSubview(imageView)
        
        textField.leftView = stackView
        textField.leftViewMode = .always
        textField.placeholder = "Search Party"
        textField.backgroundColor = .systemGray5
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .preferredFont(forTextStyle: .body)
        textField.layer.cornerRadius = 10
        
        return textField
    }()
    
    private let collectionViewController: PartyCardCollectionViewController = .init()
    
    private let viewModel: PartySearchViewModel
    private var disposeBag: DisposeBag
    
    init(viewModel: PartySearchViewModel) {
        self.viewModel = viewModel
        self.disposeBag = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.disposeBag = .init()
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
        title = "파티 찾기"
    }
    
    private func configureRootView() {
        view.backgroundColor = .systemGray6
    }
    
    private func setSubviews() {
        view.addSubview(searchTextField)
        view.addSubview(collectionViewController.view)
        view.addSubview(dropDownButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            dropDownButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            dropDownButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: PQSpacing.side),
            dropDownButton.trailingAnchor.constraint(equalTo: searchTextField.leadingAnchor, constant: -5),
            dropDownButton.heightAnchor.constraint(equalToConstant: 150),
            dropDownButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.26),
            
            searchTextField.topAnchor.constraint(equalTo: dropDownButton.topAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -PQSpacing.side),
            searchTextField.heightAnchor.constraint(equalToConstant: 50),
            
            collectionViewController.view.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 15),
            collectionViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setBindings() {
        let viewWillAppearEvent = rx.sentMessage(#selector(PartyListViewController.viewWillAppear))
            .map { _ in}
        let input = PartySearchViewModel.Input(
            viewWillAppearEvent: viewWillAppearEvent
        )
        
        let output = viewModel.transform(input)
        
        output.partyItems
            .bind(to: collectionViewController.items)
            .disposed(by: disposeBag)
    }
}
