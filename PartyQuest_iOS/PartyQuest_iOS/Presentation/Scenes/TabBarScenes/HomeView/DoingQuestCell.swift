//
//  DoingQuestCell.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/12/20.
//

import UIKit

final class DoingQuestCell: UICollectionViewCell {
    private lazy var partyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = PQFont.basicBold
        label.textColor = PQColor.text
        
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = PQFont.basic
        label.textColor = PQColor.textGray
        
        return label
    }()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = PQSpacing.cell
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 0, left: 10, bottom: 0, right: 0)
        
        return stackView
    }()
    
    private let dDayLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = PQFont.basic
        label.textColor = PQColor.text
        label.setContentHuggingPriority(.required, for: .horizontal)
        
        return label
    }()
    
    private let dDayStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 20, left: 0, bottom: 0, right: 5)
        
        return stackView
    }()
    
    private let outerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = PQSpacing.side
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = PQSpacing.margin
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureContentView()
        setSubViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        partyImageView.image = nil
        titleLabel.text = ""
        subtitleLabel.text = ""
        dDayLabel.text = ""
    }
    
    func configure(with quest: Quest) {
        partyImageView.image = UIImage(systemName: quest.partyImageUrl)
        titleLabel.text = quest.title
        subtitleLabel.text = quest.partyName
        dDayLabel.text = "⏰" + " D-\(quest.dDay)"
    }
    
    private func configureContentView() {
        contentView.backgroundColor = PQColor.white
    }
    
    private func setSubViews() {
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(subtitleLabel)
        
        dDayStackView.addArrangedSubview(dDayLabel)
        
        outerStackView.addArrangedSubview(partyImageView)
        outerStackView.addArrangedSubview(titleStackView)
        outerStackView.addArrangedSubview(dDayStackView)
        
        contentView.addSubview(outerStackView)
    }
    
    private func setConstraints() {
        let safe = contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            outerStackView.topAnchor.constraint(equalTo: safe.topAnchor),
            outerStackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            outerStackView.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
        ])
    }
}
