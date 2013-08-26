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
#warning what happens when _cancelButtonTitle is nil?
	NSMutableArray *titles = [NSMutableArray arrayWithArray:_buttonTitles];
	[titles addObject:_cancelButtonTitle];
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

@end
