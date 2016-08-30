//
//  UIScrollViewCycleTestTests.m
//  UIScrollViewCycleTestTests
//
//  Created by SMC-MAC on 16/8/29.
//  Copyright © 2016年 heyou. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DateManager.h"
#import "NSDate+String.h"

@interface UIScrollViewCycleTestTests : XCTestCase

@end

@implementation UIScrollViewCycleTestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSDate* dt = [NSDate date];
    dt = [[DateManager sharedInstance] firstDayOfMonth:dt];
    dt = [[DateManager sharedInstance] firstDayOfWeek:dt];
    NSLog(@"tDate====== = %@", [dt hy_stringDefault]);
    for (int i = 0; i < 6; i++) {
        NSDate* tDate = [[DateManager sharedInstance] dateWithDate:dt weekOffset:i];
        NSLog(@"tDate = %@", [tDate hy_stringDefault]);
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
