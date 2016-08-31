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
    CGFloat _scrollVelocity;
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
//    self.tableView.decelerationRate = 0.0f;
    NSLog(@"self.tableView.decelerationRate = %f", self.tableView.decelerationRate);
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
    return 50;
}

- (CGFloat)_getInsetTop {
    CGFloat top = 0.0f;
    if (_calendarView.calendarMode == CalendarMode_Month) {
        top = _calendarHeight + 30;
    } else if (_calendarView.calendarMode == CalendarMode_Week) {
        top = _weekHeight + 30;
    }
    return top;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat ofy = scrollView.contentOffset.y;
    CGFloat tTop = [self _getInsetTop];
    CGFloat delta = -(tTop + ofy);
//    NSLog(@"ofy = %f, delta = %f", ofy, delta);
    [_calendarView changeCalendarHeight:delta];
    
    
#if 0
        CGFloat ofy = scrollView.contentOffset.y;
    
//        CGFloat delta = _calendarHeight + ofy;
//    
//        delta = MAX(delta, 0.0f);   // 最小
//        delta = MIN(delta, _calendarHeight - _weekHeight);   // 最大
#endif
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_calendarView changeCalendarHeightBegin];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"%s - %@", __FUNCTION__, decelerate?@"YES":@"NO");
    UIPanGestureRecognizer* panGesture = scrollView.panGestureRecognizer;
    CGFloat velocity = [panGesture velocityInView:panGesture.view].y;
    NSLog(@"scrollViewDidEndDragging - velocity = %f, decelerate = %f", velocity, scrollView.decelerationRate);
    _scrollVelocity = velocity;
    if (!decelerate) {
        [_calendarView changeCalendarHeightEnd:_scrollVelocity];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%s", __FUNCTION__);
//    [scrollView setContentOffset:scrollView.contentOffset animated:NO];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%s", __FUNCTION__);
    [_calendarView changeCalendarHeightEnd:_scrollVelocity];
}

#pragma mark -- SMCCalendarDelegate
//- (void)didCalendarPageChange:(NSDate*)date {
//    self.title = [date hy_stringYearMonth];
//}
//
//- (void)didCalendarHeightChange:(CGFloat)height {
//    CGFloat minOfy = -(height + 30);
//    NSLog(@"minOfy = %f", minOfy);
////    CGFloat ofy = self.tableView.contentOffset.y;
//    CGPoint offset = self.tableView.contentOffset;
//    offset.y = minOfy;
//    id scrollDelegate = self.tableView.delegate;
//    self.tableView.delegate = nil;
//    [self.tableView setContentOffset:offset animated:NO];
//    self.tableView.delegate = scrollDelegate;
//    
//}
- (void)calendarWillChangeHeight:(CGFloat)delta animated:(BOOL)animate {
    CGPoint contentOffset = self.tableView.contentOffset;
    contentOffset.y -= delta;
    
    if (animate) {
        [UIView animateWithDuration:1.0 animations:^{
            self.tableView.contentOffset = contentOffset;
        }];
    } else {
        self.tableView.contentOffset = contentOffset;
    }
}

- (void)calendarDidChangeMode:(CalendarMode)mode {
}

@end
