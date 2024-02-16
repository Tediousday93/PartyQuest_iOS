//
//  QuestListViewController.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2024/01/03.
//

import UIKit
import RxSwift
import RxCocoa

final class QuestListViewController: UIViewController {
    private enum QuestListSection {
        case main
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<QuestListSection, QuestItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<QuestListSection, QuestItem>
    typealias QuestCardCellRegistration = UICollectionView.CellRegistration<QuestCardCell, QuestItem>
    typealias AddButtonRegistration = UICollectionView.SupplementaryRegistration<CollectionReusableButton>
    
    lazy var collectionView: UICollectionView = {
        let colletionView = UICollectionView(frame: .zero,
                                             collectionViewLayout: createCollectionViewLayout())
        colletionView.translatesAutoresizingMaskIntoConstraints = false
        
        return colletionView
    }()
    
    private var dataSource: DataSource!
    private var disposeBag: DisposeBag
    let status: QuestStatus
    let items: BehaviorRelay<[QuestItem]> = .init(value: [])
    
    init(status: QuestStatus) {
        self.disposeBag = .init()
        self.status = status
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureRootView()
        setSubviews()
        setConstraints()
        configureDataSource()
        setBindings()
    }

    private func configureRootView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setSubviews() {
        view.addSubview(collectionView)
    }
    
    private func setConstraints() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safe.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
        ])
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { section, env -> NSCollectionLayoutSection? in
            let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            let listSection = NSCollectionLayoutSection.list(using: config, layoutEnvironment: env)
            
            if self.status == .todo {
                let addButtonSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                           heightDimension: .fractionalWidth(0.13))
                let addButton = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: addButtonSize,
                    elementKind: "AddQuestButton",
                    alignment: .top
                )
                listSection.boundarySupplementaryItems = [addButton]
            }
            
            listSection.interGroupSpacing = PQSpacing.cell
            listSection.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            return listSection
        }
        
        return layout
    }
    
    private func configureDataSource() {
        let questCardCellRegistration = QuestCardCellRegistration { cell, indexPath, quest in
            cell.configure(with: quest)
        }
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, quest in
            return collectionView.dequeueConfiguredReusableCell(using: questCardCellRegistration,
                                                                for: indexPath,
                                                                item: quest)
        }
        
        let addButtonRegistration = AddButtonRegistration(elementKind: "AddQuestButton") {
            supplementaryView, elementKind, indexPath in
            supplementaryView.setButtonTitle(string: "+")
            supplementaryView.setButtonColor(for: PQColor.buttonSub)
            supplementaryView.setButtonTitleStyle(size: 35, weight: .heavy)
        }
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, elementekind, indexPath in
            if self?.status == .todo,
               elementekind == "AddQuestButton" {
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: addButtonRegistration,
                    for: indexPath
                )
            }
            return nil
        }
    }
    
    private func applySnapshot(items: [QuestItem]) {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        
        dataSource.apply(snapshot)
    }
    
    private func setBindings() {
        items
            .withUnretained(self)
            .subscribe { owner, quests in
                owner.applySnapshot(items: quests)
            }
            .disposed(by: disposeBag)
    }
}
