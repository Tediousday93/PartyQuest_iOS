//
//  ModifyingListViewController.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2024/02/02.
//

import UIKit

struct ModifyingItem: Hashable {
    let title: String
    let value: String
}

final class ModifyingListViewController: UIViewController {
    private enum Section {
        case main
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, ModifyingItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ModifyingItem>
    private typealias ModifyingListCellRegistration = UICollectionView.CellRegistration<ModifyingListCell, ModifyingItem>
    
    let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: .init())
    
    private var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRootView()
        configureCollectionView()
        setSubviews()
        setConstraints()
    }
    
    private func configureRootView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        
        setCollectionViewLayout()
        configureDataSource()
    }
    
    private func setCollectionViewLayout() {
        let layout = UICollectionViewCompositionalLayout { section, environment in
            let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
            let section = NSCollectionLayoutSection.list(
                using: configuration,
                layoutEnvironment: environment
            )
            section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
            return section
        }
        
        collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    private func configureDataSource() {
        let modifyingListCellRegistration = ModifyingListCellRegistration { cell, _, item in
            cell.configure(with: item)
        }
        
        dataSource = .init(collectionView: collectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(
                using: modifyingListCellRegistration,
                for: indexPath,
                item: item
            )
        }
    }
    
    private func setSubviews() {
        view.addSubview(collectionView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension ModifyingListViewController {
    func applySnapshot(with items: [ModifyingItem]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot)
    }
}
