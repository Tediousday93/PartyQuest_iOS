//
//  HomeViewController.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/27.
//

import UIKit

final class HomeViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    
    private var dataSource: DataSource?
    
    private let welcomLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.text = "Harry님, 환영합니다!"
        label.textColor = .black
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let colletionView = UICollectionView(frame: .zero,
                                             collectionViewLayout: createCollectionViewLayout())
        
        
        return colletionView
    }()
    
    private let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("HomeViewContorller deinited")
    }
    
    var harryProfile = UserProfile(imageData: nil, nickName: "Harry", email: "Harry@naver.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        DispatchQueue.global().async {
            let data = try? Data(
                contentsOf: URL(string: "https://tistory1.daumcdn.net/tistory/2767662/attach/f8d3ddae9ef442ada2aa8d8631c5c9b2")!
            )
            self.harryProfile.imageData = data
        }
        setTabBarItem()
        setConstraint()
        configureDataSource()
        applyInitialSnapshot()
    }
    
    private func setTabBarItem() {
        let tabBarImage = UIImage(systemName: "house")
        let tabBarSelectedImage = UIImage(systemName: "house.fill")
        
        self.tabBarItem = .init(title: "Home", image: tabBarImage, selectedImage: tabBarSelectedImage)
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
        UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            switch section {
            default:
                var config = UICollectionLayoutListConfiguration(appearance: .plain)
                let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: env)
                
                return section
            }
        }
    }
    
    private func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            if let profile = item as? UserProfile {
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: UserProfileCell.reuseID,
                    for: indexPath
                ) as? UserProfileCell else { return UICollectionViewCell() }
                
                cell.configure(profile)
                return cell
            }
            
            return nil
        }
    }
    
    private func applyInitialSnapshot() {
        var snapShot = SnapShot()
//        snapShot.appendSections(Section.allCases)
        snapShot.appendSections([.myProfile])
        snapShot.appendItems([harryProfile])
        
    }

}

enum Section: CaseIterable {
    case myProfile
}
