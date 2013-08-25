//
//  MTZAction.m
//  Rewritten APIs
//
//  Created by Matt on 8/23/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZAction.h"

@implementation MTZAction

+ (MTZAction *)actionWithSelector:(SEL)selector
{
	MTZAction *action = [[MTZAction alloc] init];
	[action setSelector:selector];
	return action;
}

@end
