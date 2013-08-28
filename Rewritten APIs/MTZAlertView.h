//
//  MTZAlertView.h
//  Rewritten APIs
//
//  Created by Matt on 8/25/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MTZAlertViewDelegate;

#pragma mark -

NS_CLASS_AVAILABLE_IOS(2_0) @interface MTZAlertView : NSObject

#pragma mark Creating Alert Views

#warning TODO: what kinds of quick initalization methods should be presented?
- (id)initWithTitle:(NSString *)title;
- (id)initWithTitle:(NSString *)title andMessage:(NSString *)message;
+ (id)alertViewWithStyle:(UIAlertViewStyle)style;


#pragma mark Properties

@property (strong, nonatomic) id<MTZAlertViewDelegate> delegate;

@property (nonatomic) UIAlertViewStyle style;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *message;

#warning should setting visibility show and hide the alert? This behaviour works for UIWindow
@property (nonatomic, readonly, getter=isVisible) BOOL visible;

// Get an ordered array of the button titles
// Includes cancelButtonTitle, if set
- (NSArray *)buttonTitles;

// Get an ordered array of the button titles
// Does not include cancelButtonTitle
- (NSArray *)otherButtonTitles;

#warning do we even need this API?
// Returns the number of buttons
// Includes the cancel button, if set
- (NSUInteger)numberOfButtons;

#warning do we even need this API?
// Returns the number of buttons
// Does not include cancel button, if set
- (NSUInteger)numberOfOtherButtons;


#pragma mark Configuring Buttons

// The title of the cancel button (stylized and positioned automatically)
// If nil, the button is not shown.
@property (strong, nonatomic) NSString *cancelButtonTitle;

// This will append a button to the alert and call the corresponding selector on the delegate when tapped
- (void)addButtonWithTitle:(NSString *)title andSelector:(SEL)selector;


#pragma mark Presenting the Alert View

// Shows the popup alert animated
- (void)show;


#pragma mark Dismissing the Alert View

// Hides the alert and behaves like tapping the cancel button
- (void)dismissWithCancelAnimated:(BOOL)animated;

// Hides the alert. Use this method when you need to explicitly dismiss the alert.
- (void)dismissWithTappedButtonTitle:(NSString *)buttonTitle animated:(BOOL)animated;


@end


#pragma mark -

@protocol MTZAlertViewDelegate <NSObject>
@optional

#pragma mark Responding to Actions

// Called when the cancel button is tapped. The alert will be automatically dismissed after this call returns
- (void)alertViewDidTapCancelButton:(MTZAlertView *)alertView;


#pragma mark Customizing Behavior

// Called before animation and showing alert
- (void)willPresentAlertView:(MTZAlertView *)alertView;

// Called after animation
- (void)didPresentAlertView:(MTZAlertView *)alertView;

#warning rework the way this works
// Called after edits in any of the default fields added by the style
//- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView;
#warning should be more like this? (Called for each (non-cancel?) button
- (BOOL)alertView:(MTZAlertView *)alertView shouldEnableButtonWithTitle:(NSString *)buttonTitle;


#pragma mark Canceling

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)alertViewDidCancel:(MTZAlertView *)alertView;


@end
