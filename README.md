# PageCall iOS SDK

## 요구사항

- Xcode ≥ 11.1
- iOS ≥ 11
- swift-version ≥ 4.2

## 설치

- `PageCallSDK.framework`, `WebRTC.framework` 두 개의 framework를 iOS 프로젝트에 추가

    ![PageCall%20iOS%20SDK/_2019-11-22__7.01.04.png](README/_2019-11-22__7.01.04.png)

- Embed 옵션은 `Embed & Sign` 으로 설정
- Build Settings -> Build Options -> `Enable Bitcode = No` 로 설정
- Build Settings -> Swift Compiler -> Import Paths  + `$(SRCROOT)/PageCallSDK.framework/Headers` 추가

## 개인정보 허용에 대한 설명 추가

iOS 프로젝트의 info.plist에 아래와 같이 개인정보 허용에 대한 설명을 추가 한다.

    <key>NSCameraUsageDescription</key>
    <string>Blink uses your camera to make video calls.</string>
    <key>NSContactsUsageDescription</key>
    <string>Blink needs access to your contacts in order to be able to call them.</string>
    <key>NSMicrophoneUsageDescription</key>
    <string>Blink uses your microphone to make calls.</string>
    <key>NSPhotoLibraryAddUsageDescription</key>
    <string>Our application needs permission to write photos...</string

## 예제

### PageCallSDK 추가

    import PageCallSDK

    #import <PageCallSDK/PageCallSDK.h>

### PageCall 실행

    let pageCall = PageCall.sharedInstance()
    pageCall.delegate = self
    pageCall.call(withMyId: self.myId.text!, roomId: self.roomId.text!, pcaURL: self.serverURL.text!)
    
    pageCall.pcViewController?.modalPresentationStyle = .overFullScreen
    self.present(pageCall.pcViewController!, animated: true, completion: nil)

    PageCall *pageCall = [PageCall sharedInstance];
    [pageCall setDelegate:self];
    [pageCall callWithMyId:self.myId.text roomId:self.roomId.text pcaURL:self.serverURL.text];
    
    pageCall.pcViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:pageCall.pcViewController animated:YES completion:nil];

### PageCall 종료

PageCallDelegate를 통해 PageCall 종료 이벤트를 받을 수 있다.

    extension ViewController: PageCallDelegate {
        func pageCallDidClose() {
            print("pageCallDidClose")
        }
    }

    @interface ViewController ()<PageCallDelegate>
    
    ...
    
    - (void)pageCallDidClose {
        NSLog(@"pageCallDidClose");
    }

### PageCall 로그 파일

PageCall 로그 기능을 사용하면 PageCall 사용 시 기록한 로그를 App의 `Documents` 에 로그 파일을 자동으로 저장한다.

    pageCall.enableLog()

    [pageCall enablePageCallLog];
