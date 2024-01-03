//
//  PartyDetailViewController.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2024/01/03.
//

import UIKit
import RxSwift
import RxCocoa

final class PartyDetailViewController: UIViewController {
    private let segmentedControl: UnderlineSegmentedControl = {
        let segmentedControl = UnderlineSegmentedControl(items: ["예정", "진행중", "완료"])
        segmentedControl.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.gray],
            for: .normal
        )
        segmentedControl.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: PQColor.buttonMain,
                .font: UIFont.systemFont(ofSize: 15, weight: .semibold)
            ],
            for: .selected
        )
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
    }()
    
    private let viewModel: PartyDetailViewModel
    private let disposeBag: DisposeBag
    
    init(viewModel: PartyDetailViewModel) {
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
        setSubviews()
        setConstraints()
        setBindings()
    }
    
    private func configureRootView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setSubviews() {
        view.addSubview(segmentedControl)
    }
    
    private func setConstraints() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: safe.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 10),
            segmentedControl.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -10),
            segmentedControl.heightAnchor.constraint(equalTo: safe.widthAnchor, multiplier: 0.1),
        ])
    }
    
    private func setBindings() {
        
    }
}
