//
//  CalendarViewController.m
//  UIScrollViewCycleTest
//
//  Created by SMC-MAC on 16/8/30.
//  Copyright © 2016年 heyou. All rights reserved.
//

#import "CalendarViewController.h"
#import "SMCCalendarView.h"
#import "HYCalendarHeader.h"
#import "NSDate+String.h"

@interface CalendarViewController () <UIScrollViewDelegate, SMCCalendarDelegate> {
}

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat width = self.view.frame.size.width;
    CGFloat dayWidth = width / 7.0f;
    CGFloat height = dayWidth * 6;
    height = ceilf(height);
    SMCCalendarView* cv = [[SMCCalendarView alloc] initWithFrame:CGRectMake(0, 64 + 30, width, height)];
    cv.delegate = self;
    [self.view addSubview:cv];
    
    HYCalendarHeader* calendarHeader = [[HYCalendarHeader alloc] initWithFrame:CGRectMake(0, 64, width, 30)];
    //    [self.view addSubview:calendarHeader];
    [self.view addSubview:calendarHeader];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSLog(@"%s", __FUNCTION__);
}

- (void)didCalendarPageChange:(NSDate*)date {
    self.title = [date hy_stringYearMonth];
}

@end
