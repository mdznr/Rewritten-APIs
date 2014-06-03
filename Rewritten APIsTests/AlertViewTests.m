//
//  AlertViewTests.m
//  Rewritten APIs Tests
//
//  Created by Matt on 8/23/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MTZAlertView.h"

@interface AlertViewTests : XCTestCase

// Test properties of alert view
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *message;
@property (nonatomic) UIAlertViewStyle style;

@end

@implementation AlertViewTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
	
	_title = @"My Title";
	_message = @"My Message";
	_style = UIAlertViewStyleDefault;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAlertInit
{
	MTZAlertView *av = [[MTZAlertView alloc] init];
	
	av.title = _title;
	av.message = _message;
	av.style = _style;
	
	[av show];
	
	XCTAssertEqualObjects(av.title, _title, @"Titles do no match");
	XCTAssertEqualObjects(av.message, _message, @"Messages do not match");
	XCTAssertEqual(av.style, _style, @"Styles do not match");
}

- (void)testAlertInitWithTitle
{
	MTZAlertView *av = [[MTZAlertView alloc] initWithTitle:_title];
	
	av.message = _message;
	av.style = _style;
	
	[av show];
	
	XCTAssertEqualObjects(av.title, _title, @"Titles do not match");
	XCTAssertEqualObjects(av.message, _message, @"Messages do not match");
	XCTAssertEqual(av.style, _style, @"Styles do not match");
}

- (void)testAlertInitWithTitleAndMessage
{
	MTZAlertView *av = [[MTZAlertView alloc] initWithTitle:_title
												andMessage:_message];
	
	av.style = _style;
	
	[av show];
	
	XCTAssertEqualObjects(av.title, _title, @"Titles do not match");
	XCTAssertEqualObjects(av.message, _message, @"Messages do not match");
	XCTAssertEqual(av.style, _style, @"Styles do not match");
}

@end
