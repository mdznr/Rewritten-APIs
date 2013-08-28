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
@property (strong, nonatomic) NSMutableDictionary *selectorsForTitles;

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
	_selectorsForTitles = [[NSMutableDictionary alloc] initWithCapacity:4];
}


#pragma mark Properties

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


#pragma mark Configuring Buttons

- (void)addButtonWithTitle:(NSString *)title andSelector:(SEL)selector
{
	if ( title == nil ) {
		NSLog(@"Button title cannot be nil");
		return;
	}
	
	// If the title already exists, change it's position and update it's selector
	if ( [_selectorsForTitles objectForKey:title] ) {
		[_buttonTitles removeObjectIdenticalTo:title];
	}
	
	[_buttonTitles addObject:title];
	[_selectorsForTitles setObject:[MTZAction actionWithSelector:selector]
							forKey:title];
}


#pragma mark Presenting the Alert View

- (UIAlertView *)alertView
{
	if ( _alertView ) return _alertView;
	
	_alertView = [[UIAlertView alloc] init];
	_alertView.title = _title;
	_alertView.message = _message;
	_alertView.retainedDelegate = self;
	
	for ( NSString *buttonTitle in _buttonTitles ) {
		[_alertView addButtonWithTitle:buttonTitle];
	}
	
	// Make sure cancel is always on the bottom
	if ( _cancelButtonTitle ) {
		[_alertView addButtonWithTitle:_cancelButtonTitle];
		_alertView.cancelButtonIndex = _alertView.numberOfButtons-1;
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
	
	NSInteger cancelButtonIndex = [_alertView cancelButtonIndex];
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
		buttonIndex = self.numberOfButtons-1;
	} else {
		buttonIndex = [_buttonTitles indexOfObjectIdenticalTo:buttonTitle];
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
#warning should be more like this? (Called for each (non-cancel?) button
//- (BOOL)alertView:(MTZAlertView *)alertView shouldEnableButtonWithTitle:(NSString *)buttonTitle;
	for ( NSString *buttonTitle in _buttonTitles ) {
		return [_delegate alertView:(MTZAlertView *)alertView shouldEnableButtonWithTitle:buttonTitle];
	}
	
	return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[self callSelectorOnDelegateForIndex:buttonIndex];
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

- (void)callSelectorOnDelegateForIndex:(NSInteger)buttonIndex
{
	NSInteger otherButtonIndex = buttonIndex;
	if ( _cancelButtonTitle && buttonIndex == self.numberOfButtons-1 ) {
		// Tapped on cancel button
		[_delegate alertViewDidTapCancelButton:self];
		return;
	}
	
	NSString *buttonTitle = _buttonTitles[otherButtonIndex];
	
	SEL selector = ((MTZAction *)_selectorsForTitles[buttonTitle]).selector;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
	if ( [(NSObject *)_delegate respondsToSelector:selector] ) {
		[((NSObject *)_delegate) performSelector:selector withObject:self];
	}
#pragma clang diagnostic pop
}


@end
