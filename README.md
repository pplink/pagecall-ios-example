# Get the PageCall SDK for iOS

Pagecall iOS SDK를 이용하면 여러분의 iOS 어플리케이션에 쉽고 빠르게 PageCall을 적용할 수 있습니다. 

아래 문서에는 PageCall의 iOS Software 개발에 필요한 환경과 전체 설치 과정이 상세히 포함되어 있으니 참고하기 바랍니다.

  

## 요구사항(pre-requisites)

- Xcode ≥ 11.1
- iOS ≥ 11
- Swift-version ≥ 4.2
- Real iOS Device Type: iPhone, iPad
- Simulator:  Not supported

## PageCall SDK 다운로드

1. [PageCallSDK.framework](https://github.com/pplink/pagecall-ios-example/tree/master/sample-swift)
2. [WebRTC.framework](https://github.com/pplink/pagecall-ios-example/tree/master/sample-swift)

## Xcode 프로젝트에 PageCall SDK 추가

1. `PageCallSDK.framework`, `WebRTC.framework` 파일을 Xcode 프로젝트에 복사
2. General → Frameworks, Libraries, and Embedded Content → ➕ 버튼 클릭 → `PageCallSDK.framework`, `WebRTC.framework` 두 개의 framework를 iOS 프로젝트에 추가
3. Embed 옵션은 `Embed & Sign` 으로 설정
4. Build Settings → Build Options → `Enable Bitcode = No` 로 설정
5. Build Settings → Swift Compiler → Import Paths  + `$(SRCROOT)/PageCallSDK.framework/Headers` 추가

## 개인정보 허용에 대한 설명 추가

iOS 프로젝트의 info.plist에 아래와 같이 **개인정보 허용에 대한 설명**을 추가해야 합니다.

    <key>NSCameraUsageDescription</key>
    <string>Blink uses your camera to make video calls.</string>
    <key>NSContactsUsageDescription</key>
    <string>Blink needs access to your contacts in order to be able to call them.</string>
    <key>NSMicrophoneUsageDescription</key>
    <string>Blink uses your microphone to make calls.</string>
    <key>NSPhotoLibraryAddUsageDescription</key>
    <string>Our application needs permission to write photos...</string>

## 예제

PageCallSDK 적용 이전에 **PageCall API Server**에 정보를 전달할 사용자의 **Business Server** 구현이 완료되면 사용자의 Business Server로 `Connect-In`을 요청합니다.

### 1. PageCall SDK 추가

    // Swift
    import PageCallSDK

    // Objective-C
    #import <PageCallSDK/PageCallSDK.h>

### 2. PageCall 실행

    // Swift
    let myId = "teacher-001" // PCA userId
    let roomId = "class-room-0010" // PCA roomId
    let url = "https://pplink.net" // PCA 인증 단계를 거친 사용자 서버의 URL
    
    let pageCall = PageCall.sharedInstance()
    pageCall.delegate = self
    pageCall.connect(inMyID: myId, roomId: roomId, pcaURL: url)
    
    pageCall.pcViewController?.modalPresentationStyle = .overFullScreen
    self.present(pageCall.pcViewController!, animated: true, completion: nil)

    // Objective-C
    NSString *myId = "teacher-001"; // PCA userId
    NSString *roomId = "class-room-0010"; // PCA roomId
    NSString *url = "https://pplink.net"; // PCA 인증 단계를 거친 사용자 서버의 URL
     
    PageCall *pageCall = [PageCall sharedInstance];
    [pageCall setDelegate:self];
    [pageCall connectInMyID:myId roomId:roomId pcaURL:url];
    
    pageCall.pcViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:pageCall.pcViewController animated:YES completion:nil];

### 3. PageCall 종료

PageCallDelegate를 통해 PageCall 종료 이벤트를 받을 수 있습니다.

    // Swift
    extension ViewController: PageCallDelegate {
        func pageCallDidClose() {
            print("pageCallDidClose")
        }
    }

    // Objective-C
    @interface ViewController ()<PageCallDelegate>
    
    ...
    
    - (void)pageCallDidClose {
        NSLog(@"pageCallDidClose");
    }

## 추가 기능

### PageCall Log 파일

PageCall 사용 시 기록된 Log를 사용자 App의 `Documents` 에 Log 파일을 자동으로 저장합니다.

    // Swift
    pageCall.enableLog()

    // Objective-C
    [pageCall enablePageCallLog];

*NOTE*: 단,  해당 기능은 `Release`모드에서만 사용해야 합니다.  `Debug` 모드에서는 Xcode의 Console에 메세지가 나타나지 않습니다.
