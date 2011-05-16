//
//  RLAgreementViewController.m
//  RLAgreement
//
//  Created by arn on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RLAgreementViewController.h"

@implementation RLAgreementViewController

@synthesize webView = webView_;
@synthesize toolBar = toolBar_;

- (id)init
{
	self = [super initWithNibName:@"RLAgreementViewController" bundle:nil];
	if (self) {
			
		UIBarButtonItem *actionItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
																				  target:self action:@selector(callActions)];
		actionItem.style = UIBarButtonItemStylePlain;
		
		self.navigationItem.rightBarButtonItem = actionItem;
		[actionItem release];
		
		htmlFiles_ = [[NSArray alloc] initWithObjects:
					  @"File1",
					  @"File2",
					  nil];
	}
	return self;
}

- (void)dealloc
{
	[htmlFiles_ release];
	[webView_ release];
	[toolBar_ release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = @"Legal";
	
	currentFile_ = [htmlFiles_ objectAtIndex:0];
	
	NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"File1" ofType:@"html"]];
	[webView_ loadRequest:[NSURLRequest requestWithURL:url]];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.webView = nil;
	self.toolBar = nil;
}

#pragma mark - Custom Actions and Selectors

#pragma mark Interface Builder Actions


#pragma mark Custom Selectors

- (void)callActions
{
	
}

@end
