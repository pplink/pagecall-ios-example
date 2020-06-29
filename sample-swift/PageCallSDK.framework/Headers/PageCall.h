//
//  PageCall.h
//  PageCallSDK
//
//  Created by Park Sehun on 14/02/2019.
//  Copyright © 2019 Park Sehun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PageCallDelegate <NSObject>

- (void)pageCallDidClose;

@end

@interface PageCall : NSObject

@property (nonatomic, weak, nullable) id<PageCallDelegate> delegate;
@property (nonatomic, weak) UIViewController* mainViewController;

+ (PageCall *)sharedInstance;

// PCA ConnectionIn
- (void)connectIn:(NSString*)requestUrl myId:(NSString *)myId publicRoomId:(NSString *)publicRoomId;

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

// Get log file path
- (NSString *)pageCallLogFilePath;

// Log to Documents
- (void)redirectLogToDocumentsWithTimeInterval:(NSInteger)hour;

- (void)redirectLogToDocumentsWithRoomCount:(NSInteger)count;

- (void)restoreLog;

@end

NS_ASSUME_NONNULL_END
