//
//  MTZActionSheet.m
//  Rewritten APIs
//
//  Created by Matt on 8/23/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZActionSheet.h"
#import "MTZAction.h"
#import "UIActionSheet+DelegateFix.h"

@interface MTZActionSheet () <UIActionSheetDelegate>

@property (strong, nonatomic) UIActionSheet *actionSheet;

@property (strong, nonatomic) NSMutableArray *buttonTitles;
@property (strong, nonatomic) NSMutableDictionary *selectorsForTitles;

@end


@implementation MTZActionSheet

#pragma mark Creating Action Sheets

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
#warning what happens when _destructiveButtonTitle or _cancelButton title are nil?
	NSMutableArray *titles = [NSMutableArray arrayWithArray:_buttonTitles];
	[titles insertObject:_destructiveButtonTitle atIndex:0];
	[titles addObject:_cancelButtonTitle];
	return titles;
}

- (NSArray *)otherButtonTitles
{
	return _buttonTitles;
}

#warning do we even need this?
- (NSUInteger)numberOfButtons
{
	NSUInteger count = _buttonTitles.count;
	if ( _destructiveButtonTitle ) count++;
	if ( _cancelButtonTitle ) count++;
	return count;
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


#pragma mark Presenting the Action Sheet

- (UIActionSheet *)actionSheet
{
	if ( _actionSheet ) return _actionSheet;
	
	_actionSheet = [[UIActionSheet alloc] init];
	[_actionSheet setTitle:_title];
	[_actionSheet setRetainedDelegate:self];
	
	// Make sure destructive is always on the top
	if ( _destructiveButtonTitle ) {
		[_actionSheet addButtonWithTitle:_destructiveButtonTitle];
		[_actionSheet setDestructiveButtonIndex:0];
	}
	
	for ( NSString *buttonTitle in _buttonTitles ) {
		[_actionSheet addButtonWithTitle:buttonTitle];
	}
	
	// Make sure cancel is always on the bottom
	if ( _cancelButtonTitle ) {
		[_actionSheet addButtonWithTitle:_cancelButtonTitle];
		[_actionSheet setCancelButtonIndex:_actionSheet.numberOfButtons-1];
	}
	
	return _actionSheet;
}

- (void)showFromTabBar:(UITabBar *)view
{
	[[self actionSheet] showFromTabBar:view];
}

- (void)showFromToolbar:(UIToolbar *)view
{
	[[self actionSheet] showFromToolbar:view];
}

- (void)showInView:(UIView *)view
{
	[[self actionSheet] showInView:view];
}

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated
{
	[[self actionSheet] showFromBarButtonItem:item animated:animated];
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated
{
	[[self actionSheet] showFromRect:rect inView:view animated:animated];
}


#pragma mark Dismissing the Action Sheet

#warning animated?
- (void)dismissWithCancel
{
	if ( !_actionSheet ) {
		NSLog(@"Cannot dismiss MTZActionSheet without it being displayed");
	}
	
	NSInteger cancelButtonIndex = [_actionSheet cancelButtonIndex];
	[_actionSheet dismissWithClickedButtonIndex:cancelButtonIndex animated:YES];
}

- (void)dismissWithTappedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
	if ( !_actionSheet) {
		NSLog(@"Cannot dismiss MTZActionSheet without it being displayed");
	}
	
	[_actionSheet dismissWithClickedButtonIndex:buttonIndex animated:animated];
}

- (void)dismissWithTappedButtontTitle:(NSString *)buttonTitle animated:(BOOL)animated
{
	if ( !_actionSheet) {
		NSLog(@"Cannot dismiss MTZActionSheet without it being displayed");
	}
	
#warning get proper index
	NSInteger buttonIndex = 0;
	[_actionSheet dismissWithClickedButtonIndex:buttonIndex animated:animated];
}


#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSInteger otherButtonIndex = buttonIndex;
	if ( _destructiveButtonTitle ) {
		if ( buttonIndex == 0 ) {
			// Tapped on destructive button
			[_delegate actionSheetDidTapDestructiveButton:self];
			return;
		}
		otherButtonIndex--;
	}
	
	if ( _cancelButtonTitle && buttonIndex == self.numberOfButtons-1 ) {
		// Tapped on cancel button
		[_delegate actionSheetDidTapCancelButton:self];
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

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
	if ( [(NSObject *)_delegate respondsToSelector:@selector(willPresentActionSheet:)] ) {
		[_delegate willPresentActionSheet:self];
	}
}

- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
	if ( [(NSObject *)_delegate respondsToSelector:@selector(didPresentActionSheet:)] ) {
		[_delegate didPresentActionSheet:self];
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
#warning this should appear anytime actionSheet is dismissed (not always with button?)
	// Action sheet is no longer necessary
	_actionSheet = nil;
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
	if ( [(NSObject *)_delegate respondsToSelector:@selector(actionSheetDidCancel:)] ) {
		[_delegate actionSheetDidCancel:self];
	}
}

@end
