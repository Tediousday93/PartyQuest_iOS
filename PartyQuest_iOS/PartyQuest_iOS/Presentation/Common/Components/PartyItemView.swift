//
//  PartyItemView.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/12/12.
//

import UIKit

final class PartyItemView: UIView {
    let topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        
        return imageView
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .title3)
        
        return label
    }()
    let memberCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    let todoLabel: LeftImageLabel = LeftImageLabel(imageName: "todo")
    let doingLabel: LeftImageLabel = LeftImageLabel(imageName: "doing")
    let doneLabel: LeftImageLabel = LeftImageLabel(imageName: "done")
    let partyMasterLabel: LeftImageLabel = LeftImageLabel(imageName: "partyMaster")
    let creationDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    private let stateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    private let partyInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    private let outterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        
        return stackView
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
        [titleLabel, memberCountLabel]
            .forEach { titleStackView.addArrangedSubview($0) }
        [todoLabel, doingLabel, doneLabel]
            .forEach { stateStackView.addArrangedSubview($0) }
        [partyMasterLabel, creationDateLabel]
            .forEach { partyInfoStackView.addArrangedSubview($0) }
        [topImageView, titleStackView, stateStackView, partyInfoStackView]
            .forEach { outterStackView.addArrangedSubview($0) }
        self.addSubview(outterStackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            outterStackView.topAnchor.constraint(equalTo: self.topAnchor),
            outterStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            outterStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            outterStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    func setContents(
        topImage: UIImage,
        title: String?,
        memberCount: String?,
        todoQuestCount: String?,
        doingQuestCount: String?,
        doneQuestCount: String?,
        partyMaster: String?,
        creationDate: String?
    ) {
        topImageView.image = topImage
        titleLabel.text = title
        memberCountLabel.text = memberCount
        todoLabel.setText(todoQuestCount)
        doingLabel.setText(doingQuestCount)
        doneLabel.setText(doneQuestCount)
        partyMasterLabel.setText(partyMaster)
        creationDateLabel.text = creationDate
    }
    
    func resetContents() {
        topImageView.image = nil
        titleLabel.text = nil
        memberCountLabel.text = nil
        todoLabel.setText(nil)
        doingLabel.setText(nil)
        doneLabel.setText(nil)
        partyMasterLabel.setText(nil)
        creationDateLabel.text = nil
    }
}
