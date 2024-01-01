//
//  PartyCardCollectionViewController.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2024/01/01.
//

import UIKit
import RxSwift
import RxCocoa

final class PartyCardCollectionViewController: UIViewController {
    let items: BehaviorRelay<[PartyItem]> = .init(value: [])
    
    private enum Section {
        case main
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, PartyItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, PartyItem>
    private typealias PartyCardCellRegistration = UICollectionView.CellRegistration<PartyCardCell, PartyItem>
    
    lazy var collectionView: UICollectionView = .init(frame: .zero,
                                                              collectionViewLayout: collectionViewLayout())
    
    private var dataSource: DataSource!
    private var disposeBag: DisposeBag
    
    init() {
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
        configureRootView()
        setSubviews()
        setConstraints()
        configureCollectionView()
        configureDataSource()
        setBindings()
    }
    
    private func configureRootView() {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
    }
    
    private func setSubviews() {
        view.addSubview(collectionView)
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
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        section.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 15)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
    }
    
    private func setBindings() {
        items.skip(1)
            .withUnretained(self)
            .bind(onNext: { owner, items in
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
