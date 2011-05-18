//
//  RLAgreementViewController.m
//  RLAgreement
//
//  Created by arn on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RLAgreementViewController.h"

NSString * const kRLAgreementIdentifier = @"RLAgreementIdentifier";

@interface RLAgreementViewController (Private)

- (void)setupToolBar;

- (void)agreementEmail;
- (void)agreementAlert;
- (void)agreementDone;
- (void)agreementDismiss;

- (void)loadCurrentPage;

- (BOOL)isPDFAvailable;
- (NSString *)PDFFilePath;

@end

static NSString * const kRLViewControllerTitle = @"Terms of Service";
static NSString * const kFileExtension = @"html";
static NSString * const kNotFoundString = @"<html><body/><h1>File Not Found</h1></body></html>";

// Name Only (NO Extension) 
// You can use an empty string (@"") if you don't want to use a PDF file
static NSString * const kPDFName = @"Agreement";

// Only PDF is Supported
static NSString * const kPDFExtension = @"pdf";

@implementation RLAgreementViewController

@synthesize webView = webView_;
@synthesize toolBar = toolBar_;
@synthesize isAgreementValid = isAgreementValid_;

- (id)init
{
	self = [super initWithNibName:@"RLAgreementViewController" bundle:nil];
	if (self) {
		BOOL validAgreement = [[NSUserDefaults standardUserDefaults] boolForKey:kRLAgreementIdentifier];
		
		self.isAgreementValid = NO;
		
		if (validAgreement) {
			self.isAgreementValid = YES;
		}
		
		if (self.isAgreementValid) {
			UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																						target:self
																						action:@selector(agreementDismiss)];
			self.navigationItem.leftBarButtonItem = doneButton;
			[doneButton release];
		}
		
		if ([self isPDFAvailable]) {
			UIBarButtonItem *emailButton = [[UIBarButtonItem alloc] initWithTitle:@"E-mail"
																			style:UIBarButtonItemStyleBordered
																		   target:self action:@selector(agreementEmail)];
			self.navigationItem.rightBarButtonItem = emailButton;
			[emailButton release];
		}
		
		// Define All the files to be shown
		// Files must NOT include the file extension
		htmlFiles_ = [[NSArray alloc] initWithObjects:
					  @"File1",
					  @"File2",
					  nil];
		
		currentIndex_ = 0;
	}
	return self;
}

- (void)dealloc
{
	[htmlFiles_ release];
	[webView_ release];
	[toolBar_ release];
	[prevButton_ release];
	[nextButton_ release];
	[pagesLabel_ release];
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
	
	self.title = kRLViewControllerTitle;
	
	[self setupToolBar];
	
	[self loadCurrentPage];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[pagesLabel_ release];
	[prevButton_ release];
	[nextButton_ release];
	self.webView = nil;
	self.toolBar = nil;
}

#pragma mark - Custom Actions and Selectors

- (void)prevPage
{
	currentIndex_--;
	[self loadCurrentPage];
}

- (void)nextPage
{
	currentIndex_++;
	[self loadCurrentPage];
}

- (void)agreementEmail
{
	MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
	mailer.mailComposeDelegate = self;
	
	NSData *pdfData = [NSData dataWithContentsOfFile:[self PDFFilePath]];
	[mailer addAttachmentData:pdfData
					 mimeType:@"application/pdf"
					 fileName:[NSString stringWithFormat:@"%@.%@", kPDFName, kPDFExtension]];
	
	[mailer setSubject:kRLViewControllerTitle];
	
	[self presentModalViewController:mailer animated:YES];
	[mailer release];
}

- (void)agreementAlert
{
	NSString *messageString = [NSString stringWithFormat:
							   @"By tapping the \"I Agree\" button, you confirm that you have read the terms and "
							   @"conditions, that you understand them and that you agree to be bound by them."];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kRLViewControllerTitle
													message:messageString
												   delegate:self
										  cancelButtonTitle:@"Cancel"
										  otherButtonTitles:@"I Agree", nil];
	[alert show];
	[alert release];
}

- (void)agreementDone
{
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kRLAgreementIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.isAgreementValid = YES;
	[self agreementDismiss];
}

- (void)agreementDismiss
{
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Private Methods

- (void)setupToolBar
{	
	UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																				   target:self
																				   action:nil];
	
	UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
																				target:self action:nil];
	fixedSpace.width = 20.0;
	
	prevButton_ = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"prev.png"]
												   style:UIBarButtonItemStylePlain
												  target:self
												  action:@selector(prevPage)];
	
	nextButton_ = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"next.png"]
												   style:UIBarButtonItemStylePlain
												  target:self
												  action:@selector(nextPage)];
	
	pagesLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 150.0, 25.0)];
	pagesLabel_.backgroundColor = [UIColor clearColor];
	pagesLabel_.textAlignment = UITextAlignmentCenter;
	pagesLabel_.font = [UIFont systemFontOfSize:14.0];
	pagesLabel_.textColor = [UIColor whiteColor];
	pagesLabel_.shadowColor = [UIColor darkGrayColor];
	pagesLabel_.shadowOffset = CGSizeMake(0.0, -1.0);
	
	UIBarButtonItem *pagesItem = [[UIBarButtonItem alloc] initWithCustomView:pagesLabel_];
	
	NSMutableArray *toolBarItems = [[NSMutableArray alloc] initWithCapacity:6];
	
	[toolBarItems addObject:prevButton_];
	[toolBarItems addObject:fixedSpace];
	[toolBarItems addObject:nextButton_];
	[toolBarItems addObject:flexibleSpace];
	[toolBarItems addObject:pagesItem];
	
	[flexibleSpace release];
	[fixedSpace release];
	[pagesItem release];
	
	if (self.isAgreementValid) {
		UIBarButtonItem *dummySpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
																					target:self
																					action:nil];
		dummySpace.width = 65.0;
		[toolBarItems addObject:dummySpace];
		[dummySpace release];
	} else {
		UIBarButtonItem *agreeButton = [[UIBarButtonItem alloc] initWithTitle:@"I Agree"
																		style:UIBarButtonItemStyleDone
																	   target:self
																	   action:@selector(agreementAlert)];
		[toolBarItems addObject:agreeButton];
		[agreeButton release];
	}
	
	self.toolBar.items = toolBarItems;
	[toolBarItems release];
}

- (void)loadCurrentPage
{
	NSInteger fileCount = [htmlFiles_ count];
	
	NSAssert(fileCount > 0, @"The File Array cannot be empty");
	NSAssert(currentIndex_ >=  0, @"The current index is out of range");
	NSAssert(currentIndex_ < fileCount, @"The current index is out of range");
	
	if (currentIndex_ == 0) {
		prevButton_.enabled = NO;
	} else {
		prevButton_.enabled = YES;
	}
	
	if (currentIndex_ < fileCount - 1) {
		nextButton_.enabled = YES;
	} else {
		nextButton_.enabled = NO;
	}
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:[htmlFiles_ objectAtIndex:currentIndex_]
														 ofType:kFileExtension];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	if ([fileManager fileExistsAtPath:filePath]) {
		NSURL *url = [NSURL fileURLWithPath:filePath];
		[webView_ loadRequest:[NSURLRequest requestWithURL:url]];
	} else {
		[webView_ loadHTMLString:kNotFoundString baseURL:nil];
	}
	
	pagesLabel_.text = [NSString stringWithFormat:@"Page %d of %d", currentIndex_ + 1, fileCount];
}

- (BOOL)isPDFAvailable
{
	BOOL isAvailable = NO;
	NSString *filePath = [self PDFFilePath];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	if ([kPDFName length] > 0 && [fileManager fileExistsAtPath:filePath]) {
		isAvailable = YES;
	}
	return isAvailable;
}

- (NSString *)PDFFilePath
{
	NSString *filePath = [[NSBundle mainBundle] pathForResource:kPDFName
														 ofType:kPDFExtension];
	
	return filePath;
}

#pragma mark - MFMailComposeViewController Delegate

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {	
	NSString *errorString = nil;
	
	BOOL showAlert = NO;
	// Notifies users about errors associated with the interface
	switch (result)  {
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			break;
		case MFMailComposeResultFailed:
			errorString = [NSString stringWithFormat:@"E-mail failed: %@", 
						   [error localizedDescription]];
			showAlert = YES;
			break;
		default:
			errorString = [NSString stringWithFormat:@"E-mail was not sent: %@", 
						   [error localizedDescription]];
			showAlert = YES;
			break;
	}
	
	[self dismissModalViewControllerAnimated:YES];
	
	if (showAlert == YES) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"E-mail Error"
														message:errorString
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex > 0) {
		[self agreementDone];
	}
}

@end
