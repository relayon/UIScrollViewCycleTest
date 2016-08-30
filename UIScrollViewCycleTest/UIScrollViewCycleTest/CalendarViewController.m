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

@interface CalendarViewController () <UITableViewDataSource, UITableViewDelegate, SMCCalendarDelegate> {
    CGFloat _calendarHeight;
    CGFloat _weekHeight;
    CGFloat _insetTop;
    SMCCalendarView* _calendarView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat width = self.view.frame.size.width;
    CGFloat dayWidth = width / 7.0f;
    CGFloat height = dayWidth * 6;
    height = ceilf(height);
    _calendarHeight = height;
    _weekHeight = dayWidth;
    SMCCalendarView* cv = [[SMCCalendarView alloc] initWithFrame:CGRectMake(0, 64 + 30, width, height)];
    cv.delegate = self;
    [self.view addSubview:cv];
    _calendarView = cv;
    
    HYCalendarHeader* calendarHeader = [[HYCalendarHeader alloc] initWithFrame:CGRectMake(0, 64, width, 30)];
    //    [self.view addSubview:calendarHeader];
    [self.view addSubview:calendarHeader];
    
    
    //
    UIEdgeInsets insets = self.tableView.contentInset;
    _insetTop = _calendarHeight + 30;
    insets.top = _insetTop;
    self.tableView.contentInset = insets;
    self.tableView.backgroundColor = [UIColor darkGrayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - UITableviewDataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"tCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tCell"];
        cell.backgroundColor = [UIColor lightGrayColor];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat ofy = scrollView.contentOffset.y;
    CGFloat delta = -(_insetTop + ofy);
    NSLog(@"ofy = %f, delta = %f", ofy, delta);
    [_calendarView changeCalendarHeight:delta];
    
    
#if 0
        CGFloat ofy = scrollView.contentOffset.y;
    
//        CGFloat delta = _calendarHeight + ofy;
//    
//        delta = MAX(delta, 0.0f);   // 最小
//        delta = MIN(delta, _calendarHeight - _weekHeight);   // 最大
#endif
    
}

#pragma mark -- SMCCalendarDelegate
- (void)didCalendarPageChange:(NSDate*)date {
    self.title = [date hy_stringYearMonth];
}

- (void)didCalendarHeightChange:(CGFloat)height {
    CGFloat minOfy = -(height + 30);
    NSLog(@"minOfy = %f", minOfy);
//    CGFloat ofy = self.tableView.contentOffset.y;
    CGPoint offset = self.tableView.contentOffset;
    offset.y = minOfy;
    id scrollDelegate = self.tableView.delegate;
    self.tableView.delegate = nil;
    [self.tableView setContentOffset:offset animated:NO];
    self.tableView.delegate = scrollDelegate;
    
}

@end
