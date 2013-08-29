//
//  MTZAction.m
//  Rewritten APIs
//
//  Created by Matt on 8/23/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZAction.h"

@interface MTZAction ()

@property (nonatomic) SEL selector;
@property (strong, nonatomic) Block block;

@end

@implementation MTZAction

+ (MTZAction *)actionWithSelector:(SEL)selector
{
	MTZAction *action = [[MTZAction alloc] init];
	[action setSelector:selector];
	return action;
}

+ (MTZAction *)actionWithBlock:(Block)block
{
	MTZAction *action = [[MTZAction alloc] init];
	[action setBlock:block];
	return action;
}

- (void)act
{
#warning needs a delegate?
	if ( _selector ) {
		[self performSelector:_selector withObject:self];
	}
	if ( _block ) {
		_block(self);
	}
}

@end
