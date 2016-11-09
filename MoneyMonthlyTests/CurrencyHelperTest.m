//
//  CurrencyHelperTest.m
//  MoneyMonthly
//
//  Created by Rex Jason Alobba on 9/11/16.
//  Copyright © 2016 Rex Jason Alobba. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CurrencyHelper.h"

@interface CurrencyHelperTest : XCTestCase

@property (nonatomic) CurrencyHelper* currencyHelper;

@end

@implementation CurrencyHelperTest

- (void)setUp {
    [super setUp];
    self.currencyHelper = [[CurrencyHelper alloc]init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNumberWithComma {
    NSNumber* originalNum = [NSNumber numberWithInteger:1200];
    NSString* expected = @"1,200";
    XCTAssertEqualObjects(expected, [self.currencyHelper numberWithComma:originalNum]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
