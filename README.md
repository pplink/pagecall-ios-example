# Get the PageCall SDK for iOS

Pagecall iOS SDK를 이용하면 여러분의 iOS 어플리케이션에 쉽고 빠르게 PageCall을 적용할 수 있습니다. 

아래 문서에는 PageCall의 iOS Software 개발에 필요한 환경과 전체 설치 과정이 상세히 포함되어 있으니 참고하기 바랍니다.

  

## 요구사항(pre-requisites)

- Xcode ≥ 11.1
- iOS ≥ 11
- Swift-version ≥ 4.2
- Real iOS Device Type: iPhone, iPad
- Simulator:  Supported

## Pagecall iOS SDK 설치

iOS에서 Pagecall 사용하기 위해서는 Pagecall 프레임워크가 필요합니다.

### CocoaPods

`PodFile`: 에 아래 항목을 추가합니다.

```
target 'Pagecall' do
  use_frameworks!

  pod 'PageCallSDK', '~> 2.1.3', :source => 'https://github.com/pplink/pagecall-specs.git'

end
```

`pod install` 을 실행 하여 프로젝트에 추가 합니다.

## WebRTC Framework 설치

iOS 및 macOS용 WebRTC 프레임워크입니다. Google에서 iOS용 공식 빌드를 제공합니다.

### **CocoaPods**

`PodFile`: 에 아래 항목을 추가합니다.

```
target 'Pagecall' do
  use_frameworks!

  pod 'GoogleWebRTC', '1.1.29229' :source => 'https://github.com/cocoapods/specs'

end
```

`pod install` 을 실행 하여 프로젝트에 추가 합니다.

### **Swift Package Manager**

M1 칩셋 기반의 맥에서는 Swift Package Manager를 사용해서 xcframework 설치 해야 합니다. `Swift 5.3 / Xcode 12` 이상 설치 가능 Swift 패키지 관리자를 통해 WebRTC `repository https://github.com/alexpiezo/WebRTC.git` 추가 합니다.

## 개인정보 허용에 대한 설명 추가

iOS 프로젝트의 info.plist에 아래와 같이 **개인정보 허용에 대한 설명**을 추가해야 합니다.

```xml
<key>NSCameraUsageDescription</key>
<string>Blink uses your camera to make video calls.</string>
<key>NSMicrophoneUsageDescription</key>
<string>Blink uses your microphone to make calls.</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>Our application needs permission to write photos...</string>
```

## 예제

PageCallSDK 적용 이전에 **PageCall API Server**에 정보를 전달할 사용자의 **Business Server** 구현이 완료되면 사용자의 Business Server로 `Connect-In`을 요청합니다.

### 1. PageCall SDK 추가

```swift
import PageCallSDK
```

### 2. PageCall 실행

```swift
let myId = "teacher-001" // PCA userId
let publicRoomId = "class-room-0010" // PCA roomId
let requestUrl = "https://pplink.net" // PCA 인증 단계를 거친 사용자 서버의 URL

let pageCall = PageCall.sharedInstance()
pageCall.delegate = self

// PageCall MainViewController present
pageCall.mainViewController!.modalPresentationStyle = .overFullScreen
self.present(pageCall.mainViewController!, animated: true, completion: {
		// PCA Connect-In
    pageCall.connect(in: requestUrl, myId: myId, publicRoomId: publicRoomId)
})
```

### 3. PageCallDelegate

PageCallDelegate를 통해 아래와 같이 PageCall 종료 이벤트와 WKScriptMessage, WKNavigationDelegate, WKUIDelegate 를 받을 수 있습니다.

```swift
extension ViewController: PageCallDelegate {
    func pageCallDidClose() {
        print("pageCallDidClose")
    }

		func pageCallDidReceive(_ message: WKScriptMessage) {
        print("pageCallDidReceive message")
        
        /* sample JS
        var message = {
            command: 'finishedLoading',
            interval: 1
        };
        window.webkit.messageHandlers.pageCallSDK.postMessage(message);
        */
        
        if message.name == "pageCallSDK" {
            guard let dict = message.body as? [String: AnyObject],
                  let command = dict["command"] as? String,
                  let interval = dict["interval"] as? Int else {
                    return
            }
            print("pageCallDidReceiveScriptMessage command: \(command), interval: \(interval)")
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("webView decidePolicyFor navigationAction")
        decisionHandler(.allow)
    }
}
```

## Background Modes

다음과 같이 Background Modes를 추가 하면 앱이 Background 상태에서도 연결이 끊어지지 않고 유지 됩니다.

![Get%20the%20PageCall%20SDK%20for%20iOS%205f8532a9db1144019c4c1dcda522621d/_2020-10-13__7.40.36.png](Get%20the%20PageCall%20SDK%20for%20iOS%205f8532a9db1144019c4c1dcda522621d/_2020-10-13__7.40.36.png)

## PageCall Log 파일

PageCall 사용 시 기록된 Log를 사용자 App의 `Documents` 에 Log 파일을 자동으로 저장합니다. Interval 단위는 Hour입니다. `pageCallLogFilePath()` 를 통해 로그파일이 저장된 경로를 가져올 수 있습니다.

```swift
PageCall.sharedInstance().redirectLogToDocuments(withInterval:1)

// log file path
PageCall.sharedInstance().pageCallLogFilePath()
```

로그 파일 저장 경로

```
AppData/Library/Caches/PageCallLogs/2021-06-03_15_03.log
```

*NOTE*: 단,  해당 기능은 `Release`모드에서만 사용해야 합니다.  `Debug` 모드에서는 Xcode의 Console에 메세지가 나타나지 않습니다.