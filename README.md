# PartyQuest

* 프로젝트 기간: 2023.11 ~

### 💻 개발환경 및 라이브러리

| 항목 | 사용기술 |
| :--------: | :--------: |
| Architecture | MVVM + C |
| UI | UIKit |
| Reactive | RxSwift |
| Network | Moya |
| Credential | Keychain |


## ⭐️ 팀원
| Rowan | Harry |
| :--------: |  :--------: |
| <Img src = "https://i.imgur.com/S1hlffJ.jpg"  height="200"/> |<img height="200" src="https://i.imgur.com/8pKgxIk.jpg">
| [Github Profile](https://github.com/Tediousday93) |[Github Profile](https://github.com/HarryHyeon) | 

</br>

## 📝 목차
1. [타임라인](#-타임라인)
2. [실행화면](#-실행화면)
3. [트러블 슈팅](#-트러블-슈팅)
4. [팀 회고](#-팀-회고)
5. [참고 링크](#-참고-링크)

</br>

# 📆 타임라인 
- 23.10.26 : 프로젝트 적용기술 선정
- 23.10.27 ~ 11.02 : 시작/회원가입/로그인 화면 개발, Network Layer 구성, Coodinator 패턴 적용
- 23.11.03 ~ 11.07 : 서비스 자체 로그인, 회원가입 기능 개발
- 23.11.13 ~ 11.22 : Social Auth Layer - 카카오 로그인 개발
- 23.11.23 ~ 11.27 : Credential Layer - Keychain을 활용한 토큰 저장 및 싱글톤 객체 개발
- 23.11.28 ~ 12.12 : Social Auth Layer - Naver, Google 로그인 개발
- 23.12.13 ~ : Presentation Layer - TabBar 화면 개발

</br>

# 📱 실행화면


</br>

# 🚀 트러블 슈팅
## 1️⃣ 카카오 로그인 방식
**백엔드 요구사항**
* REST API 방법으로 카카오 로그인 API를 제공

해당 방법은 client에서 직접 토큰을 받을 방법이 없다.
callback으로 url이 전달되기 때문이다. 이를 활용하려면 WKWebView을 사용해야만 했다.

### 🔍 문제점
1. 하이브리드 앱이 됨
2. JWT의 문자열이 웹뷰에 노출됨(UX가 좋지 않음)

### ⚒️ 해결방안
* 백엔드와 협의하여 소셜 로그인은 client에서 해당 서비스 SDK에 일임하기로 함.
* SDK를 통해 받아온 유저의 정보를 백엔드 서버 login request에 포함시켜 회원가입 / 로그인을 진행할 수 있도록 API 수정.

</br>

## 2️⃣ 카카오 로그인 취소시 다시 버튼이 동작안하는 문제
### 🔍 문제점
<image src=https://hackmd.io/_uploads/r1kHU36Np.png width=200>

- 카카오 로그인 과정 중 취소버튼을 누르고 다시 카카오 로그인 버튼을 누르게 되면 버튼이 동작하지 않음

#### 이전 코드
``` swift
    func requestLogIn() -> Single<UserInfo> {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            return UserApi.shared.rx.loginWithKakaoTalk()
                .asSingle()
                .flatMap { token in
                    UserApi.shared.rx.me()
                }
        } else {
            return UserApi.shared.rx.loginWithKakaoAccount()
                .asSingle()
                .flatMap { token in
                    UserApi.shared.rx.me()
                }
        }
    }
    
```

- `UserApi.shared.rx.loginWithKakaoTalk()`,
 `UserApi.shared.rx.loginWithKakaoAccount()` 
 이 둘의 반환 타입은 `Observable<OAuthToken>` 이다.
- `UserApi.shared.rx.me()` 의 반환타입은 `Single<User>` 이다.
- `Observable<OAuthToken>`에 flatMap을 사용하여 `Single<User>`로 변환하기 위해 `asSingle` 오퍼레이터를 활용했다.
- 카카오톡 로그인을 하고나서 카카오서버에 해당 유저 정보를 얻어오는 작업을 연속적으로 하고 있다.
- 따로 뷰모델에서 에러처리도 하고 있지 않기 때문에 취소 버튼을 누르면 onError가 전달되어 스트림이 끊기게 된다.
    
    
<br>

### ⚒️ 해결방안
    
#### 수정 코드
    
``` swift
    func requestLogIn() -> Observable<Void> {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            return UserApi.shared.rx.loginWithKakaoTalk()
                .map { _ in }
        } else {
            return UserApi.shared.rx.loginWithKakaoAccount()
                .map { _ in }
        }
    }

    func getUserInfo() -> Observable<User> {
        return UserApi.shared.rx.me()
            .asObservable()
    }
```
- 로그인을 요청하는 기능과 유저 정보를 가져오는 기능을 다른 메서드로 분리하였다.
- 불필요한 타입 변환을 없애 주었고, 로그인 되었는지만 확인이 필요하기에 `Observable<Void>` 타입을 반환하도록 수정했다.
    
``` swift
// ViewModel.swift

let kakaoLogIn = input.kakaoLogInButtonTapped
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.kakaoSocialUserDataUseCase.logIn()
                    .materialize()
            }
            .do(onNext: { event in
                if let error = event.error {
                    errorRelay.accept(error)
                }
            })
            .filter { $0.error == nil }
```
- 뷰 모델에서 에러를 Event로 처리하도록 materialize 오퍼레이터를 사용함으로써 에러를 받더라도 이벤트로써 처리하게되어 스트림이 끊기지 않도록 수정하였다.

<br>
    
## 3️⃣ Observable 생성 클로저안에서 PublishSubject emit이 되지 않는 문제
### 🔍 문제점
Observable을 생성하는 클로저안에서 PublishSubject에 새로운 이벤트를 발생시켰지만 해당 PublishSubject를 구독하는 쪽에서 아무런 이벤트를 받지 못하는 문제가 있었다.
    
#### 이전 코드
``` swift
// GoogleAuthService.swift
    
let userSubject: PublishSubject<GIDGoogleUser> = .init()

func requestLogIn() -> Observable<Void> {
    ...
    
    return Observable<Void>.create { observer in
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
            if let error = error {
                observer.onError(GoogleAuthError.logInError(message: error.localizedDescription))
            } else if let result = signInResult {
                self.userSubject.onNext(result.user)
                observer.onNext(())
                observer.onCompleted()
            }
        }
        return Disposables.create()
    }
}
    
func getUserInfo() -> Observable<GIDGoogleUser> {
    return userSubject.asObservable()
}

```
- GoogleSignIn SDK에 있는 `GIDSignIn.sharedInstance.signIn(withPresenting:)` 메서드의 컴플리션 핸들러 파라미터로 유저 정보가 담겨있는 결과가 전달된다.
- `getUserInfo()`에서 두 번 로그인작업을 하는 것은 불필요하기에 Obervable 생성 클로저 안에서 userSubject에 유저 정보를 전달하는 방식이다.
- ViewModel에서 로그인 버튼이 눌렸을때, `requestLogIn()`의 구독이 일어나고 로그인이 성공하면 `getUserInfo`가 구독이 되도록 구현되어있다.
- PublishSubject는 Hot Observable로 다른 옵저버가 구독한 이후부터 받는 값만 방출하고, 현재는 PublishSubject가 ViewModel에서 구독되기 전에 UserInfo 값을 방출하고 있기 때문에 방출된 값이 다운 스트림으로 내려오지 않는다.
- 로그인 버튼을 눌렀을 때, `userSubject`가 구독이 되지 않은 상태에서 이벤트가 발생했기 때문에 정상적으로 유저 정보를 얻을 수 없었다.

### ⚒️ 해결방안
    
#### 수정 코드
``` swift
// GoogleAuthService.swift
let userSubject: ReplaySubject<GIDGoogleUser> = ReplaySubject<GIDGoogleUser>.create(bufferSize: 1)
```
- 이전의 문제들을 해결하는 방법에는 구독까지 방출을 기다리는 Cold Observable을 활용하거나 방출했던 항목을 저장했다가 구독하는 모든 옵저버에 다시 방출하는 Replay를 활용해야한다.
- `userSubject`의 타입만 `ReplaySubject<GIDGoogleUser>`로 변경해주었다. 또한 버퍼사이즈를 1로 설정해줌으로써 구독하기 이전에 방출된 값 중 가장 최근의 유저 정보타입을 저장하고 있다가 구독 이후 방출할 수 있도록 하여 해결하였다.

    
<br>

## 4️⃣ 
### 🔍 문제점
### ⚒️ 해결방안

<br>
    
## 5️⃣ 
### 🔍 문제점
### ⚒️ 해결방안


# 🫂 팀 회고
### 우리팀이 잘한 점


### 우리팀이 노력할 점


</br>

---

# 📚 참고 링크
* [Notion(Rowan) - RxSwift](https://heavy-rosehip-0fb.notion.site/5272729d82e9480c8784de856a480aac?v=5aca0fe79aa344f7b7ed620449cf2800&pvs=4)
* [GitHub - Rxswift: Single](https://github.com/ReactiveX/RxSwift/blob/main/RxSwift/Traits/PrimitiveSequence/Single.swift)
* [ReactiveX - flatMap](https://reactivex.io/documentation/operators/flatmap.html)
* [ReactiveX - map](https://reactivex.io/documentation/operators/map.html)
* [Naver Developers - Naver Login](https://developers.naver.com/docs/login/devguide/devguide.md)
* [Kakao Developers - Kakao Login](https://developers.kakao.com/docs/latest/ko/kakaologin/common)
* [Google Cloud Docs - 사용자 로그인](https://cloud.google.com/identity-platform/docs/web/google?hl=ko)
* [Github - Moya](https://github.com/Moya/Moya)
