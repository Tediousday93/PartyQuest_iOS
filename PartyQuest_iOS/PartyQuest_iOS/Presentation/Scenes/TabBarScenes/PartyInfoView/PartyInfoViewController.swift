//
//  PartyInfoViewController.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2024/01/23.
//

import UIKit
import RxSwift
import RxCocoa

final class PartyInfoViewController: UIViewController {
    private let partyInfoView: PartyInfoView = {
        let view = PartyInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let viewModel: PartyInfoViewModel
    private var disposeBag: DisposeBag
    
    init(viewModel: PartyInfoViewModel) {
        self.viewModel = viewModel
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
        setBindings()
    }
    
    private func configureRootView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setSubviews() {
        scrollView.addSubview(partyInfoView)
        view.addSubview(scrollView)
    }
    
    private func setConstraints() {
        let contentHeightConstraint = partyInfoView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor, constant: 4)
        contentHeightConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            partyInfoView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            partyInfoView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            partyInfoView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            partyInfoView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            partyInfoView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            contentHeightConstraint,
        ])
    }
    
    private func setBindings() {
        let input = PartyInfoViewModel.Input(
            viewWillAppearEvent: self.rx.viewWillAppear
        )
        
        let output = viewModel.transform(input)
        
        output.partyItem
            .drive(with: self, onNext: { owner, item in
                owner.partyInfoView.bind(item)
                owner.configureNavigationBar(with: item)
            })
            .disposed(by: disposeBag)
        
        self.rx.viewWillDisappear
            .subscribe(with: self, onNext: { owner, _ in
                owner.resetNavigationBar()
            })
            .disposed(by: disposeBag)
    }
    
    private func configureNavigationBar(with partyItem: PartyItem) {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundImage = partyItem.topImage
        navigationBarAppearance.backgroundImageContentMode = .redraw
        
        let navigationBar = navigationController?.navigationBar
        navigationBar?.standardAppearance = navigationBarAppearance
        navigationBar?.scrollEdgeAppearance = navigationBarAppearance
        navigationBar?.compactAppearance = navigationBarAppearance
        navigationBar?.prefersLargeTitles = true
        
        navigationItem.title = partyItem.title
    }
    
    private func resetNavigationBar() {
        let defaultAppearance = UINavigationBarAppearance()
        defaultAppearance.configureWithDefaultBackground()
        
        let navigationBar = navigationController?.navigationBar
        navigationBar?.standardAppearance = defaultAppearance
        navigationBar?.scrollEdgeAppearance = defaultAppearance
        navigationBar?.compactAppearance = defaultAppearance
        navigationBar?.prefersLargeTitles = false
    }
}
