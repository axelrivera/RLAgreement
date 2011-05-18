//
//  RootViewController.h
//  RLAgreement
//
//  Created by arn on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RootViewController : UIViewController {
    
}

@property (nonatomic, retain) IBOutlet UILabel *agreementLabel;

- (IBAction)agreementShow:(id)sender;
- (IBAction)agreementReset:(id)sender;

@end
