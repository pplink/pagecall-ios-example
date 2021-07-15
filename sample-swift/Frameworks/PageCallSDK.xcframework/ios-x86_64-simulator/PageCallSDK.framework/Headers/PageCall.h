//
//  PageCall.h
//  PageCallSDK
//
//  Created by Park Sehun on 14/02/2019.
//  Copyright © 2019 Park Sehun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#import <CallKit/CallKit.h>
#import <CallKit/CXError.h>

typedef NS_ENUM(NSInteger, CallActionType) {
    CallActionTypeStart,
    CallActionTypeEnd,
    CallActionTypeAnswer,
    CallActionTypeMute,
    CallActionTypeHeld
};

typedef NS_ENUM(NSInteger, CallKitState) {
    CallKitStatePending,
    CallKitStateConnecting,
    CallKitStateConnected,
    CallKitStateEnded,
    CallKitStateEndedWithFailure,
    CallKitStateEndedUnanswered,
    CallKitStateEndedReasonAnsweredElsewhere,  // The call was answered on another device
    CallKitStateEndedReasonDeclinedElsewhere   // The call was declined on another device
};

NS_ASSUME_NONNULL_BEGIN

@protocol PageCallDelegate <NSObject>

@optional

// PageCallDelegate
- (void)pageCallDidClose;
- (void)pageCallDidReceiveScriptMessage:(WKScriptMessage *)message;

// WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation;
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation;
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation;

// WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler;
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler;

@end

@interface PageCall : NSObject

@property (nonatomic, strong) dispatch_queue_t completionQueue; // Default to mainQueue

@property (nonatomic, weak, nullable) id<PageCallDelegate> delegate;
@property (nonatomic, weak) UIViewController* mainViewController;
@property (nonatomic, weak) WKWebView* webView;

+ (PageCall *)sharedInstance;

// PCA ConnectionIn
- (void)connectIn:(NSString*)requestUrl myId:(NSString *)myId publicRoomId:(NSString *)publicRoomId;
- (void)connectIn:(NSDictionary*)pcaInfo roomData:(nullable NSDictionary *)roomData userData:(nullable NSDictionary *)userData template:(nullable NSDictionary *)template;

// PCA Call
- (void)call:(NSString*)requestUrl publicRoomId:(NSString *)publicRoomId query:(nullable NSString *)query;

// PCA Replay
- (void)replay:(NSString*)requestUrl roomId:(NSString *)roomId;

// Live Streaming
- (void)liveStreamingWithURL:(NSString *)urlString;

// Live Streaming
- (void)liveStreamingWithURL:(NSString *)urlString isHost:(BOOL)isHost roomID:(NSString *)roomID userID:(NSString *)userID userName:(NSString *)userName;

// Load HTML String
- (void)loadHTMLString:(NSString *)htmlString;

// Request with URL
- (void)webViewLoadRequestWithURLString:(NSString *)urlString;

// Close the PageCall window
- (void)pageCallClose;

// Close the PageCall with time interval
- (void)pageCallCloseWithTimeInterval:(NSTimeInterval)timeInterval;

// PCA runJSFunction
- (void)runJSFunction:(NSString *)functionName completionHandler:(void (^)(BOOL result))completionHandler;

// CallKit
- (void)startCallAction;
- (void)connectedCall;
- (void)endCallAction;

// Get logs directory path
- (NSString *)pageCallLogsDirectoryPath;

// Get log file path
- (NSString *)pageCallLogFilePath;

// Log to Documents
- (void)redirectLogToDocumentsWithTimeInterval:(NSInteger)hour;
- (void)restoreLog;

// PageCall Delegate
- (void)pageCallDidClose;
- (void)pageCallDidReceiveScriptMessage:(WKScriptMessage *)message;

// WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation;
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation;
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation;

// WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler;
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler;

@end

NS_ASSUME_NONNULL_END
