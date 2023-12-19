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
    private enum Section {
        case main
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, PartyItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, PartyItem>
    private typealias PartyCardCellRegistration = UICollectionView.CellRegistration<PartyCardCell, PartyItem>
    private typealias PartyListHeaderRegistration = UICollectionView.SupplementaryRegistration<PartyListHeaderView>
    
    private lazy var collectionView: UICollectionView = .init(frame: .zero,
                                                              collectionViewLayout: collectionViewLayout())
    private var dataSource: DataSource!
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
        configureCollectionView()
        configureDataSource()
        setBindings()
    }
    
    private func configureNavigationBar() {
        self.title = "PartyQuest"
    }
    
    private func configureRootView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setSubviews() {
        view.addSubview(collectionView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 15, leading: 15, bottom: 15, trailing: 15)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.3)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(70)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.interGroupSpacing = 15
        section.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 15)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureDataSource() {
        let cellRegistration = PartyCardCellRegistration { cell, indexPath, item in
            cell.configure(with: item)
        }
        dataSource = .init(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item
            )
            return cell
        }
        
        let headerRegistration = PartyListHeaderRegistration(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { supplementaryView, elementKind, indexPath in
            supplementaryView.setTitle("파티 목록")
        }
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            let headerView = collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration,
                for: indexPath
            )
            return headerView
        }
    }
    
    private func setBindings() {
        let viewWillAppearEvent = rx.sentMessage(#selector(PartyListViewController.viewWillAppear))
            .map { _ in}
        let input = PartyListViewModel.Input(
            viewWillAppearEvent: viewWillAppearEvent
        )
        let output = viewModel.transform(input)
        
        output.partyItemViewModels
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, items in
                owner.applySnapshot(items: items)
            })
            .disposed(by: disposeBag)
    }
    
    private func applySnapshot(items: [PartyItem]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot)
    }
}
