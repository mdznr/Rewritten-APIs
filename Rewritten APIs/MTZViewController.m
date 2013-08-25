//
//  MTZViewController.m
//  Rewritten APIs
//
//  Created by Matt on 8/23/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZViewController.h"
#import "MTZActionSheet.h"

@interface MTZViewController () <MTZActionSheetDelegate>

@end

@implementation MTZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	UIButton *actionSheetButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 300, 44)];
	[actionSheetButton setBackgroundColor:[UIColor blueColor]];
	[actionSheetButton setShowsTouchWhenHighlighted:YES];
	[actionSheetButton setTitle:@"Show Action Sheet" forState:UIControlStateNormal];
	[actionSheetButton addTarget:self
						  action:@selector(didTapActionSheetButton:)
				forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:actionSheetButton];
	
	UIButton *alertButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 64, 300, 44)];
	[alertButton setBackgroundColor:[UIColor blueColor]];
	[alertButton setShowsTouchWhenHighlighted:YES];
	[alertButton setTitle:@"Show Alert" forState:UIControlStateNormal];
	[alertButton addTarget:self
					action:@selector(didTapAlertButton:)
		  forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:alertButton];
}


- (void)didTapActionSheetButton:(id)sender
{
	MTZActionSheet *as = [[MTZActionSheet alloc] initWithTitle:@"MY TITLE"];
	[as setDelegate:self];
	[as addButtonWithTitle:@"My Title" andSelector:@selector(tappedMyTitle:)];
	as.cancelButtonTitle = @"CANCELAR";
	as.destructiveButtonTitle = @"DESTRUCTIVe";
	[as showInView:self.view];
}

- (void)actionSheetDidTapDestructiveButton:(MTZActionSheet *)actionSheet
{
	NSLog(@"DESTRUCTIVE");
}

- (void)actionSheetDidTapCancelButton:(MTZActionSheet *)actionSheet
{
	NSLog(@"CANCEL");
}

- (void)tappedMyTitle:(id)sender
{
	NSLog(@"TAPPED MYTITLE");
}


- (void)didTapAlertButton:(id)sender
{
	NSLog(@"Did tap alert");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
