//
//  SocialLogInButton.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/20.
//

import UIKit

final class SocialLogInButton: UIButton {
    private let socialLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let socialNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .caption1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(platform: Platform) {
        super.init(frame: .zero)
        
        self.configureUI()
        self.setConstraints()
        self.updateLogo(platform)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(socialLogoImageView)
        addSubview(socialNameLabel)
    }
    
    private func updateLogo(_ platform: Platform) {
        socialLogoImageView.image = UIImage(named: platform.logoImageName)
        socialNameLabel.text = platform.labelText
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            socialLogoImageView.topAnchor.constraint(equalTo: topAnchor),
            socialLogoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            socialLogoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            socialLogoImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            socialLogoImageView.widthAnchor.constraint(equalTo: socialLogoImageView.heightAnchor),
            
            socialNameLabel.topAnchor.constraint(equalTo: socialLogoImageView.bottomAnchor, constant: 4),
            socialNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            socialNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            socialNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

private extension Platform {
    var labelText: String {
        switch self {
        case .kakao:
            return "카카오로 로그인"
        case .apple:
            return "애플로 로그인"
        case .google:
            return "구글로 로그인"
        case .naver:
            return "네이버로 로그인"
        }
    }
    
    var logoImageName: String {
        switch self {
        case .kakao:
            return "kakaoButton_icon"
        case .apple:
            return "appleButton_black_icon"
        case .google:
            return "googleButton_icon"
        case .naver:
            return "naverButton_icon"
        }
    }
}
