//
//  PartyCollectionViewCell.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/12/13.
//

import UIKit

final class PartyCollectionViewCell: UICollectionViewCell {
    private let partyItemView: PartyItemView = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureShape()
        setSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        partyItemView.resetContents()
    }
    
    private func configureShape() {
        self.backgroundColor = .systemGray5
        self.layer.cornerRadius = 15
    }
    
    private func setSubviews() {
        partyItemView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(partyItemView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            partyItemView.topAnchor.constraint(equalTo: contentView.topAnchor),
            partyItemView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            partyItemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            partyItemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    func bind(_ viewModel: PartyItemViewModel) {
        partyItemView.setContents(topImage: viewModel.topImage,
                                  title: viewModel.title,
                                  memberCount: viewModel.memberCount,
                                  todoQuestCount: viewModel.todoQuestCount,
                                  doingQuestCount: viewModel.doingQuestCount,
                                  doneQuestCount: viewModel.doneQuestCount,
                                  partyMaster: viewModel.partyMaster,
                                  creationDate: viewModel.creationDate)
    }
}
