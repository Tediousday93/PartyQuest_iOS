//
//  SocialLogInButton.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/11/20.
//

import UIKit

final class SocialLogInButton: UIButton {
    init(platform: LogInPlatform) {
        super.init(frame: .zero)

        self.configureUI()
        self.updateImage(platform)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.layer.cornerRadius = 15
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 2
        self.imageView?.contentMode = .scaleAspectFit
    }
    
    private func updateImage(_ platform: LogInPlatform) {
        self.setImage(UIImage(named: platform.logoImageName), for: .normal)
    }
}

private extension LogInPlatform {
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
            return "kakaoid_button"
        case .apple:
            return "appleid_button_black"
        case .google:
            return "googleid_button"
        case .naver:
            return "naverid_button"
        }
    }
}
