//
//  SettingViewController.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/12/26.
//

import UIKit
import RxSwift

final class SettingViewController: UIViewController {
    private enum SettingSection {
        case profileImage
        case account
        case device
        case etc
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<SettingSection, AnyHashable>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<SettingSection, AnyHashable>
    typealias ProfileImageCellRegistration = UICollectionView.CellRegistration<ProfileImageCell, String>
    typealias AccountCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String>
    typealias DeviceInfoCellRegistration = UICollectionView.CellRegistration<DeviceInfoCell, DeviceInfo>
    typealias EtcCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String>
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<TitleHeaderView>
    typealias FooterRegistration = UICollectionView.SupplementaryRegistration<ButtonFooterView>
    
    private lazy var collectionView: UICollectionView = {
        let colletionView = UICollectionView(frame: .zero,
                                             collectionViewLayout: createCollectionViewLayout())
        colletionView.translatesAutoresizingMaskIntoConstraints = false
        
        return colletionView
    }()
    
    private var dataSource: DataSource!
    
    private let viewModel: SettingViewModel
    private var disposeBag: DisposeBag
    
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
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
        let tabBarImage = UIImage(systemName: "gearshape")
        let tabBarSelectedImage = UIImage(systemName: "gearshape.fill")
        
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
        let layout = UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            switch section {
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.1),
                                                      heightDimension: .fractionalWidth(0.1))
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalWidth(0.3))
                let group = NSCollectionLayoutGroup.custom(layoutSize: groupSize) { (environment) -> [NSCollectionLayoutGroupCustomItem] in
                    let xOffset = (environment.container.effectiveContentSize.width - itemSize.widthDimension.dimension) / 2
                    let customItem = NSCollectionLayoutGroupCustomItem(
                        frame: CGRect(x: xOffset,
                                      y: 0,
                                      width: itemSize.widthDimension.dimension,
                                      height: itemSize.heightDimension.dimension)
                    )
                    
                    return [customItem]
                }
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                        heightDimension: .estimated(10))
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: "profileImageHeader",
                    alignment: .top)
                
                let profileSection = NSCollectionLayoutSection(group: group)
                profileSection.contentInsets = .init(top: 105, leading: 0, bottom: 20, trailing: 0)
                profileSection.boundarySupplementaryItems = [header]
                
                return profileSection
            case 1:
                let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                        heightDimension: .estimated(10))
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: "accountHeader",
                    alignment: .topLeading)
                header.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 0)
                
                let listSection = NSCollectionLayoutSection.list(using: config, layoutEnvironment: env)
                listSection.boundarySupplementaryItems = [header]
                listSection.contentInsets = .init(top: 10, leading: 20, bottom: 30, trailing: 20)
                
                return listSection
            case 2:
                let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                        heightDimension: .estimated(10))
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: "deviceHeader",
                    alignment: .topLeading)
                header.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 0)
                
                let listSection = NSCollectionLayoutSection.list(using: config, layoutEnvironment: env)
                listSection.boundarySupplementaryItems = [header]
                listSection.contentInsets = .init(top: 10, leading: 20, bottom: 30, trailing: 20)
                
                return listSection
                
            default:
                let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
                let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .fractionalWidth(0.15))
                let footer = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: footerSize,
                    elementKind: "ButtonFooter",
                    alignment: .bottom
                )
                
                let listSection = NSCollectionLayoutSection.list(using: config, layoutEnvironment: env)
                listSection.boundarySupplementaryItems = [footer]
                
                return listSection
            }
        }
        
        return layout
    }
    
    private func configureDataSource() {
        let profileImageCellRegistration = ProfileImageCellRegistration { cell, indexPath, imageName in
            cell.configure(with: imageName)
        }
        
        let accountCellRegistration = AccountCellRegistration { cell, indexPath, title in
            var content = UIListContentConfiguration.cell()
            content.text = title

            cell.contentConfiguration = content
            cell.accessories = [.disclosureIndicator()]
        }
        
        let deviceCellRegistration = DeviceInfoCellRegistration { cell, indexPath, deviceInfo in
            cell.configure(with: deviceInfo)
        }
        
        let etcCellRegistration = EtcCellRegistration { cell, indexPath, title in
            var content = UIListContentConfiguration.cell()
            content.text = title

            cell.contentConfiguration = content
            cell.accessories = [.disclosureIndicator()]
        }
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            if indexPath.section == 0 {
                if let profileImageTitle = item as? String {
                    return collectionView.dequeueConfiguredReusableCell(using: profileImageCellRegistration,
                                                                        for: indexPath,
                                                                        item: profileImageTitle)
                }
            } else if indexPath.section == 1 {
                if let accountTitle = item as? String {
                    return collectionView.dequeueConfiguredReusableCell(using: accountCellRegistration,
                                                                        for: indexPath,
                                                                        item: accountTitle)
                }
            } else if indexPath.section == 2 {
                if let deviceInfo = item as? DeviceInfo {
                    return collectionView.dequeueConfiguredReusableCell(using: deviceCellRegistration,
                                                                        for: indexPath,
                                                                        item: deviceInfo)
                }
            } else if indexPath.section == 3 {
                if let etcTitle = item as? String {
                    return collectionView.dequeueConfiguredReusableCell(using: etcCellRegistration,
                                                                        for: indexPath,
                                                                        item: etcTitle)
                }
            }
            
            return UICollectionViewCell()
        }
        
        let profileImageHeaderRegistration = HeaderRegistration(elementKind: "profileImageHeader") {
            supplementaryView, elementKind, indexPath in
            supplementaryView.setFont(PQFont.cellTitle)
            supplementaryView.setAlignment(.center)
            supplementaryView.configureTitle(string: "설정")
        }
        
        let accountHeaderRegistration = HeaderRegistration(elementKind: "accountHeader") {
            supplementaryView, elementKind, indexPath in
            supplementaryView.setFont(PQFont.basicBold)
            supplementaryView.configureTitle(string: "계정")
        }
        
        let deviceHeaderRegistration = HeaderRegistration(elementKind: "deviceHeader") {
            supplementaryView, elementKind, indexPath in
            supplementaryView.setFont(PQFont.basicBold)
            supplementaryView.configureTitle(string: "기기")
        }
        
        let buttonFooterRegistration = FooterRegistration(elementKind: "ButtonFooter") {
            supplementaryView, elementKind, indexPath in
            supplementaryView.setButtonTitle(string: "로그아웃")
            supplementaryView.setButtonColor(for: PQColor.buttonMain)
        }
        
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            if elementKind == "profileImageHeader" {
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: profileImageHeaderRegistration,
                    for: indexPath
                )
            } else if elementKind == "accountHeader" {
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: accountHeaderRegistration,
                    for: indexPath
                )
            } else if elementKind == "deviceHeader" {
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: deviceHeaderRegistration,
                    for: indexPath
                )
            } else if elementKind == "ButtonFooter" {
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: buttonFooterRegistration,
                    for: indexPath
                )
            }
            
            return nil
        }
    }
    
    private func applySnapshot(items: (profileImageName: String,
                                       accountTitleList: [String],
                                       deviceInfoList: [DeviceInfo],
                                       etcTitleList: [String])) {
        var snapshot = Snapshot()

        snapshot.appendSections([.profileImage, .account, .device, .etc])
        snapshot.appendItems([items.profileImageName], toSection: .profileImage)
        snapshot.appendItems(items.accountTitleList, toSection: .account)
        snapshot.appendItems(items.deviceInfoList, toSection: .device)
        snapshot.appendItems(items.etcTitleList, toSection: .etc)
        
        self.dataSource.apply(snapshot)
    }

    private func setBindings() {
        let viewWillAppearEvent = self.rx.viewWillAppear
        let willShowCell = collectionView.rx.willDisplayCell.asObservable()
        
        let autoLogInSwitchIsOn = willShowCell
            .flatMap { cell, indexPath in
                if let deviceInfoCell = cell as? DeviceInfoCell,
                   indexPath == IndexPath(item: 0, section: 2) {
                    return deviceInfoCell.switchButton.rx.isOn.asObservable()
                }
                return Observable<Bool>.empty()
            }
        
        let darkModeSwitchIsOn = willShowCell
            .flatMap { cell, indexPath in
                if let deviceInfoCell = cell as? DeviceInfoCell,
                   indexPath == IndexPath(item: 1, section: 2) {
                    return deviceInfoCell.switchButton.rx.isOn.asObservable()
                }
                return Observable<Bool>.empty()
            }
        
        let alarmSwitchIsOn = willShowCell
            .flatMap { cell, indexPath in
                if let deviceInfoCell = cell as? DeviceInfoCell,
                   indexPath == IndexPath(item: 2, section: 2) {
                    return deviceInfoCell.switchButton.rx.isOn.asObservable()
                }
                return Observable<Bool>.empty()
            }
        
        let willShowFooterView = collectionView.rx.willDisplaySupplementaryView.asObservable()
        let logOutButtonTapped = willShowFooterView
            .flatMap { supplementaryView, elementKind, _ in
                if elementKind == "ButtonFooter" {
                    if let buttonFooterView = supplementaryView as? ButtonFooterView {
                        return buttonFooterView.button.rx.tap
                            .map { _ in }
                    }
                }
                return Observable.empty()
            }
        
        let input = SettingViewModel.Input(viewWillAppearEvent: viewWillAppearEvent,
                                           autoLogInButtonIsOn: autoLogInSwitchIsOn,
                                           darkModeButtonIsOn: darkModeSwitchIsOn,
                                           alarmButtonIsOn: alarmSwitchIsOn,
                                           logOutButtonTapped: logOutButtonTapped)

        let output = viewModel.transform(input)
        
        output.settingItems
            .withUnretained(self)
            .subscribe { owner, items in
                owner.applySnapshot(items: items)
            }
            .disposed(by: disposeBag)
        
        output.autoLogInSetSucceded
            .subscribe { _ in
                print("autoLogIn switched")
            }
            .disposed(by: disposeBag)
        
        output.darkModeSetSucceded
            .subscribe { _ in
                print("darkMode switched")
            }
            .disposed(by: disposeBag)
        
        output.alarmSetSucceded
            .subscribe { _ in
                print("alarm switched")
            }
            .disposed(by: disposeBag)
        
        output.logOutSucceded
            .subscribe { _ in
                print("LogOut Button!!")
            }
            .disposed(by: disposeBag)
    }
}
