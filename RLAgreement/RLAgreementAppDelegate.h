//
//  RLAgreementAppDelegate.h
//  RLAgreement
//
//  Created by Axel Rivera on 5/16/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface RLAgreementAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet RootViewController *viewController;

@end
