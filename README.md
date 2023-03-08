<img width="327" alt="스크린샷 2023-03-08 오후 4 47 40" src="https://user-images.githubusercontent.com/83946704/223652667-8b7354ae-9594-4d92-88cf-4233f433fd44.png">

### 실시간 라이브 스트리밍으로 한강의 물상태와 날씨를 보고 수상스키를 즐기기에 적합한 상태인지 확인해보세요!

[<img width="220" alt="스크린샷 2021-11-19 오후 3 52 02" src="https://user-images.githubusercontent.com/55099365/196023806-5eb7be0f-c7cf-4661-bb39-35a15146c33a.png">](https://apps.apple.com/us/app/빠지가까/id6443720411)

|실행화면|
|:----:|
|<img width="300" alt="" src="https://user-images.githubusercontent.com/83946704/223654824-02c9c31b-497c-4dcb-ad36-93a9c8bf775d.gif">|

### ❗️프로젝트 빌드는 제한되어있습니다❗️
- 프로젝트에 기상청 API Key와 HLS 링크는 private 상태입니다. 앱을 확인하고 싶다면 앱스토어에서 다운로드 해주세요


### 개발환경
- iOS: 15.5
- Xcode: 14.0.1

### 라이브러리

|라이브러리|Version|관리|
|:-----:|:-----:|:--:|
|SnapKit|`develop`|`SPM`|


### Git commit message

|Commit Type|Description|
|:-----:|:-----:|
|[Project]|프로젝트 설정 및 파일/폴더관리|
|[Feat]|기능구현|
|[Fix]|에러 및 버그수정|
|[Style]|코드 형식, 코드 스타일 수정|
|[Comment]|주석 추가|
|[Design]|UI 디자인 관련 수정|
|[Refactor]|리팩토링|
|[Readme]|리드미 수정|

### 폴더구조

```
BJGG
  |
  |── Font
  |     |── Pretendard
  |     └── EsamanruOTF
  |── Extension
  |     |── UIColor+CustomColor.swift
  |     |── UIFont+CustomFont.swift
  |     |── UILabel+CopyLabelText.swift
  |     └── UIDevice+DeviceCheck.swift
  |── BbajiSpot
  |     |── UI Component
  |     └── BbajiSpotViewController.swift
  |── BbajiHome
  |     |── UI Component
  |     └── BbajiHomeViewController.swift
  |── Model
  |     |── BbajiInfo.swift
  |     |── Weather.swift
  |     └── PlistError.swift
  |── Network
  |     └── WeatherManager.swift
  |── Utilities
  |     └── Constraints.swift
  |── AppDelegate.swift
  |── SceneDelegate.swift
  |── Assets.xcassets
  |── LaunchScreen.storyboard
  └── Info.plist
```
