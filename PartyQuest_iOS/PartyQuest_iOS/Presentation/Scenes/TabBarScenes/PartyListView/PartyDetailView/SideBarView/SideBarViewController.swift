//
//  SideBarViewController.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2024/01/23.
//

import UIKit
import RxSwift
import RxCocoa

final class SideBarViewController: UIViewController {
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = PQFont.subTitle
        label.text = "알고리즘 스터디"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 23, weight: .semibold)
        let image = UIImage(systemName: "rectangle.portrait.and.arrow.right",
                            withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .red
        
        return button
    }()
    
    private let notificationButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 23, weight: .semibold)
        let image = UIImage(systemName: "bell.fill",
                            withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .darkGray
        
        return button
    }()
    
    private let footerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 10, left: 0, bottom: 0, right: 0)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    enum MenuSection {
        case party
        case member
    }

    struct MemberItem: Hashable {
        let imageName: String
        let title: String
    }

    struct PartyItem: Hashable {
        let systemImageName: String
        let title: String
    }

    enum MenuItem: Hashable {
        case party(PartyItem)
        case member(MemberItem)
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<MenuSection, MenuItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<MenuSection, MenuItem>
    private typealias MenuItemCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, MenuItem>
    private typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<CollectionTitleHeaderView>
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: createCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private var dataSource: DataSource!
    private var disposeBag: DisposeBag
    
    init() {
        self.disposeBag = .init()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureRootView()
        setSubViews()
        setConstraints()
        configureDataSource()
        applySnapshot()
//        setBindings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UIColor.gray.cgColor
        borderLayer.frame = CGRect(x: 0, y: 0, width: footerStackView.frame.size.width, height: 2)
        
        footerStackView.layer.addSublayer(borderLayer)
    }
    
    private func configureRootView() {
        let cornerRadius: CGFloat = 25.0
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(
            roundedRect: view.bounds,
            byRoundingCorners: [.topLeft, .bottomLeft],
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        ).cgPath
        
        view.layer.mask = maskLayer
        view.backgroundColor = PQColor.white
    }
    
    private func setSubViews() {
        footerStackView.addArrangedSubview(exitButton)
        footerStackView.addArrangedSubview(notificationButton)
        
        view.addSubview(headerLabel)
        view.addSubview(collectionView)
        view.addSubview(footerStackView)
    }
    
    private func setConstraints() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: safe.topAnchor, constant: 80),
            headerLabel.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 15),
            headerLabel.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -10),
            headerLabel.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -20),
            
            collectionView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 15),
            collectionView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: footerStackView.topAnchor),
            
            footerStackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 15),
            footerStackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -10),
            footerStackView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -50)
        ])
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            switch section {
            case 0:
                var config = UICollectionLayoutListConfiguration(appearance: .plain)
                config.showsSeparators = false
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                        heightDimension: .estimated(10))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                         elementKind: "PartySectionHeader",
                                                                         alignment: .top)
                
                let listSection = NSCollectionLayoutSection.list(using: config, layoutEnvironment: env)
                listSection.contentInsets = .init(top: 0, leading: 0, bottom: 20, trailing: 10)
                listSection.boundarySupplementaryItems = [header]
                
                return listSection
            default:
                var config = UICollectionLayoutListConfiguration(appearance: .plain)
                config.showsSeparators = false
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                        heightDimension: .estimated(10))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                         elementKind: "MemberSectionHeader",
                                                                         alignment: .top)
                
                let listSection = NSCollectionLayoutSection.list(using: config, layoutEnvironment: env)
                listSection.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 10)
                listSection.boundarySupplementaryItems = [header]
                
                return listSection
            }
        }
        
        return layout
    }
    
    private func configureDataSource() {
        let menuItemCellRegistration = MenuItemCellRegistration { cell, indexPath, item in
            switch item {
            case .party(let partyItem):
                var content = UIListContentConfiguration.cell()
                let sfConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .medium)
                content.image = UIImage(systemName: partyItem.systemImageName,
                                        withConfiguration: sfConfig)
                content.imageProperties.tintColor = .darkGray
                content.text = partyItem.title
                cell.contentConfiguration = content
            case .member(let memberItem):
                var content = UIListContentConfiguration.cell()
                content.image = UIImage(named: memberItem.imageName)
                content.imageProperties.maximumSize = .init(width: 40, height: 40)
                content.text = memberItem.title
                cell.contentConfiguration = content
            }
        }
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: menuItemCellRegistration,
                                                                for: indexPath,
                                                                item: item)
        }
        
        let partySectionHeaderRegistration = HeaderRegistration(elementKind: "PartySectionHeader") {
            supplementaryView, elementKind, indexPath in
            supplementaryView.setFont(PQFont.basic)
            supplementaryView.setAlignment(.left)
            supplementaryView.configureTitle(string: "파티")
        }
        
        let memberSectionHeaderRegistration = HeaderRegistration(elementKind: "MemberSectionHeader") {
            supplementaryView, elementKind, indexPath in
            supplementaryView.setFont(PQFont.basic)
            supplementaryView.setAlignment(.left)
            supplementaryView.configureTitle(string: "멤버")
        }
        
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            if elementKind == "PartySectionHeader" {
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: partySectionHeaderRegistration,
                    for: indexPath)
            } else if elementKind == "MemberSectionHeader" {
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: memberSectionHeaderRegistration,
                    for: indexPath)
            }
            
            return nil
        }
    }
    
    private func applySnapshot() {
        var snapshot = Snapshot()
        
        let partyItems: [MenuItem] = [
            MenuItem.party(.init(systemImageName: "lightbulb", title: "퀘스트 관리")),
            MenuItem.party(.init(systemImageName: "gearshape", title: "파티 설정")),
            MenuItem.party(.init(systemImageName: "person.badge.plus", title: "초대하기"))
        ]
        
        let memberItems: [MenuItem] = [
            MenuItem.member(.init(imageName: "Memoji1", title: "Harry")),
            MenuItem.member(.init(imageName: "Memoji2", title: "Rowan")),
            MenuItem.member(.init(imageName: "Memoji3", title: "민규")),
            MenuItem.member(.init(imageName: "Memoji4", title: "David")),
            MenuItem.member(.init(imageName: "Memoji5", title: "Beckham"))
        ]
        
        snapshot.appendSections([.party, .member])
        snapshot.appendItems(partyItems, toSection: .party)
        snapshot.appendItems(memberItems, toSection: .member)
        
        dataSource.apply(snapshot)
    }
}
