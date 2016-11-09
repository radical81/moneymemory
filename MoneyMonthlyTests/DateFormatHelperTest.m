//
//  DateFormatHelperTest.m
//  MoneyMonthly
//
//  Created by Rex Jason Alobba on 9/11/16.
//  Copyright © 2016 Rex Jason Alobba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DateFormatHelper.h"

@interface DateFormatHelperTest : XCTestCase

@property(nonatomic) DateFormatHelper* dateFormatHelper;

@end

@implementation DateFormatHelperTest

- (void)setUp {
    [super setUp];
    self.dateFormatHelper = [[DateFormatHelper alloc]init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testStringFromYear_givenNovember2016 {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    double timeStamp = 1478694724.200427;
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSString* expected = @"Nov 2016";
    XCTAssertEqualObjects(expected, [self.dateFormatHelper stringFromMonthYear:date]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
