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
    private let partyMasterLabel: CenterTitledLabel = {
        let label = CenterTitledLabel()
        label.setTitle("파티장")
        label.setBodyFont(PQFont.basicBold)
        label.setBodyLeftImage(assetName: "partyMasterBadge")
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let partyMemberLabel: CenterTitledLabel = {
        let label = CenterTitledLabel()
        label.setTitle("인원")
        label.setBodyFont(PQFont.basicBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let partyStateLabel: CenterTitledLabel = {
        let label = CenterTitledLabel()
        label.setTitle("모집상태")
        label.setBodyFont(PQFont.basicBold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let recentQuestLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 퀘스트"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let recentQuestTitleLabel: UILabel = {
        let label = UILabel()
        label.font = PQFont.basic
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let entireQuestLabel: UILabel = {
        let label = UILabel()
        label.text = "전체 퀘스트"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let todoCountLabel: LeftImageLabel = .init(imageName: "todoBadge")
    private let doingCountLabel: LeftImageLabel = .init(imageName: "doingBadge")
    private let doneCountLabel: LeftImageLabel = .init(imageName: "doneBadge")
    private let questCountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let partyCreationDateLabel: UILabel = {
        let label = UILabel()
        label.text = "파티 개설일"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = PQFont.basic
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let partyIntroduceLabel: UILabel = {
        let label = UILabel()
        label.text = "파티 소개"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let introductionBodyLabel: UILabel = {
        let label = UILabel()
        label.font = PQFont.basic
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let joinButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = PQColor.buttonMain
        button.setTitle("가입하기", for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = PQColor.buttonSub.cgColor
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resetNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRootView()
        setSubviews()
        setConstraints()
        setBindings()
    }
    
    private func configureNavigationBar() {
        let partyItem = viewModel.partyItem.value
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundImage = partyItem.topImage
        navigationBarAppearance.backgroundImageContentMode = .scaleAspectFill
        
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
    
    private func configureRootView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setSubviews() {
        [todoCountLabel, doingCountLabel, doneCountLabel]
            .forEach { questCountStackView.addArrangedSubview($0) }
        
        [
            partyMasterLabel, partyMemberLabel, partyStateLabel,
            recentQuestLabel, recentQuestTitleLabel, entireQuestLabel,
            questCountStackView, partyCreationDateLabel, dateLabel,
            partyIntroduceLabel, introductionBodyLabel, joinButton
        ].forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            partyMasterLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            partyMasterLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            partyMasterLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.35),
            partyMasterLabel.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.25),
            
            partyMemberLabel.topAnchor.constraint(equalTo: partyMasterLabel.topAnchor),
            partyMemberLabel.leadingAnchor.constraint(equalTo: partyMasterLabel.trailingAnchor),
            partyMemberLabel.heightAnchor.constraint(equalTo: partyMasterLabel.heightAnchor, multiplier: 1),
            
            partyStateLabel.topAnchor.constraint(equalTo: partyMasterLabel.topAnchor),
            partyStateLabel.leadingAnchor.constraint(equalTo: partyMemberLabel.trailingAnchor),
            partyStateLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            partyStateLabel.widthAnchor.constraint(equalTo: partyMasterLabel.widthAnchor, multiplier: 1),
            partyStateLabel.heightAnchor.constraint(equalTo: partyMasterLabel.heightAnchor, multiplier: 1),
            
            recentQuestLabel.topAnchor.constraint(equalTo: partyMasterLabel.bottomAnchor, constant: 20),
            recentQuestLabel.leadingAnchor.constraint(equalTo: partyMasterLabel.leadingAnchor),
            
            recentQuestTitleLabel.centerYAnchor.constraint(equalTo: recentQuestLabel.centerYAnchor),
            recentQuestTitleLabel.leadingAnchor.constraint(equalTo: recentQuestLabel.trailingAnchor, constant: 15),
            recentQuestTitleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            entireQuestLabel.topAnchor.constraint(equalTo: recentQuestLabel.bottomAnchor, constant: 20),
            entireQuestLabel.leadingAnchor.constraint(equalTo: partyMasterLabel.leadingAnchor),
            
            questCountStackView.centerYAnchor.constraint(equalTo: entireQuestLabel.centerYAnchor),
            questCountStackView.leadingAnchor.constraint(equalTo: entireQuestLabel.trailingAnchor, constant: 15),
            questCountStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            partyCreationDateLabel.topAnchor.constraint(equalTo: entireQuestLabel.bottomAnchor, constant: 20),
            partyCreationDateLabel.leadingAnchor.constraint(equalTo: partyMasterLabel.leadingAnchor),
            
            dateLabel.centerYAnchor.constraint(equalTo: partyCreationDateLabel.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: partyCreationDateLabel.trailingAnchor, constant: 15),
            dateLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            partyIntroduceLabel.topAnchor.constraint(equalTo: partyCreationDateLabel.bottomAnchor, constant: 20),
            partyIntroduceLabel.leadingAnchor.constraint(equalTo: partyMasterLabel.leadingAnchor),
            
            introductionBodyLabel.topAnchor.constraint(equalTo: partyIntroduceLabel.bottomAnchor, constant: 5),
            introductionBodyLabel.leadingAnchor.constraint(equalTo: partyIntroduceLabel.leadingAnchor, constant: 5),
            introductionBodyLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            joinButton.topAnchor.constraint(greaterThanOrEqualTo: introductionBodyLabel.bottomAnchor, constant: 10),
            joinButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            joinButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            joinButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.25),
            joinButton.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
    
    private func setBindings() {
        viewModel.partyItem.asDriver()
            .drive(with: self, onNext: { owner, partyItem in
                owner.partyMasterLabel.setBodyText(partyItem.partyMaster)
                owner.partyMemberLabel.setBodyText(partyItem.memberCount)
                owner.partyStateLabel.setBodyText(partyItem.recruitState)
                owner.todoCountLabel.setText(partyItem.todoQuestCount)
                owner.doingCountLabel.setText(partyItem.doingQuestCount)
                owner.doneCountLabel.setText(partyItem.doneQuestCount)
                owner.dateLabel.text = partyItem.creationDate
                owner.introductionBodyLabel.text = partyItem.introduction
            })
            .disposed(by: disposeBag)
    }
}
