//
//  MTZViewController.m
//  Rewritten APIs
//
//  Created by Matt on 8/23/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZViewController.h"
#import "MTZActionSheet.h"
#import "MTZAlertView.h"

@interface MTZViewController () <MTZActionSheetDelegate, MTZAlertViewDelegate>

@property (strong, nonatomic) MTZActionSheet *actionSheet;
@property (strong, nonatomic) MTZAlertView *alertView;

@end

@implementation MTZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	// Setting up Action Sheet Button
	UIButton *actionSheetButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 300, 44)];
	[actionSheetButton setBackgroundColor:[UIColor blueColor]];
	[actionSheetButton setShowsTouchWhenHighlighted:YES];
	[actionSheetButton setTitle:@"Show Action Sheet" forState:UIControlStateNormal];
	[actionSheetButton addTarget:self
						  action:@selector(didTapActionSheetButton:)
				forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:actionSheetButton];
	
	// Setting up Alert View Button
	UIButton *alertViewButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 64, 300, 44)];
	[alertViewButton setBackgroundColor:[UIColor blueColor]];
	[alertViewButton setShowsTouchWhenHighlighted:YES];
	[alertViewButton setTitle:@"Show Alert" forState:UIControlStateNormal];
	[alertViewButton addTarget:self
						action:@selector(didTapAlertButton:)
			  forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:alertViewButton];
}


#pragma mark Action Sheet

- (void)didTapActionSheetButton:(id)sender
{
	_actionSheet = [[MTZActionSheet alloc] init];
	_actionSheet.title = @"My Action Sheet Title";
	_actionSheet.delegate = self;
	_actionSheet.cancelButtonTitle = @"Cancel";
	_actionSheet.destructiveButtonTitle = @"Destructive";
	[_actionSheet addButtonWithTitle:nil andSelector:nil];
	[_actionSheet addButtonWithTitle:@"Other Button" andSelector:@selector(tappedOtherButton:)];
	[_actionSheet addButtonWithTitle:@"Another Button" andSelector:@selector(tappedAnotherButton)];
	[_actionSheet showInView:self.view];
	
	/*
	[self performSelector:@selector(actionSheetAPITest)
			   withObject:nil
			   afterDelay:2.0f];
	 */
}

- (void)actionSheetAPITest
{
	NSLog(@"%@", _actionSheet.buttonTitles);
	NSLog(@"%@", _actionSheet.otherButtonTitles);
	NSLog(@"%lu", (unsigned long) _actionSheet.numberOfButtons);
	NSLog(@"%lu", (unsigned long) _actionSheet.numberOfOtherButtons);
//	[_actionSheet dismissWithTappedButtonTitle:_actionSheet.cancelButtonTitle animated:YES]; // This shouldn't be necessary
//	[_actionSheet dismissWithTappedButtonTitle:_actionSheet.destructiveButtonTitle animated:YES]; // This shouldn't be necessary
//	[_actionSheet dismissWithTappedButtonTitle:@"Cancel" animated:YES]; // This shouldn't be necessary
	[_actionSheet dismissWithCancel];
}

- (void)actionSheetDidTapDestructiveButton:(MTZActionSheet *)actionSheet
{
	NSLog(@"Action Sheet (%@) tapped Destructive Button", actionSheet);
}

- (void)actionSheetDidTapCancelButton:(MTZActionSheet *)actionSheet
{
	NSLog(@"Action Sheet (%@) tapped Cancel Button", actionSheet);
}

- (void)tappedOtherButton:(id)sender
{
	NSLog(@"Tapped Other Button: %@", sender);
}

- (void)tappedAnotherButton
{
	NSLog(@"Tapped Another Button");
}


#pragma mark Alert

- (void)didTapAlertButton:(id)sender
{
	_alertView = [[MTZAlertView alloc] init];
	_alertView.title = @"My Alert View Title";
	_alertView.message = @"My Message";
	_alertView.delegate = self;
	_alertView.cancelButtonTitle = @"Cancel";
	[_alertView addButtonWithTitle:@"Other Button"
					   andSelector:@selector(tappedOtherAlertButton:)];
	[_alertView addButtonWithTitle:@"Another Button"
					   andSelector:@selector(tappedAnotherAlertButton)];
	[_alertView show];
	
	 [self performSelector:@selector(alertViewAPITest)
				withObject:nil
				afterDelay:2.0f];
}

- (void)alertViewAPITest
{
	NSLog(@"TESTING ALERT VIEW");
}

- (void)alertViewDidTapCancelButton:(MTZAlertView *)alertView
{
	NSLog(@"Alert View (%@) tapped Cancel Button", alertView);
}

- (void)tappedOtherAlertButton:(id)sender
{
	NSLog(@"Tapped Other Alert Button: %@", sender);
}

- (void)tappedAnotherAlertButton
{
	NSLog(@"Tapped Another Alert Button");
}


#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
