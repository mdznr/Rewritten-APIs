//
//  ActionSheetTests.m
//  Rewritten APIs Tests
//
//  Created by Matt on 8/23/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MTZActionSheet.h"

@interface ActionSheetTests : XCTestCase

// Standard action sheet to start with
@property (strong, nonatomic) MTZActionSheet *as;

// Test properties of action sheet
@property (strong, nonatomic) NSString *title;
@property (nonatomic) UIActionSheetStyle style;

// Views to test showing action sheet from
@property (strong, nonatomic) UITabBar *tabBar;
@property (strong, nonatomic) UIToolbar *toolbar;
@property (strong, nonatomic) UIView *view;

@end

@implementation ActionSheetTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
	
	_tabBar = [[UITabBar alloc] initWithFrame:(CGRect){0, 0, 320, 44}];
	_toolbar = [[UIToolbar alloc] initWithFrame:(CGRect){0, 0, 320, 44}];
	_view = [[UIView alloc] initWithFrame:(CGRect){0, 0, 320, 480}];
	
	[_view addSubview:_toolbar];
	[_view addSubview:_tabBar];
	
	// Adding view to valid window as required
	UIWindow *window = [[UIApplication sharedApplication] keyWindow];
	[window addSubview:_view];
	
	_title = @"My Title";
	_style = UIActionSheetStyleAutomatic;
	
	// Standard action sheet
	_as = [[MTZActionSheet alloc] init];
	_as.title = _title;
	_as.style = _style;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testActionSheetInit
{
	MTZActionSheet *as = [[MTZActionSheet alloc] init];
	
	as.title = _title;
	XCTAssertEqualObjects(as.title, _title, @"Titles do no match");
	
	as.style = _style;
	XCTAssertEqual(as.style, _style, @"Styles do not match");
}

- (void)testActionSheetInitWithTitle
{
	MTZActionSheet *as = [[MTZActionSheet alloc] initWithTitle:_title];
	
	XCTAssertEqualObjects(as.title, _title, @"Titles do no match");
}

- (void)testPresentedActionSheetTitle
{
	[_as showInView:_view];
	
	UIActionSheet *actionSheet = (UIActionSheet *) [_as valueForKey:@"actionSheet"];
	XCTAssertEqualObjects(actionSheet.title, _title, @"Titles do no match");
}

- (void)testPresentedActionSheetFromToolbar
{
	[_as showFromToolbar:_toolbar];
	
	UIActionSheet *actionSheet = (UIActionSheet *) [_as valueForKey:@"actionSheet"];
	XCTAssertEqualObjects(actionSheet.title, _title, @"Titles do no match");
}

- (void)testPresentedActionSheetFromTabBar
{
	[_as showFromTabBar:_tabBar];
	
	UIActionSheet *actionSheet = (UIActionSheet *) [_as valueForKey:@"actionSheet"];
	XCTAssertEqualObjects(actionSheet.title, _title, @"Titles do not match");
}

@end