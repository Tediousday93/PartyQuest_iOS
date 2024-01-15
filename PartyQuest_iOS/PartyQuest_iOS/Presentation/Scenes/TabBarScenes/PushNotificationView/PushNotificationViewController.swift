//
//  PushNotificationViewController.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2024/01/03.
//

import UIKit
import RxSwift
import RxCocoa

final class PushNotificationViewController: UIViewController {
    private typealias PushNotificationCellRegistration = UICollectionView.CellRegistration<PushNotificationCell, PushNotification>
    private lazy var collectionView: UICollectionView = .init(frame: .zero,
                                                              collectionViewLayout: collectionViewLayout())
    
    private let viewModel: PushNotificationViewModel
    private var disposeBag: DisposeBag
    
    init(viewModel: PushNotificationViewModel) {
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
        configureCollectionView()
        setSubviews()
        setConstraints()
        setBindings()
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.12)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureNavigationBar() {
        let navigationTitleLabel = UILabel()
        navigationTitleLabel.textAlignment = .left
        navigationTitleLabel.font = .boldSystemFont(ofSize: 20)
        navigationTitleLabel.text = "알림센터"
        navigationTitleLabel.textColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationTitleLabel)
    }
    
    private func configureRootView() {
        view.backgroundColor = .systemGray6
    }
    
    private func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
    }
    
    private func setSubviews() {
        view.addSubview(collectionView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: PQSpacing.side),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -PQSpacing.side),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setBindings() {
        let viewWillAppearEvent = self.rx.viewWillAppear
        
        let input = PushNotificationViewModel.Input(
            viewWillAppearEvent: viewWillAppearEvent
        )
        
        let output = viewModel.transform(input)
        
        let cellRegistration = PushNotificationCellRegistration { cell, indexPath, item in
            cell.configure(with: item)
        }
        output.dataSource
            .bind(to: collectionView.rx.items) { collectionView, row, item in
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                    for: IndexPath(item: row, section: 0),
                                                                    item: item)
            }
            .disposed(by: disposeBag)
    }
}
