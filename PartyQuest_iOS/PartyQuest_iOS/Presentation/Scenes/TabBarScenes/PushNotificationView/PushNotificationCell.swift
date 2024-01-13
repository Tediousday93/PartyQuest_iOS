//
//  PushNotificationCell.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2024/01/03.
//

import UIKit

final class PushNotificationCell: UICollectionViewCell {
    private let leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        
        return label
    }()
    
    private let titleBadgeView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circlebadge.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = PQFont.small
        label.textColor = PQColor.textGray
        
        return label
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return stackView
    }()
    
    private let notiDotLabel: UILabel = {
        let label = UILabel()
        label.text = "●"
        label.textColor = PQColor.buttonMain
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = PQFont.small
        label.textColor = PQColor.textGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubviews()
        setConstraints()
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        leftImageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
        messageLabel.text = nil
        dateLabel.text = nil
    }
    
    private func setSubviews() {
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(subtitleLabel)
        labelStackView.addArrangedSubview(messageLabel)
        
        contentView.addSubview(leftImageView)
        contentView.addSubview(labelStackView)
        contentView.addSubview(notiDotLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(titleBadgeView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            leftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            leftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            leftImageView.trailingAnchor.constraint(equalTo: labelStackView.leadingAnchor, constant: -5),
            leftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            leftImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),
            
            labelStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            labelStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            labelStackView.trailingAnchor.constraint(lessThanOrEqualTo: dateLabel.leadingAnchor, constant: -5),
            
            notiDotLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            notiDotLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            dateLabel.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            titleBadgeView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            titleBadgeView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            titleBadgeView.widthAnchor.constraint(equalToConstant: 10),
            titleBadgeView.heightAnchor.constraint(equalToConstant: 10),
        ])
    }
    
    func configure(with pushNotification: PushNotification) {
        leftImageView.image = UIImage(named: pushNotification.imageName)
        titleLabel.text = pushNotification.title
        titleBadgeView.isHidden = pushNotification.isBadgeNeeded
        subtitleLabel.text = pushNotification.subtitle
        messageLabel.text = pushNotification.message
        notiDotLabel.isHidden = pushNotification.isChecked
        dateLabel.text = pushNotification.date
    }
}

struct PushNotification {
    let imageName: String
    let title: String
    let subtitle: String
    let message: String
    let isBadgeNeeded: Bool
    let isChecked: Bool
    let date: String
}
