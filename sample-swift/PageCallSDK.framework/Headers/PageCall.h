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

@property (nonatomic, weak, nullable) id<PageCallDelegate> delegate;

@property (nonatomic, strong) PCMainViewController* mainViewController;

+ (PageCall *)sharedInstance;

// Close the PageCall window
- (void)pageCallClose;

- (NSString *)pageCallLogFilePath;

- (void)enablePageCallLog;

- (void)restoreLog;

@end

NS_ASSUME_NONNULL_END
