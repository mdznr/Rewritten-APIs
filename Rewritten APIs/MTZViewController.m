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

@end

@implementation MTZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


#pragma mark - Action Sheet

- (IBAction)didTapActionSheetButton:(id)sender
{
	MTZActionSheet *actionSheet = [[MTZActionSheet alloc] initWithTitle:@"My Action Sheet Title"];
	actionSheet.delegate = self;
	actionSheet.cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
	actionSheet.destructiveButtonTitle = @"Destructive";
	
	// You can add a button and corresponding selector.
	[actionSheet addButtonWithTitle:@"A Button" andSelector:@selector(tappedAButton:)];
	
	// You can add a button and corresponding block.
	[actionSheet addButtonWithTitle:@"Another Button"
						   andBlock:^{
							   NSLog(@"Tapped Another Button");
						   }];
	
	[actionSheet showInView:self.view];
}

- (void)actionSheetDidTapCancelButton:(MTZActionSheet *)actionSheet
{
	NSLog(@"Action Sheet (%@) tapped Cancel Button", actionSheet);
}

- (void)actionSheetDidTapDestructiveButton:(MTZActionSheet *)actionSheet
{
	NSLog(@"Action Sheet (%@) tapped Destructive Button", actionSheet);
}

- (void)tappedAButton:(id)sender
{
	NSLog(@"Tapped A Button: %@", sender);
}


#pragma mark - Alert View

- (IBAction)didTapAlertViewButton:(id)sender
{
	MTZAlertView *alertView = [[MTZAlertView alloc] initWithTitle:@"My Alert View Title"
													   andMessage:@"My Message"];
	alertView.delegate = self;
	alertView.cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
	
	// You can add a button and corresponding selector.
	[alertView addButtonWithTitle:@"Other Button" andSelector:@selector(tappedOtherAlertButton:)];
	
	// You can add a button and corresponding block.
	[alertView addButtonWithTitle:@"Another Button"
						 andBlock:^{
							 NSLog(@"Tapped Another Alert Button");
						 }];
	
	[alertView show];
}

- (void)alertViewDidTapCancelButton:(MTZAlertView *)alertView
{
	NSLog(@"Alert View (%@) tapped Cancel Button", alertView);
}

- (void)tappedOtherAlertButton:(MTZAlertView *)alertView
{
	NSLog(@"Tapped Other Alert Button: %@", alertView);
//	[(MTZAlertView *)alertView textInInputField];
}

- (BOOL)alertView:(MTZAlertView *)alertView shouldEnableButtonWithTitle:(NSString *)buttonTitle
{
	if ( [buttonTitle isEqualToString:@"Other Button"] ) {
		return YES;
	} else {
		return NO;
	}
}


#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
