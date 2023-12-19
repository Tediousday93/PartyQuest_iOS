//
//  UserProfileCell.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/12/12.
//

import UIKit

final class UserProfileCell: UICollectionViewListCell {
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = PQFont.subTitle
        
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = PQFont.basic
        
        return label
    }()
    
    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
//        stackView.layoutMargins = .init(top: 0, left: 10, bottom: 0, right: 0)
        
        return stackView
    }()
    
    private let outerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 15
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setSubViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with userProfile: UserProfile) {
//        profileImageView.image = UIImage(data: userProfile.imageData!)
        profileImageView.image = UIImage(systemName: "house")
        nickNameLabel.text = userProfile.nickName
        emailLabel.text = userProfile.email
    }
    
    private func setSubViews() {
        textStackView.addArrangedSubview(nickNameLabel)
        textStackView.addArrangedSubview(emailLabel)
        outerStackView.addArrangedSubview(profileImageView)
        outerStackView.addArrangedSubview(textStackView)
        
        contentView.addSubview(outerStackView)
    }
    
    private func setConstraints() {
        let safe = contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                                    multiplier: 0.2),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor,
                                                     multiplier: 0.8
                                                    ),
            
            outerStackView.topAnchor.constraint(equalTo: safe.topAnchor),
            outerStackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            outerStackView.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
        ])
    }
}
