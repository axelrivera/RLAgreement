//
//  RLAgreementViewController.h
//  RLAgreement
//
//  Created by arn on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RLAgreementViewController : UIViewController {
    NSArray *htmlFiles_;
	NSString *currentFile_;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolBar;

@end
