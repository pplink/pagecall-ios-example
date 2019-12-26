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
- (void)connectInMyId:(NSString *)myId publicRoomId:(NSString *)publicRoomId pcaURL:(NSString*)pcaURL;

// PCA Call
- (void)callWithMyId:(NSString *)myId publicRoomId:(NSString *)publicRoomId pcaURL:(NSString*)pcaURL;

// Load HTML String
- (void)loadHTMLString:(NSString *)htmlString;

- (void)webViewLoadRequestWithURLString:(NSString *)urlString;

// Close the PageCall window
- (void)pageCallClose;

@end
