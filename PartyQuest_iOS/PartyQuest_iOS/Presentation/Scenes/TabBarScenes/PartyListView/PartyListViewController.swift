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
    
    private lazy var collectionView: UICollectionView = .init(frame: .zero,
                                                              collectionViewLayout: collectionViewLayout())
    private let plusButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "floatingPlus_button")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
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
        let navigationTitleLabel = UILabel()
        navigationTitleLabel.textAlignment = .left
        navigationTitleLabel.font = .boldSystemFont(ofSize: 25)
        navigationTitleLabel.text = "파티 목록"
        navigationTitleLabel.textColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: navigationTitleLabel)
    }
    
    private func configureRootView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setSubviews() {
        view.addSubview(collectionView)
        view.addSubview(plusButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            plusButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            plusButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .clear
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
        
        let section = NSCollectionLayoutSection(group: group)
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
    }
    
    private func setBindings() {
        let viewWillAppearEvent = rx.sentMessage(#selector(PartyListViewController.viewWillAppear))
            .map { _ in}
        let plusButtonTapped = plusButton.rx.tap.map { _ in }
        let input = PartyListViewModel.Input(
            viewWillAppearEvent: viewWillAppearEvent,
            plusButtonTapped: plusButtonTapped
        )
        let output = viewModel.transform(input)
        
        output.partyItemViewModels
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, items in
                owner.applySnapshot(items: items)
            })
            .disposed(by: disposeBag)
        
        output.createPartyPushed
            .drive()
            .disposed(by: disposeBag)
    }
    
    private func applySnapshot(items: [PartyItem]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot)
    }
}
