//
//  PartyInfoView.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2024/01/30.
//

import UIKit

final class PartyInfoView: UIView {
    let partyMasterLabel: CenterTitledLabel = {
        let label = CenterTitledLabel()
        label.backgroundColor = .white
        label.setTitle("파티장")
        label.setBodyFont(PQFont.basicBold)
        label.setBodyLeftImage(assetName: "partyMasterBadge")
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let partyMemberLabel: CenterTitledLabel = {
        let label = CenterTitledLabel()
        label.backgroundColor = .white
        label.setTitle("인원")
        label.setBodyFont(PQFont.basicBold)
        label.bodyLabel.imageView.removeFromSuperview()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let partyStateLabel: CenterTitledLabel = {
        let label = CenterTitledLabel()
        label.backgroundColor = .white
        label.setTitle("모집상태")
        label.setBodyFont(PQFont.basicBold)
        label.bodyLabel.imageView.removeFromSuperview()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 2
        stackView.backgroundColor = .systemGray5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let entireQuestLabel: UILabel = {
        let label = UILabel()
        label.text = "전체 퀘스트"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let todoCountLabel: LeftImageLabel = .init(imageName: "todoBadge")
    let doingCountLabel: LeftImageLabel = .init(imageName: "doingBadge")
    let doneCountLabel: LeftImageLabel = .init(imageName: "doneBadge")
    let questCountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let partyCreationDateLabel: UILabel = {
        let label = UILabel()
        label.text = "파티 개설일"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = PQFont.basic
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let partyIntroduceLabel: UILabel = {
        let label = UILabel()
        label.text = "파티 소개"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let introductionBodyLabel: UILabel = {
        let label = UILabel()
        label.font = PQFont.basic
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let joinButton: UIButton = {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubviews() {
        [partyMasterLabel, partyMemberLabel, partyStateLabel]
            .forEach { topStackView.addArrangedSubview($0) }
        
        [todoCountLabel, doingCountLabel, doneCountLabel]
            .forEach { questCountStackView.addArrangedSubview($0) }
        
        [topStackView, entireQuestLabel, questCountStackView,
         partyCreationDateLabel, dateLabel, partyIntroduceLabel,
         introductionBodyLabel, joinButton]
            .forEach { self.addSubview($0) }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            topStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            topStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),

            partyMasterLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.35),
            partyMasterLabel.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25),
            
            partyMemberLabel.heightAnchor.constraint(equalTo: partyMasterLabel.heightAnchor, multiplier: 1),
            
            partyStateLabel.widthAnchor.constraint(equalTo: partyMasterLabel.widthAnchor, multiplier: 1),
            partyStateLabel.heightAnchor.constraint(equalTo: partyMasterLabel.heightAnchor, multiplier: 1),
            
            entireQuestLabel.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 20),
            entireQuestLabel.leadingAnchor.constraint(equalTo: partyMasterLabel.leadingAnchor),
            
            questCountStackView.centerYAnchor.constraint(equalTo: entireQuestLabel.centerYAnchor),
            questCountStackView.leadingAnchor.constraint(equalTo: entireQuestLabel.trailingAnchor, constant: 16),
            questCountStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            
            partyCreationDateLabel.topAnchor.constraint(equalTo: entireQuestLabel.bottomAnchor, constant: 20),
            partyCreationDateLabel.leadingAnchor.constraint(equalTo: partyMasterLabel.leadingAnchor),
            
            dateLabel.centerYAnchor.constraint(equalTo: partyCreationDateLabel.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: partyCreationDateLabel.trailingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            
            partyIntroduceLabel.topAnchor.constraint(equalTo: partyCreationDateLabel.bottomAnchor, constant: 20),
            partyIntroduceLabel.leadingAnchor.constraint(equalTo: partyMasterLabel.leadingAnchor),
            
            introductionBodyLabel.topAnchor.constraint(equalTo: partyIntroduceLabel.bottomAnchor, constant: 4),
            introductionBodyLabel.leadingAnchor.constraint(equalTo: partyIntroduceLabel.leadingAnchor, constant: 4),
            introductionBodyLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            joinButton.topAnchor.constraint(greaterThanOrEqualTo: introductionBodyLabel.bottomAnchor, constant: 12),
            joinButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            joinButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -32),
            joinButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25),
            joinButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
}

extension PartyInfoView {
    func bind(_ partyInfo: PartyItem) {
        partyMasterLabel.setBodyText(partyInfo.partyMaster)
        partyMemberLabel.setBodyText(partyInfo.memberCount)
        partyStateLabel.setBodyText(partyInfo.recruitState)
        todoCountLabel.setText(partyInfo.todoQuestCount)
        doingCountLabel.setText(partyInfo.doingQuestCount)
        doneCountLabel.setText(partyInfo.doneQuestCount)
        dateLabel.text = partyInfo.creationDate
        introductionBodyLabel.text = partyInfo.introduction
    }
}
