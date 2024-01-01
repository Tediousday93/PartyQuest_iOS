//
//  ProfileImageCell.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/12/27.
//

import UIKit

final class ProfileImageCell: UICollectionViewCell {
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setSubViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with imageName: String) {
        profileImageView.image = UIImage(named: "Memoji1")
    }
    
    private func setSubViews() {
        contentView.addSubview(profileImageView)
    }
    
    private func setConstraints() {
        let safe = contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 180),
            profileImageView.heightAnchor.constraint(equalToConstant: 180),
        ])
    }
}
