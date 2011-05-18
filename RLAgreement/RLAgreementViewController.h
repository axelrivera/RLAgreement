//
//  RLAgreementViewController.h
//  RLAgreement
//
//  Created by Axel Rivera on 5/16/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import <UIKit/UIKit.h>

// Used to send a copy of the Agreement by e-mail
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

// Defining kRLAgreementIdentifier as "extern" to be able to use its value within the App
extern NSString * const kRLAgreementIdentifier;

@interface RLAgreementViewController : UIViewController <MFMailComposeViewControllerDelegate> {
    NSArray *htmlFiles_;
	NSUInteger currentIndex_;
	
	// Keeping a reference to the "Previous" and "Next" buttons in the UIToolbar
	// They will be disabled when loading a new page if necessary.
	UIBarButtonItem *prevButton_;
	UIBarButtonItem *nextButton_;
	
	UILabel *pagesLabel_;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolBar;

// Store the value of kRLAgreementIdentifier from NSUserDefaults 
@property (nonatomic) BOOL isAgreementValid;

@end
