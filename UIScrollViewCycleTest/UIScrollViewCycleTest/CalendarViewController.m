//
//  CalendarViewController.m
//  UIScrollViewCycleTest
//
//  Created by SMC-MAC on 16/8/30.
//  Copyright © 2016年 heyou. All rights reserved.
//

#import "CalendarViewController.h"
#import "SMCCalendarView.h"

@interface CalendarViewController () <UIScrollViewDelegate> {
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
    SMCCalendarView* cv = [[SMCCalendarView alloc] initWithFrame:CGRectMake(0, 70, width, height)];
    [self.view addSubview:cv];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSLog(@"%s", __FUNCTION__);
}

@end
