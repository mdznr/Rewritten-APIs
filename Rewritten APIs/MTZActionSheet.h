//
//  MTZActionSheet.h
//  Rewritten APIs
//
//  Created by Matt on 8/23/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTZActionSheetDelegate.h"

@interface MTZActionSheet : UIView

#pragma mark Creating Action Sheets

- (id)init;
- (id)initWithTitle:(NSString *)title;


#pragma mark Properties

@property (strong, nonatomic) id<MTZActionSheetDelegate> delegate;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *cancelButtonTitle;
@property (strong, nonatomic) NSString *destructiveButtonTitle;

@property (nonatomic) UIActionSheetStyle actionSheetStyle;

// Get an ordered array of the button titles
// Includes cancelButtonTitle and destructiveButtonTitle, if set
- (NSArray *)buttonTitles;

// Get an ordered array of the button titles
// Does not include cancelButtonTitle and destructiveButtonTitle
- (NSArray *)otherButtonTitles;

// Returns the number of buttons
- (NSUInteger)numberOfButtons;


#pragma mark Configuring Buttons

- (void)addButtonWithTitle:(NSString *)title andSelector:(SEL)selector;


#pragma mark Presenting the Action Sheet

- (void)showFromTabBar:(UITabBar *)view;
- (void)showFromToolbar:(UIToolbar *)view;
- (void)showInView:(UIView *)view;
- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated;
- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated;


#pragma mark Dismissing the Action Sheet

- (void)dismissWithCancel;
- (void)dismissWithTappedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;
- (void)dismissWithTappedButtontTitle:(NSString *)buttonTitle animated:(BOOL)animated;

@end
