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

@end

@implementation DateFormatHelperTest {
    DateFormatHelper* dateFormatHelper;
}

- (void)setUp {
    [super setUp];
    dateFormatHelper = [[DateFormatHelper alloc]init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testStringMonthYear_givenNovember2016 {
    double timeStamp = 1478694724.200427;
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSString* expected = @"Nov 2016";
    XCTAssertEqualObjects(expected, [dateFormatHelper stringMonthYear:date]);
}

- (void)testDateFromDayMonthYear_given1November2016 {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d MMM yyyy"];
    NSDate* expected = [dateFormatter dateFromString:@"1 NOV 2016"];
    [dateFormatter release];
    XCTAssertEqualWithAccuracy([expected timeIntervalSinceReferenceDate], [[dateFormatHelper dateFromDayMonthYear:@"1 NOV 2016"] timeIntervalSinceReferenceDate], 0.001);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
