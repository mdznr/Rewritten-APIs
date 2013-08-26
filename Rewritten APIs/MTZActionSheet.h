//
//  MTZActionSheet.h
//  Rewritten APIs
//
//  Created by Matt on 8/23/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MTZActionSheetDelegate;

#pragma mark -

NS_CLASS_AVAILABLE_IOS(2_0) @interface MTZActionSheet : NSObject

#pragma mark Creating Action Sheets

- (id)init;
- (id)initWithTitle:(NSString *)title;


#pragma mark Properties

@property (strong, nonatomic) id<MTZActionSheetDelegate> delegate;

@property (nonatomic) UIActionSheetStyle actionSheetStyle;  // Default is UIActionSheetStyleAutomatic. Ignored if alert is visible

@property (strong, nonatomic) NSString *title;

#warning should setting visibility show and hide the action sheet? This behaviour works for UIWindow
@property (nonatomic, readonly, getter=isVisible) BOOL visible;

// Get an ordered array of the button titles
// Includes cancelButtonTitle and destructiveButtonTitle, if set
- (NSArray *)buttonTitles;

// Get an ordered array of the button titles
// Does not include cancelButtonTitle and destructiveButtonTitle
- (NSArray *)otherButtonTitles;

#warning do we even need this API?
// Returns the number of buttons
// Includes the cancel and destructive buttons, if set
- (NSUInteger)numberOfButtons;

#warning do we even need this API?
// Returns the number of buttons
// Does not include cancel and destructive buttons
- (NSUInteger)numberOfOtherButtons;


#pragma mark Configuring Buttons

// The title of the cancel button (stylized and positioned automatically)
// If nil, the cancel button is not shown.
@property (strong, nonatomic) NSString *cancelButtonTitle;

// The title of the destructive button (stylized and positioned automatically)
// If nil, the destructive button is not shown.
@property (strong, nonatomic) NSString *destructiveButtonTitle;

// This will append a button to the action sheet and call the corresponding selector on the delegate when tapped
- (void)addButtonWithTitle:(NSString *)title andSelector:(SEL)selector;


#pragma mark Presenting the Action Sheet

// show a sheet animated. you can specify either a toolbar, a tab bar, a bar butto item or a plain view. We do a special animation if the sheet rises from
// a toolbar, tab bar or bar button item and we will automatically select the correct style based on the bar style. if not from a bar, we use
// UIActionSheetStyleDefault if automatic style set
- (void)showFromTabBar:(UITabBar *)view;
- (void)showFromToolbar:(UIToolbar *)view;
- (void)showInView:(UIView *)view;
- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated;
- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated;


#pragma mark Dismissing the Action Sheet

// Hides the alert and behaves like tapping the cancel button
- (void)dismissWithCancel;

// Hides the action sheet. Use this method when you need to explicitly dismiss the action sheet.
- (void)dismissWithTappedButtonTitle:(NSString *)buttonTitle animated:(BOOL)animated;

@end


#pragma mark -

@protocol MTZActionSheetDelegate <NSObject>
@optional

#pragma mark Responding to Actions

// Called when the destructive button is tapped. The view will be automatically dismissed after this call returns
- (void)actionSheetDidTapDestructiveButton:(MTZActionSheet *)actionSheet;

// Called when the cancel button is tapped. The view will be automatically dismissed after this call returns
- (void)actionSheetDidTapCancelButton:(MTZActionSheet *)actionSheet;


#pragma mark Customizing Behavior

// Called before animation and showing view
- (void)willPresentActionSheet:(MTZActionSheet *)actionSheet;

// Called after animation
- (void)didPresentActionSheet:(MTZActionSheet *)actionSheet;


#pragma mark Canceling

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)actionSheetDidCancel:(MTZActionSheet *)actionSheet;


@end
