//
//  RootViewController.m
//  RLAgreement
//
//  Created by Axel Rivera on 5/16/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import "RootViewController.h"
#import "RLAgreementViewController.h"

@interface RootViewController (Private)

- (void)setLabelText;

@end

@implementation RootViewController

@synthesize agreementLabel = agreementLabel_;

- (id)init
{
	self = [super initWithNibName:@"RootViewController" bundle:nil];
	if (self) {
		// Initialization Code
	}
	return self;
}

- (void)dealloc
{
	[agreementLabel_ release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.agreementLabel = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self setLabelText];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Methods

- (void)setLabelText
{
	BOOL validAgreement = [[NSUserDefaults standardUserDefaults] boolForKey:kRLAgreementIdentifier];
	
	NSString *agreementString;
	
	if (validAgreement) {
		agreementString = @"YES";
	} else {
		agreementString = @"NO";
	}
	
	self.agreementLabel.text = [NSString stringWithFormat:@"Value for kRLAgreementIdentifier\nin NSUserDefaults: %@", agreementString];
}

#pragma mark - Custom Actions

- (IBAction)agreementShow:(id)sender
{
	RLAgreementViewController *agreementController = [[RLAgreementViewController alloc] init];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:agreementController];
	
	[agreementController release];
	
	[self presentModalViewController:navController animated:YES];
	[navController release];
}

- (IBAction)agreementReset:(id)sender
{
	[[NSUserDefaults standardUserDefaults] setBool:NO forKey:kRLAgreementIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
	[self setLabelText];
}

@end
