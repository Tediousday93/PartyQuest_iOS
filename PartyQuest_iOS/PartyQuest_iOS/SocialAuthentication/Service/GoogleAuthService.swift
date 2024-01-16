//
//  GoogleAuthService.swift
//  PartyQuest_iOS
//
//  Created by Harry on 2023/12/05.
//

import GoogleSignIn
import RxSwift

enum GoogleAuthError: Error {
    case failToGetRootView
    case logInError(message: String)
    case failToGetUser
}

final class GoogleAuthService: SocialAuthService {
    private let userSubject: ReplaySubject<GIDGoogleUser> = ReplaySubject<GIDGoogleUser>.create(bufferSize: 1)
    
    func requestLogIn() -> Observable<Void> {
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            return Observable.create { observer in
                observer.onError(GoogleAuthError.failToGetRootView)
                return Disposables.create()
            }
        }
        
        return Observable<Void>.create { observer in
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) {
                [weak self] signInResult, error in
                if let error = error {
                    observer.onError(GoogleAuthError.logInError(message: error.localizedDescription))
                } else if let result = signInResult {
                    self?.userSubject.onNext(result.user)
                    observer.onNext(())
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    func getUserInfo() -> Observable<UserData> {
        return userSubject
            .map { $0.toDomain() }
            .asObservable()
    }
}
