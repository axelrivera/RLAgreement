//
//  RLAgreementViewController.h
//  RLAgreement
//
//  Created by arn on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface RLAgreementViewController : UIViewController <MFMailComposeViewControllerDelegate> {
    NSArray *htmlFiles_;
	NSUInteger currentIndex_;
	
	UIBarButtonItem *prevButton_;
	UIBarButtonItem *nextButton_;
	UILabel *pagesLabel_;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolBar;

@end
