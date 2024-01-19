//
//  QuestCardCell.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2024/01/03.
//

import UIKit

final class QuestCardCell: UICollectionViewListCell {
    let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold)
        let image = UIImage(systemName: "ellipsis",
                            withConfiguration: configuration)
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    private let statusBadgeImage: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = PQFont.basicBold
        label.textColor = PQColor.text
        
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = PQFont.basic
        label.textColor = PQColor.textGray
        
        return label
    }()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = PQSpacing.cell
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        return stackView
    }()
    
    private let dDayLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = PQFont.basic
        label.textColor = PQColor.text
        
        return label
    }()
    
    private let outerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = PQSpacing.cell
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 15, left: 20, bottom: 15, right: 20)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setSubviews()
        setConstraints()
        configureOptionButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with quest: Quest) {
        statusBadgeImage.image = UIImage(named: quest.status.badgeImageName)
        titleLabel.text = quest.title
        subTitleLabel.text = quest.description
        dDayLabel.text = "⏰" + " D-\(quest.dDay)"
    }
    
    private func configureOptionButton() {
        optionsButton.tintColor = .black
    }
    
    private func setSubviews() {
        topStackView.addArrangedSubview(statusBadgeImage)
        topStackView.addArrangedSubview(optionsButton)
        
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(subTitleLabel)
        
        outerStackView.addArrangedSubview(topStackView)
        outerStackView.addArrangedSubview(titleStackView)
        outerStackView.addArrangedSubview(dDayLabel)
        
        contentView.addSubview(outerStackView)
    }
    
    private func setConstraints() {
        let safe = contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            outerStackView.topAnchor.constraint(equalTo: safe.topAnchor),
            outerStackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            outerStackView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
        ])
    }
}
