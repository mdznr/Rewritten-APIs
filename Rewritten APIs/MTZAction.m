//
//  MTZAction.m
//  Rewritten APIs
//
//  Created by Matt on 8/23/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZAction.h"

@interface MTZAction ()

@property (strong, nonatomic) id object;
@property (nonatomic) SEL selector;

@property (strong, nonatomic) Block block;

@end

@implementation MTZAction

+ (MTZAction *)actionWithSelector:(SEL)selector onObject:(id)object
{
	MTZAction *action = [[MTZAction alloc] init];
	[action setSelector:selector];
	[action setObject:object];
	return action;
}

+ (MTZAction *)actionWithBlock:(Block)block
{
	MTZAction *action = [[MTZAction alloc] init];
	[action setBlock:block];
	return action;
}

- (void)performAction
{
	
	if ( _object && _selector ) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		if ( [(NSObject *)_object respondsToSelector:_selector] ) {
			[(NSObject *)_object performSelector:_selector withObject:self];
		}
#pragma clang diagnostic pop
	}
	
	if ( _block ) {
		_block(self);
	}
}

@end
