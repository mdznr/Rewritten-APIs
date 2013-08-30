//
//  MTZAlertView.m
//  Rewritten APIs
//
//  Created by Matt on 8/25/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZAlertView.h"
#import "MTZAction.h"
#import "UIAlertView+DelegateFix.h"

@protocol UIAlertViewDelegate;

@interface MTZAlertView () <UIAlertViewDelegate>

@property (strong, nonatomic) UIAlertView *alertView;

@property (strong, nonatomic) NSMutableArray *buttonTitles;
@property (strong, nonatomic) NSMutableDictionary *actionsForButtonTitles;

@property (nonatomic) BOOL cancelButtonOnBottom;

@end

@implementation MTZAlertView

#pragma mark Creating Alert Views

- (id)init
{
	self = [super init];
	if ( self ) {
		[self setup];
	}
	return self;
}

- (id)initWithTitle:(NSString *)title
{
	self = [super init];
	if ( self ) {
		_title = title;
		[self setup];
	}
	return self;
}

- (void)setup
{
	_buttonTitles = [[NSMutableArray alloc] initWithCapacity:4];
	_actionsForButtonTitles = [[NSMutableDictionary alloc] initWithCapacity:4];
}


#pragma mark Properties

- (NSInteger)cancelButtonIndex
{
	return _alertView.cancelButtonIndex;
}

- (NSArray *)buttonTitles
{
	NSMutableArray *titles = [NSMutableArray arrayWithArray:_buttonTitles];
	if ( _cancelButtonTitle ) {
		[titles addObject:_cancelButtonTitle];
	}
	return titles;
}

- (NSArray *)otherButtonTitles
{
	return _buttonTitles;
}

- (NSUInteger)numberOfButtons
{
	NSUInteger count = _buttonTitles.count;
	if ( _cancelButtonTitle ) count++;
	return count;
}

- (NSUInteger)numberOfOtherButtons
{
	return _buttonTitles.count;
}

- (BOOL)isVisible
{
	return [_alertView isVisible];
}

#warning need to handle different styles and number of input fields
- (NSString *)textInInputField
{
	return [[(UIAlertView *)self textFieldAtIndex:0] text];
}


#pragma mark Configuring Buttons

- (void)addButtonWithTitle:(NSString *)title andSelector:(SEL)selector
{
	if ( title == nil ) {
		NSLog(@"Button title must be non-nil");
		return;
	}
	
	// If the title already exists, change it's position and update it's selector
	if ( [_actionsForButtonTitles objectForKey:title] ) {
		[_buttonTitles removeObjectIdenticalTo:title];
	}
	
	[_buttonTitles addObject:title];
	[_actionsForButtonTitles setObject:[MTZAction actionWithSelector:selector
															onObject:_delegate]
								forKey:title];
}
#warning combine the shared code in these methods
- (void)addButtonWithTitle:(NSString *)title andBlock:(Block)block
{
	if ( title == nil ) {
		NSLog(@"Button title must be non-nil");
		return;
	}
	
	// If the title already exists, change it's position and upate it's block
	if ( [_actionsForButtonTitles objectForKey:title] ) {
		[_buttonTitles removeObjectIdenticalTo:title];
	}
	
	[_buttonTitles addObject:title];
	[_actionsForButtonTitles setObject:[MTZAction actionWithBlock:block]
								forKey:title];
}


#pragma mark Presenting the Alert View

- (UIAlertView *)alertView
{
	if ( _alertView ) return _alertView;
	
	_alertView = [[UIAlertView alloc] init];
	_alertView.title = _title;
	_alertView.message = _message;
	_alertView.alertViewStyle = _style;
	_alertView.retainedDelegate = self;
	
	if ( _buttonTitles.count > 1 ) {
		_cancelButtonOnBottom = YES;
		// Add all the other buttons
		for ( NSString *buttonTitle in _buttonTitles ) {
			[_alertView addButtonWithTitle:buttonTitle];
		}
		// Make sure Cancel is on the bottom when more than two buttons
		if ( _cancelButtonTitle ) {
			[_alertView addButtonWithTitle:_cancelButtonTitle];
			_alertView.cancelButtonIndex = _alertView.numberOfButtons-1;
		}
	} else {
		_cancelButtonOnBottom = NO;
		// Make sure Cancel is on the left when only two buttons
		if ( _cancelButtonTitle ) {
			[_alertView addButtonWithTitle:_cancelButtonTitle];
			_alertView.cancelButtonIndex = 0;
		}
		// Add the other button
		[_alertView addButtonWithTitle:_buttonTitles[0]];
	}
	
	return _alertView;
}

- (void)show
{
	[[self alertView] show];
}


#pragma mark Dismissing the Alert View

- (void)dismissWithCancelAnimated:(BOOL)animated
{
	if ( !_alertView ) {
		NSLog(@"Cannot dismiss MTZAlertView without it being displayed");
		return;
	}
	
	NSInteger cancelButtonIndex = self.cancelButtonIndex;
	if ( cancelButtonIndex == -1 ) {
#warning would be nice if UIAlertView did have a API for cancelling
		NSLog(@"Cannot cancel this alert view because it doesn't have a cancel button");
		return;
	}
	[_alertView dismissWithClickedButtonIndex:cancelButtonIndex animated:animated];
}

- (void)dismissWithTappedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
	if ( !_alertView) {
		NSLog(@"Cannot dismiss MTZAlertView without it being displayed");
	}
	[_alertView dismissWithClickedButtonIndex:buttonIndex animated:animated];
}

- (void)dismissWithTappedButtonTitle:(NSString *)buttonTitle animated:(BOOL)animated
{
	if ( !_alertView) {
		NSLog(@"Cannot dismiss MTZAlertView without it being displayed");
		return;
	}
	
	NSInteger buttonIndex = 0;
	if ( [buttonTitle isEqualToString:_cancelButtonTitle] ) {
		buttonIndex = [_alertView cancelButtonIndex];
	} else {
		buttonIndex = [self.otherButtonTitles indexOfObjectIdenticalTo:buttonTitle];
		if ( buttonIndex == NSNotFound ) {
			NSLog(@"No button with that title found.");
			return;
		}
	}
	
	[_alertView dismissWithClickedButtonIndex:buttonIndex animated:animated];
}


#pragma mark UIAlertViewDelegate

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
	NSLog(@"alertViewShouldEnableFirstOtherButton:");
#warning should be more like this? (Called for each (non-cancel?) button
//- (BOOL)alertView:(MTZAlertView *)alertView shouldEnableButtonWithTitle:(NSString *)buttonTitle;
	for ( NSString *buttonTitle in _buttonTitles ) {
		return [_delegate alertView:(MTZAlertView *)alertView shouldEnableButtonWithTitle:buttonTitle];
	}
	
	return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[self performActionForButtonAtIndex:buttonIndex];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	// Alert view is no longer necessary
	_alertView = nil;
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
	if ( [(NSObject *)_delegate respondsToSelector:@selector(alertViewDidCancel:)] ) {
		[_delegate alertViewDidCancel:self];
	}
	
	// Alert view is no longer necessary
	_alertView = nil;
}

- (void)performActionForButtonAtIndex:(NSInteger)buttonIndex
{
	NSInteger otherButtonIndex = buttonIndex;
	if ( _cancelButtonTitle ) {
		if ( buttonIndex == self.cancelButtonIndex ) {
			// Tapped on cancel button
			[_delegate alertViewDidTapCancelButton:self];
			return;
		}
		if ( !_cancelButtonOnBottom ) {
			otherButtonIndex--;
		}
	}
	
	NSString *buttonTitle = self.otherButtonTitles[otherButtonIndex];
	
	[(MTZAction *)_actionsForButtonTitles[buttonTitle] performAction];
}


@end
