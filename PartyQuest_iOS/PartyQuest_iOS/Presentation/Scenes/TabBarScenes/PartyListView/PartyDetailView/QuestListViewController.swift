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
    private lazy var collectionView: UICollectionView = {
        let colletionView = UICollectionView(frame: .zero,
                                             collectionViewLayout: createCollectionViewLayout())
        colletionView.translatesAutoresizingMaskIntoConstraints = false
        
        return colletionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureRootView()
        setSubviews()
        setConstraints()
        setBindings()
    }

    private func configureRootView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setSubviews() {
//        view.addSubview(collectionView)
    }
    
    private func setConstraints() {
        let safe = view.safeAreaLayoutGuide
        
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: safe.topAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
//        ])
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func setBindings() {
        
    }
}
