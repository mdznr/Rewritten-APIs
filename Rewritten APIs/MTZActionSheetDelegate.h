//
//  MTZActionSheetDelegate.h
//  Rewritten APIs
//
//  Created by Matt on 8/25/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTZActionSheet.h"

@class MTZActionSheet;

@protocol MTZActionSheetDelegate

#pragma mark Responding to Actions
- (void)actionSheetDidTapDestructiveButton:(MTZActionSheet *)actionSheet;
- (void)actionSheetDidTapCancelButton:(MTZActionSheet *)actionSheet;

#pragma mark Customizing Behavior
- (void)willPresentActionSheet:(MTZActionSheet *)actionSheet;
- (void)didPresentActionSheet:(MTZActionSheet *)actionSheet;

#pragma mark Canceling
- (void)actionSheetDidCancel:(MTZActionSheet *)actionSheet;

@end