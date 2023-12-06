//
//  NaverAuthService.swift
//  PartyQuest_iOS
//
//  Created by Rowan on 2023/12/05.
//

import RxSwift
import Alamofire
import RxAlamofire
import NaverThirdPartyLogin

enum NaverAuthError: Error {
    case instanceDeallocated
    case accessTokenExpired
    case nilUserData
}

final class NaverAuthService: NSObject, SocialAuthService {
    typealias UserInfo = NaverUserData
    
    private let logInInstance: NaverThirdPartyLoginConnection
    private let accessTokenArrived: PublishSubject<Void> = .init()
    
    override init() {
        self.logInInstance = NaverThirdPartyLoginConnection.getSharedInstance()
        super.init()
        logInInstance.delegate = self
    }
    
    func requestLogIn() -> Observable<Void> {
        logInInstance.requestThirdPartyLogin()
        return accessTokenArrived.asObservable()
    }
    
    func getUserInfo() -> Observable<UserInfo> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.failure(NaverAuthError.instanceDeallocated))
                return Disposables.create()
            }
            
            guard logInInstance.isValidAccessTokenExpireTimeNow() else {
                logInInstance.requestAccessTokenWithRefreshToken()
                single(.failure(NaverAuthError.accessTokenExpired))
                return Disposables.create()
            }
            
            let tokenType: String = logInInstance.tokenType
            let token: String = logInInstance.accessToken
            let url = URL(string: "https://openapi.naver.com/v1/nid/me")!
            let authorization = "\(tokenType) \(token)"
            let request = AF.request(url,
                                     method: .get,
                                     parameters: nil,
                                     encoding: URLEncoding.default,
                                     headers: ["Authorization": authorization])
            request.responseData { response in
                switch response.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    let naverUserDataResponse = try? decoder.decode(NaverUserDataResponse.self, from: data)
                    guard let userData = naverUserDataResponse?.userData else {
                        single(.failure(NaverAuthError.nilUserData))
                        return
                    }
                    single(.success(userData))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
        .asObservable()
    }
}

extension NaverAuthService: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("Naver Logged In")
        accessTokenArrived.onNext(())
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        print("Naver Access Token Refreshed")
        accessTokenArrived.onNext(())
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        print("Naver Logged Out")
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("Naver LogIn Failed with Error: \(error.localizedDescription)")
        accessTokenArrived.onError(error)
    }
}
