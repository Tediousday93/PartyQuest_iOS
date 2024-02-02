//
//  AddQuestViewController.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2024/01/25.
//

import UIKit
import RxSwift
import RxCocoa

final class AddQuestViewController: UIViewController {
    private let addQuestTitleView = {
        let addQuestTitleView = AddQuestTitleView()
        addQuestTitleView.translatesAutoresizingMaskIntoConstraints = false
        
        return addQuestTitleView
    }()
    
    private let addQuestContentView = {
        let addQuestContentView = AddQuestContentView()
        addQuestContentView.translatesAutoresizingMaskIntoConstraints = false
        
        return addQuestContentView
    }()
    
    enum DateOptionSection {
        case date
        case time
    }
    
    struct DateItem: Hashable {
//        let imageName: String
        let title: String
        let date: String
        let isOn: Bool
    }
//
//    struct timeItem: Hashable {
//        let title: String
//        let time: String
//    }
//
    enum DateOptionItem: Hashable {
        case dateOption(DateItem)
//        case datePicker
        case timeOption(DateItem)
//        case timePicker
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<DateOptionSection, DateOptionItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<DateOptionSection, DateOptionItem>
    private typealias DateOptionCellRegistration = UICollectionView.CellRegistration<DateOptionCell, DateOptionItem>
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: createCollectionViewLayout())
        collectionView.layer.cornerRadius = 10
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private var dataSource: DataSource!
    private let viewModel: AddQuestViewModel
    private let disposBag: DisposeBag
    
    init(viewModel: AddQuestViewModel) {
        self.viewModel = viewModel
        self.disposBag = .init()
        
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
        setBindings()
    }
    
    private func configureRootView() {
        view.backgroundColor = .systemGray6
    }
    
    private func setSubViews() {
        view.addSubview(addQuestTitleView)
        view.addSubview(addQuestContentView)
        view.addSubview(collectionView)
    }
    
    private func setConstraints() {
        let safe = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            addQuestTitleView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 12),
            addQuestTitleView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 12),
            addQuestTitleView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -12),
            addQuestTitleView.bottomAnchor.constraint(equalTo: safe.topAnchor, constant: 40),
            
            addQuestContentView.topAnchor.constraint(equalTo: addQuestTitleView.bottomAnchor, constant: 20),
            addQuestContentView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 12),
            addQuestContentView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -12),
            
            collectionView.topAnchor.constraint(equalTo: addQuestContentView.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -12),
            collectionView.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
            
        ])
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            switch section {
            default:
                let config = UICollectionLayoutListConfiguration(appearance: .grouped)
                let listSection = NSCollectionLayoutSection.list(using: config, layoutEnvironment: env)
                listSection.contentInsets = .zero
                
                return listSection
            }
        }
        
        return layout
    }
    
    private func configureDataSource() {
        let dateOptionCellRegistration = DateOptionCellRegistration { cell, indexPath, item in
            switch item {
            case .dateOption(let dateItem):
                cell.configureToDateCell(with: dateItem)
            case .timeOption(let timeItem):
                cell.configureToTimeCell(with: timeItem)
            }
        }
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: dateOptionCellRegistration,
                                                                for: indexPath,
                                                                item: item)
        }
    }
    
    private func applySnapshot() {
        var snapshot = Snapshot()
        
        let dateItem = DateOptionItem.dateOption(.init(title: "날짜", date: "2024년 2월 2일 금요일", isOn: false))
        let timeItem = DateOptionItem.timeOption(.init(title: "시간", date: "오후 4:04", isOn: true))
        
        snapshot.appendSections([.date, .time])
        snapshot.appendItems([dateItem], toSection: .date)
        snapshot.appendItems([timeItem], toSection: .time)
        
        dataSource.apply(snapshot)
    }

    private func setBindings() {
        let startEditingTextView = addQuestContentView.descriptionTextView.rx.didBeginEditing.asObservable()

        startEditingTextView
            .withUnretained(self)
            .subscribe { owner, _ in
                if owner.addQuestContentView.descriptionTextView.text == "설명을 입력하세요." {
                    owner.addQuestContentView.descriptionTextView.text = nil
                    owner.addQuestContentView.descriptionTextView.textColor = .black
                }
            }
            .disposed(by: disposBag)

        addQuestContentView.titleTextField.rx.text
            .orEmpty
            .scan("") { (previousText, newText) in
                let maxLength = 22

                return newText.count > maxLength ? previousText : newText
            }
            .bind(to: addQuestContentView.titleTextField.rx.text)
            .disposed(by: disposBag)

        addQuestContentView.descriptionTextView.rx.text
            .orEmpty
            .scan("") { (previousText, newText) in
                let maxLength = 130

                return newText.count > maxLength ? previousText : newText
            }
            .bind(to: addQuestContentView.descriptionTextView.rx.text)
            .disposed(by: disposBag)
    }
}

