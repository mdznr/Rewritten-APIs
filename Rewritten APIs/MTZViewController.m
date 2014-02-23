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
}


#pragma mark - Action Sheet

- (IBAction)didTapActionSheetButton:(id)sender
{
	_actionSheet = [[MTZActionSheet alloc] initWithTitle:@"My Action Sheet Title"];
	_actionSheet.delegate = self;
	_actionSheet.cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
	_actionSheet.destructiveButtonTitle = @"Destructive";
	
	// You can add a button and corresponding selector.
	[_actionSheet addButtonWithTitle:@"A Button" andSelector:@selector(tappedAButton:)];
	
	// You can add a button and corresponding block.
	[_actionSheet addButtonWithTitle:@"Another Button"
							andBlock:^{
								NSLog(@"Tapped Another Button");
							}];
	
	[_actionSheet showInView:self.view];
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


#pragma mark - Alert

- (IBAction)didTapAlertButton:(id)sender
{
	_alertView = [[MTZAlertView alloc] init];
	_alertView.title = @"My Alert View Title";
	_alertView.message = @"My Message";
	_alertView.style = UIAlertViewStyleSecureTextInput;
	_alertView.delegate = self;
	_alertView.cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
	[_alertView addButtonWithTitle:@"Other Button"
					   andSelector:@selector(tappedOtherAlertButton:)];
	[_alertView addButtonWithTitle:@"Another Button"
						  andBlock:^{
							  NSLog(@"Tapped Another Alert Button");
						  }];
	[_alertView show];
}

- (void)alertViewDidTapCancelButton:(MTZAlertView *)alertView
{
	NSLog(@"Alert View (%@) tapped Cancel Button", alertView);
}

- (void)tappedOtherAlertButton:(id)sender
{
	NSLog(@"Tapped Other Alert Button: %@", sender);
//	[(MTZAlertView *)sender textInInputField];
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
