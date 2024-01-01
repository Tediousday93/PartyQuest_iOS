//
//  HomeViewController.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/27.
//

import UIKit
import RxSwift

final class HomeViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    typealias UserProfileCellRegistration = UICollectionView.CellRegistration<UserProfileCell, UserProfile>
    typealias WeekActivityCellRegistration = UICollectionView.CellRegistration<WeekActivityCell, WeekActivity>
    typealias DoingQuestCellRegistration = UICollectionView.CellRegistration<DoingQuestCell, Quest>
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<HeaderView>
    
    private var dataSource: DataSource!
    
    private let welcomLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.text = "Harry님, 환영합니다!"
        label.textColor = PQColor.text
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let colletionView = UICollectionView(frame: .zero,
                                             collectionViewLayout: createCollectionViewLayout())
        colletionView.translatesAutoresizingMaskIntoConstraints = false
        
        return colletionView
    }()
    
    private let viewModel: HomeViewModel
    private var disposeBag: DisposeBag
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        self.disposeBag = .init()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        disposeBag = .init()
        print("welcomeViewController deinited")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureRootView()
        setSubViews()
        setTabBarItem()
        setConstraint()
        configureDataSource()
        setBindings()
    }
    
    private func configureRootView() {
        view.backgroundColor = PQColor.lightGray
    }
    
    private func setSubViews() {
        view.addSubview(collectionView)
    }
    
    private func setTabBarItem() {
        let tabBarImage = UIImage(systemName: "house")
        let tabBarSelectedImage = UIImage(systemName: "house.fill")
        
        self.tabBarItem = .init(title: nil, image: tabBarImage, selectedImage: tabBarSelectedImage)
    }
    
    private func setConstraint() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safe.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
        ])
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let sectionDecoration = NSCollectionLayoutDecorationItem
            .background(elementKind: "ShadowDecoration")
        let layout = UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            switch section {
            case 0:
                let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .absolute(25))
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: "ProfileHeader",
                    alignment: .top
                )
                
                let listSection = NSCollectionLayoutSection.list(using: config, layoutEnvironment: env)
                listSection.contentInsets = .init(top: 20, leading: 20, bottom: 40, trailing: 20)
                listSection.boundarySupplementaryItems = [header]
                sectionDecoration.contentInsets = .init(top: 45, leading: 20, bottom: 40, trailing: 20)
                listSection.decorationItems = [sectionDecoration]
                
                
                return listSection
            case 1:
                let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .absolute(20))
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: "ActivityHeader",
                    alignment: .top
                )
                let listSection = NSCollectionLayoutSection.list(using: config, layoutEnvironment: env)
                listSection.contentInsets = .init(top: 15, leading: 20, bottom: 35, trailing: 20)
                listSection.boundarySupplementaryItems = [header]
                sectionDecoration.contentInsets = .init(top: 35, leading: 20, bottom: 35, trailing: 20)
                listSection.decorationItems = [sectionDecoration]
                
                return listSection
                
            default:
                var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
                config.showsSeparators = false
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .absolute(20))
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: "DoingQuestHeader",
                    alignment: .top
                )
                let listSection = NSCollectionLayoutSection.list(using: config, layoutEnvironment: env)
                listSection.contentInsets = .init(top: 15, leading: 20, bottom: 35, trailing: 20)
                listSection.boundarySupplementaryItems = [header]
                sectionDecoration.contentInsets = .init(top: 35, leading: 20, bottom: 35, trailing: 20)
                listSection.decorationItems = [sectionDecoration]
                
                return listSection
            }
        }
        
        layout.register(ShadowDecorationView.self, forDecorationViewOfKind: "ShadowDecoration")
        
        return layout
    }
    
    private func configureDataSource() {
        let userProfileCellRegistration = UserProfileCellRegistration { cell, indexPath, userProfile in
            cell.accessories = [.disclosureIndicator()]
            cell.configure(with: userProfile)
        }
        
        let weekActivityCellRegistration = WeekActivityCellRegistration { cell, indexPath, weekActivity in
            cell.configure(with: weekActivity)
        }
        
        let doingQuestCellRegistration = DoingQuestCellRegistration { cell, indexPath, doingQuest in
            cell.configure(with: doingQuest)
        }
        
        let profileHeaderRegistration = HeaderRegistration(elementKind: "ProfileHeader") {
            supplementaryView, elementKind, indexPath in
            supplementaryView.setFont(PQFont.subTitle)
            supplementaryView.configureTitle(string: "Harry님, 환영합니다!")
        }
        
        let activityHeaderRegistration = HeaderRegistration(elementKind: "ActivityHeader") {
            supplementaryView, elementKind, indexPath in
            supplementaryView.configureTitle(string: "이번주 활동")
        }
        
        let doingQuestHeaderRegistration = HeaderRegistration(elementKind: "DoingQuestHeader") {
            supplementaryView, elementKind, indexPath in
            supplementaryView.configureTitle(string: "진행중인 퀘스트")
        }
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            if let profile = item as? UserProfile {
                return collectionView.dequeueConfiguredReusableCell(using: userProfileCellRegistration,
                                                                    for: indexPath,
                                                                    item: profile)
            } else if let activity = item as? WeekActivity {
                return collectionView.dequeueConfiguredReusableCell(using: weekActivityCellRegistration,
                                                                    for: indexPath,
                                                                    item: activity)
            } else if let quest = item as? Quest {
                return collectionView.dequeueConfiguredReusableCell(using: doingQuestCellRegistration,
                                                                    for: indexPath,
                                                                    item: quest)
            }
            
            return UICollectionViewCell()
        }
        
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            if elementKind == "ProfileHeader" {
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: profileHeaderRegistration,
                    for: indexPath
                )
            } else if elementKind == "ActivityHeader" {
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: activityHeaderRegistration,
                    for: indexPath
                )
            } else if elementKind == "DoingQuestHeader" {
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: doingQuestHeaderRegistration,
                    for: indexPath
                )
            }
            
            return nil
        }
    }
    
    private func applySnapshot(profiles: [UserProfile], activities: [WeekActivity], doingQuests: [Quest]) {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.userProfile, .weekActivity, .doingQuest])
        snapshot.appendItems(profiles, toSection: .userProfile)
        snapshot.appendItems(activities, toSection: .weekActivity)
        snapshot.appendItems(doingQuests, toSection: .doingQuest)
        
        self.dataSource.apply(snapshot)
    }
    
    private func setBindings() {
        let viewWillAppearEvent = rx.sentMessage(#selector(HomeViewController.viewWillAppear))
            .map { _ in }
        
        let input = HomeViewModel.Input(viewWillAppearEvent: viewWillAppearEvent)
        
        let output = viewModel.transform(input)
        
        output.homeItems
            .withUnretained(self)
            .subscribe { owner, items in
                owner.applySnapshot(profiles: [items.userProfile],
                                    activities: [items.weekActivity],
                                    doingQuests: items.doingQuests)
            }
            .disposed(by: disposeBag)
    }
}

enum Section {
    case userProfile
    case weekActivity
    case doingQuest
}
