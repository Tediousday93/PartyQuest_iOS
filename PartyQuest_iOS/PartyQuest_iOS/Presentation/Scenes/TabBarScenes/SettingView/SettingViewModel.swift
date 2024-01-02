//
//  SettingViewModel.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/12/26.
//

import RxSwift

final class SettingViewModel {
    private let coordinator: SettingCoordinator
    
    init(coordinator: SettingCoordinator) {
        self.coordinator = coordinator
    }
}

extension SettingViewModel: ViewModelType {
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let autoLogInButtonIsOn: Observable<Bool>
        let darkModeButtonIsOn: Observable<Bool>
        let alarmButtonIsOn: Observable<Bool>
        let logOutButtonTapped: Observable<Void>
    }
    
    struct Output {
        let settingItems: Observable<(profileImageName: String,
                                      accountTitleList: [String],
                                      deviceInfoList: [DeviceInfo],
                                      etcTitleList: [String])>
        let autoLogInSetSucceded: Observable<Void>
        let darkModeSetSucceded: Observable<Void>
        let alarmSetSucceded: Observable<Void>
        let logOutSucceded: Observable<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let profileImageName = input.viewWillAppearEvent
            .map { _ in
                "Memoji01"
            }
        
        let accountTitleList = input.viewWillAppearEvent
            .map { _ in
                [
                    "프로필 설정",
                    "비밀번호 변경",
                ]
            }
        
        let deviceInfoList = input.viewWillAppearEvent
            .map { _ in
                [
                    DeviceInfo(title: "자동 로그인", isOn: true),
                    DeviceInfo(title: "다크 모드", isOn: true),
                    DeviceInfo(title: "알림 설정", isOn: true),
                ]
            }
        
        let etcTitleList = input.viewWillAppearEvent
            .map { _ in
                ["문의하기"]
            }
        
        let settingItems = Observable.combineLatest(profileImageName, accountTitleList,
                                                    deviceInfoList, etcTitleList) {
            profileImageName, accountTitleList, deviceInfoList, etcTitleList in
            
            return (profileImageName: profileImageName, accountTitleList: accountTitleList,
                    deviceInfoList: deviceInfoList, etcTitleList: etcTitleList)
        }
        
        let autoLogInSetSucceded = input.autoLogInButtonIsOn
            .map { _ in }
        
        let darkModeSetSucceded = input.darkModeButtonIsOn
            .map { _ in }
        
        let alarmSetSucceded = input.alarmButtonIsOn
            .map { _ in }
        
        let logOutSucceded = input.logOutButtonTapped
            
        return Output(
            settingItems: settingItems,
            autoLogInSetSucceded: autoLogInSetSucceded,
            darkModeSetSucceded: darkModeSetSucceded,
            alarmSetSucceded: alarmSetSucceded,
            logOutSucceded: logOutSucceded
        )
    }
}
