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
    
    private let collectionView: UICollectionView = .init()
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
        setSubviews()
        setConstraints()
        configureCollectionView()
        configureDataSource()
        setBindings()
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
        collectionView.setCollectionViewLayout(collectionViewLayout(), animated: true)
        collectionView.register(
            PartyCollectionViewCell.self,
            forCellWithReuseIdentifier: PartyCollectionViewCell.reuseID
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.95),
            heightDimension: .fractionalHeight(0.3)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureDataSource() {
        dataSource = .init(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PartyCollectionViewCell.reuseID,
                for: indexPath
            ) as! PartyCollectionViewCell
            cell.configure(with: item)
            
            return cell
        }
    }
    
    private func setBindings() {
        let viewDidLoadEvent = rx.methodInvoked(#selector(WelcomeViewController.viewDidLoad))
            .map { _ in}
        let input = PartyListViewModel.Input(viewDidLoadEvent: viewDidLoadEvent)
        let output = viewModel.transform(input)
        
        output.partyItemViewModels
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
