//
//  PageCall.h
//  PageCallSDK
//
//  Created by Park Sehun on 14/02/2019.
//  Copyright © 2019 Park Sehun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCMainViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PageCallDelegate <NSObject>

- (void)pageCallDidClose;

@end

@interface PageCall : NSObject<PCMainViewControllerDelegate>

@property (nonatomic, assign, nullable) id<PageCallDelegate> delegate;

@property (nonatomic, strong, nullable) PCMainViewController* pcViewController;

+ (PageCall *)sharedInstance;

// PCA ConnectionIn
- (PCMainViewController *)connectInMyID:(NSString *)myId roomId:(NSString *)roomId pcaURL:(NSString *)pcaURL;

// PCA Call
- (PCMainViewController *)callWithMyId:(NSString *)myId roomId:(NSString *)publicRoomId pcaURL:(NSString*)pcaURL;

// Load HTML String
- (PCMainViewController *)loadHTMLString:(NSString *)htmlString;

- (PCMainViewController *)webViewLoadRequestWithURLString:(NSString *)urlString;

- (NSString *)pageCallLogFilePath;

- (void)enablePageCallLog;

- (void)restoreLog;

// Close the PageCall window
- (void)pageCallClose;

@end

NS_ASSUME_NONNULL_END
