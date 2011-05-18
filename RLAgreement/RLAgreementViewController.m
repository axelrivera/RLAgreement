//
//  RLAgreementViewController.m
//  RLAgreement
//
//  Created by Axel Rivera on 5/16/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import "RLAgreementViewController.h"

NSString * const kRLAgreementIdentifier = @"RLAgreementIdentifier";

@interface RLAgreementViewController (Private)

// Private Methods

- (void)setupToolBar;

- (void)agreementEmail;
- (void)agreementAlert;
- (void)agreementDone;
- (void)agreementDismiss;

- (void)loadCurrentPage;

- (BOOL)isPDFAvailable;
- (NSString *)PDFFilePath;

@end

// Some constants used within the controller

static NSString * const kRLViewControllerTitle = @"Terms of Service";

// File extension to be used in all the files
// This is used in combination with the values of htmlFiles_ array
static NSString * const kFileExtension = @"html";

static NSString * const kNotFoundString = @"<html><body/><h1>File Not Found</h1></body></html>";

// You can include a PDF file with the full Agreement
// Your users will be able to send the agreement to themselves by e-mail.
// Don't forget to include the PDF file within your code.
// Name Only (NO Extension) 
// You can use an empty string (@"") if you don't want to use a PDF file
static NSString * const kPDFName = @"Agreement";

// Extension of the for the PDF file
// Only PDF is Supported
static NSString * const kPDFExtension = @"pdf";

// Text for the Agree Button
static NSString * const kAgreeButtonText = @"I Agree";

@implementation RLAgreementViewController

@synthesize webView = webView_;
@synthesize toolBar = toolBar_;
@synthesize isAgreementValid = isAgreementValid_;

- (id)init
{
	self = [super initWithNibName:@"RLAgreementViewController" bundle:nil];
	if (self) {
		
		// Check if the user has a valid agreement
		BOOL validAgreement = [[NSUserDefaults standardUserDefaults] boolForKey:kRLAgreementIdentifier];
		
		self.isAgreementValid = NO;
		
		if (validAgreement) {
			self.isAgreementValid = YES;
		}
		
		// If the user has a valid agreement show a "Done" button in the left button inside the Navigation Bar
		// This is used if you wan't to show the agreement later on within the app after the user has agreed to your terms.
		if (self.isAgreementValid) {
			UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																						target:self
																						action:@selector(agreementDismiss)];
			self.navigationItem.leftBarButtonItem = doneButton;
			[doneButton release];
		}
		
		// Check if there's a PDF file available and create an e-mail button
		if ([self isPDFAvailable]) {
			UIBarButtonItem *emailButton = [[UIBarButtonItem alloc] initWithTitle:@"E-mail"
																			style:UIBarButtonItemStyleBordered
																		   target:self action:@selector(agreementEmail)];
			self.navigationItem.rightBarButtonItem = emailButton;
			[emailButton release];
		}
		
		// Define All the files to be shown in this array.
		// Files must NOT include the file extension.
		// You can include as many files as you want just don't forget to iclude the files in your code.
		// The array must not be EMPTY!!!
		
		htmlFiles_ = [[NSArray alloc] initWithObjects:
					  @"File1",
					  @"File2",
					  nil];
		
		// Make sure you start at page 1
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
	// Decrease page index and reload page
	// The previous button will be disabled automatically when necessary
	currentIndex_--;
	[self loadCurrentPage];
}

- (void)nextPage
{
	// Increase page index and reload page
	// The next button will be disabled when necessary
	currentIndex_++;
	[self loadCurrentPage];
}

- (void)agreementEmail
{
	MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
	mailer.mailComposeDelegate = self;
	
	// Load the contents of the PDF file
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
	// Agreement alert to confirm that the user has accepted the agreement.
	NSString *messageString = [NSString stringWithFormat:
							   @"By tapping the %@ button, you confirm that you have read the terms and "
							   @"conditions, that you understand them and that you agree to be bound by them.",
							   kAgreeButtonText];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kRLViewControllerTitle
													message:messageString
												   delegate:self
										  cancelButtonTitle:@"Cancel"
										  otherButtonTitles:kAgreeButtonText, nil];
	[alert show];
	[alert release];
}

- (void)agreementDone
{
	// The user has accepted the Agreement
	// Store the confirmation in NSUserDefaults
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
	
	// Show the agree button only if the user hasn't accepted the agreement yet
	if (self.isAgreementValid) {
		UIBarButtonItem *dummySpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
																					target:self
																					action:nil];
		dummySpace.width = 65.0;
		[toolBarItems addObject:dummySpace];
		[dummySpace release];
	} else {
		UIBarButtonItem *agreeButton = [[UIBarButtonItem alloc] initWithTitle:kAgreeButtonText
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
	
	// Check if the page index is out of range and exit with an error
	NSAssert(fileCount > 0, @"The File Array cannot be empty");
	NSAssert(currentIndex_ >=  0, @"The current index is out of range");
	NSAssert(currentIndex_ < fileCount, @"The current index is out of range");
	
	// Enable/Disable previous and next buttons according to the contents of htmlFiles_ array
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
	
	// Check if the file provided by htmlFiles_ array exists
	// Otherwhise display an empty page
	if ([fileManager fileExistsAtPath:filePath]) {
		NSURL *url = [NSURL fileURLWithPath:filePath];
		[webView_ loadRequest:[NSURLRequest requestWithURL:url]];
	} else {
		[webView_ loadHTMLString:kNotFoundString baseURL:nil];
	}
	
	// Update the page label
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
