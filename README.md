# Get the PageCall SDK for iOS

Pagecall iOS SDK를 이용하면 여러분의 iOS 어플리케이션에 쉽고 빠르게 PageCall을 적용할 수 있습니다. 

아래 문서에는 PageCall의 iOS Software 개발에 필요한 환경과 전체 설치 과정이 상세히 포함되어 있으니 참고하기 바랍니다.

  

## 요구사항(pre-requisites)

- Xcode ≥ 11.1
- iOS ≥ 10.2
- Swift-version ≥ 4.2
- Real iOS Device Type: iPhone, iPad
- Simulator:  Supported

## PageCall SDK 다운로드

1. [PageCallSDK.framework](https://github.com/pplink/pagecall-ios-example/tree/master/sample-swift/Frameworks/PageCallSDK)
2. [WebRTC.framework](https://github.com/pplink/pagecall-ios-example/tree/master/sample-swift/Frameworks/WebRTC)

## Xcode 프로젝트에 PageCall SDK 추가

1. `PageCallSDK.framework`, `WebRTC.framework` 파일을 Xcode 프로젝트에 복사
2. General → Frameworks, Libraries, and Embedded Content → ➕ 버튼 클릭 → `PageCallSDK.framework`, `WebRTC.framework` 두 개의 framework를 iOS 프로젝트에 추가

    ![Frameworks.png](Frameworks.png)

3. Embed 옵션은 `Embed & Sign` 으로 설정
4. Build Settings → Build Options → `Enable Bitcode = No` 로 설정
5. Build Settings → Swift Compiler - Search Paths → Import Paths  + `$(SRCROOT)/PageCallSDK.framework/Headers` 추가

## AppStore 배포를 위한 Framework의 불필요한 Architecture 삭제

Framework내의 시뮬레이터 Architercture가 포함되면 AppStore 업로드가 불가능합니다. 따라서 Archive시 아래와 같이 Architecture를 제거해주는 스크립트를 반드시 추가 해야 합니다.

1. Build Phases → ➕ 버튼 클릭 → New Run Script Phase
2. 스크립트 추가

    ```bash
    APP_PATH="${TARGET_BUILD_DIR}/${WRAPPER_NAME}"

    # This script loops through the frameworks embedded in the application and
    # removes unused architectures.
    find "$APP_PATH" -name '*.framework' -type d | while read -r FRAMEWORK
    do
        FRAMEWORK_EXECUTABLE_NAME=$(defaults read "$FRAMEWORK/Info.plist" CFBundleExecutable)
        FRAMEWORK_EXECUTABLE_PATH="$FRAMEWORK/$FRAMEWORK_EXECUTABLE_NAME"
        echo "Executable is $FRAMEWORK_EXECUTABLE_PATH"

        EXTRACTED_ARCHS=()

        for ARCH in $ARCHS
        do
            echo "Extracting $ARCH from $FRAMEWORK_EXECUTABLE_NAME"
            lipo -extract "$ARCH" "$FRAMEWORK_EXECUTABLE_PATH" -o "$FRAMEWORK_EXECUTABLE_PATH-$ARCH"
            EXTRACTED_ARCHS+=("$FRAMEWORK_EXECUTABLE_PATH-$ARCH")
        done

        echo "Merging extracted architectures: ${ARCHS}"
        lipo -o "$FRAMEWORK_EXECUTABLE_PATH-merged" -create "${EXTRACTED_ARCHS[@]}"
        rm "${EXTRACTED_ARCHS[@]}"

        echo "Replacing original executable with thinned version"
        rm "$FRAMEWORK_EXECUTABLE_PATH"
        mv "$FRAMEWORK_EXECUTABLE_PATH-merged" "$FRAMEWORK_EXECUTABLE_PATH"

    done
    ```

## 개인정보 허용에 대한 설명 추가

iOS 프로젝트의 info.plist에 아래와 같이 **개인정보 허용에 대한 설명**을 추가해야 합니다.

```xml
<key>NSCameraUsageDescription</key>
<string>Blink uses your camera to make video calls.</string>
<key>NSContactsUsageDescription</key>
<string>Blink needs access to your contacts in order to be able to call them.</string>
<key>NSMicrophoneUsageDescription</key>
<string>Blink uses your microphone to make calls.</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>Our application needs permission to write photos...</string>
```

## 예제

PageCallSDK 적용 이전에 **PageCall API Server**에 정보를 전달할 사용자의 **Business Server** 구현이 완료되면 사용자의 Business Server로 `Connect-In`을 요청합니다.

### 1. PageCall SDK 추가

```swift
// Swift
import PageCallSDK
```

```objectivec
// Objective-C
#import <PageCallSDK/PageCallSDK.h>
```

### 2. PageCall 실행

```swift
// Swift
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

```objectivec
// Objective-C
NSString *myId = "teacher-001"; // PCA userId
NSString *publicRoomId = "class-room-0010"; // PCA roomId
NSString *requestUrl = "https://pplink.net"; // PCA 인증 단계를 거친 사용자 서버의 URL
 
PageCall *pageCall = [PageCall sharedInstance];
[pageCall setDelegate:self];

pageCall.mainViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
[self pageCall.mainViewController animated:YES completion:^{
     // PCA Connect-In
     [pageCall connectIn:requestUrl myId:myId publicRoomId:publicRoomId];
}];
```

### 3. PageCallDelegate

PageCallDelegate를 통해 아래와 같이 PageCall 종료 이벤트와 WKNavigationDelegate, WKUIDelegate 를 받을 수 있습니다.

```swift
// Swift
extension ViewController: PageCallDelegate {
    func pageCallDidClose() {
        print("pageCallDidClose")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("webView decidePolicyFor navigationAction")
        decisionHandler(.allow)
    }
}
```

```objectivec
// Objective-C
@interface ViewController ()<PageCallDelegate>

...

- (void)pageCallDidClose
{
    NSLog(@"ViewController pageCallDidClose");
}

// WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;
{
    if (decisionHandler) {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}
```

## 추가 기능

### PageCall Log 파일

PageCall 사용 시 기록된 Log를 사용자 App의 `Documents` 에 Log 파일을 자동으로 저장합니다. Interval 단위는 Hour입니다.

```swift
// Time interval
pageCall.redirectLogToDocuments(withInterval:1)
```

```objectivec
// Time interval
[pageCall redirectLogToDocumentsWithInterval:1];
```

*NOTE*: 단,  해당 기능은 `Release`모드에서만 사용해야 합니다.  `Debug` 모드에서는 Xcode의 Console에 메세지가 나타나지 않습니다.
