//
//  MTZAction.h
//  Rewritten APIs
//
//  Created by Matt on 8/23/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Block)();

@interface MTZAction : NSObject

+ (MTZAction *)actionWithSelector:(SEL)selector;
+ (MTZAction *)actionWithBlock:(Block)block;

@end
