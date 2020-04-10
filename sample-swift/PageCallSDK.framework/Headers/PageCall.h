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

@property (nonatomic, strong) UIViewController* mainViewController;

+ (PageCall *)sharedInstance;

// PCA ConnectionIn
- (void)connectInMyID:(NSString *)myID roomID:(NSString *)roomID serverURL:(NSString*)serverURL;

// PCA Call
- (void)callMyID:(NSString *)myID roomID:(NSString *)roomID serverURL:(NSString*)serverURL;

// PCA Replay
- (void)replayWithRoomID:(NSString *)roomID serverURL:(NSString*)serverURL;

// Load HTML String
- (void)loadHTMLString:(NSString *)htmlString;

// Request with URL
- (void)webViewLoadRequestWithURLString:(NSString *)urlString;

// Close the PageCall window
- (void)pageCallClose;

// Get log file path
- (NSString *)pageCallLogFilePath;

// Log to Documents
- (void)redirectLogToDocumentsWithInterval:(NSInteger)hour;

- (void)restoreLog;

@end

NS_ASSUME_NONNULL_END
