//
//  PartyCardCell.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/12/13.
//

import UIKit

final class PartyCardCell: UICollectionViewCell {
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
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 15
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 2
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
}

extension PartyCardCell {
    func configure(with partyItem: PartyItem) {
        partyItemView.bind(partyItem)
    }
}
