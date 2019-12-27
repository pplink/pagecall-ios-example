//
//  PCMainViewController.h
//  PageCallSDK
//
//  Created by Park Sehun on 11/02/2019.
//  Copyright © 2019 Park Sehun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol PCMainViewControllerDelegate <NSObject>

- (void)pageCallDidClose;

@end

@interface PCMainViewController : UIViewController

@property (nonatomic, weak) id<PCMainViewControllerDelegate> delegate;

// PCA ConnectionIn
- (void)connectInMyID:(NSString *)myID roomID:(NSString *)roomID serverURL:(NSString*)serverURL;

// PCA Call
- (void)callMyID:(NSString *)myID roomID:(NSString *)roomID serverURL:(NSString*)serverURL;

// Load HTML String
- (void)loadHTMLString:(NSString *)htmlString;

- (void)webViewLoadRequestWithURLString:(NSString *)urlString;

// Close the PageCall window
- (void)pageCallClose;

@end
