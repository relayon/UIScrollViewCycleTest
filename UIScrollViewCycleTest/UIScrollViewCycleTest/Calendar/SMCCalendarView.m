//
//  SMCCalendarView.m
//  UIScrollViewCycleTest
//
//  Created by SMC-MAC on 16/8/30.
//  Copyright © 2016年 heyou. All rights reserved.
//

#import "SMCCalendarView.h"
#import "SMCMonthView.h"
#import "UIScrollView+SMCScroll.h"
#import "DateManager.h"

typedef NS_ENUM(NSInteger, CalendarMode) {
    CalendarMode_Month, // 月模式 - 默认
    CalendarMode_Week,  // 周模式
};

@interface SMCCalendarView () <UIScrollViewDelegate, UIGestureRecognizerDelegate> {
    NSInteger _maxCount;
    NSInteger _currentIndex;
    CGFloat _monthHeight;
    CGFloat _weekHeight;
    
    CalendarMode _calendarMode;
    
    SMCMonthView* _left;
    SMCMonthView* _middle;
    SMCMonthView* _right;
    
    NSDate* _nowDate;
    NSDate* _selectDate;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation SMCCalendarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        NSString* nibName = NSStringFromClass([SMCCalendarView class]);
//        self = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] firstObject];
//        self.autoresizingMask = UIViewAutoresizingNone;
//        self.frame = frame;
        
        self.layer.masksToBounds = YES;
        
        UIScrollView* sv = [UIScrollView new];
        sv.showsHorizontalScrollIndicator = NO;
        sv.backgroundColor = [UIColor blackColor];
//        sv.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        sv.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:sv];
        self.scrollView = sv;
        
        _maxCount = 10;
        _currentIndex = 0;
        _monthHeight = frame.size.height;
        _weekHeight = frame.size.width/7.0;
        _calendarMode = CalendarMode_Month;
        
        _nowDate = [NSDate date];
        _selectDate = _nowDate;
        
//        CGRect tFrame = self.bounds;
//        self.scrollView.frame = tFrame;
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        [self.scrollView smc_disableTouchDelay];
        
        [self _initMonthViews];
        
        self.backgroundColor = [UIColor purpleColor];
        [self _addGesture];
        
        [self _reloadData];
    }
    return self;
}

- (void)_changeMonthViewHeight:(CGFloat)height {
//    CGRect tFrame = _middle.frame;
//    tFrame.size.height = height;
//    _middle.frame = tFrame;
    
    [_middle rawChangeHeight:height];
}

#if 0
- (void)layoutSubviews {
    [super layoutSubviews];
    [self _changeMonthViewHeight:self.frame.size.height];
    self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    NSLog(@"****   self = %@", NSStringFromCGRect(self.frame));
//    NSLog(@"*scrollview = %@", NSStringFromCGRect(self.scrollView.frame));
}
#endif

- (void)_addGesture {
    // 添加手势
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    //    panGesture.delegate = self;
    [self addGestureRecognizer:panGesture];
}

- (void)_initMonthViews {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    // left
    _left = [[SMCMonthView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    _left.backgroundColor = [UIColor blueColor];
    [_left initWeeks];
    [self.scrollView addSubview:_left];
    // middle
    _middle = [[SMCMonthView alloc] initWithFrame:CGRectMake(width, 0, width, height)];
    _middle.backgroundColor = [UIColor blueColor];
    [_middle initWeeks];
    [self.scrollView addSubview:_middle];
    // right
    _right = [[SMCMonthView alloc] initWithFrame:CGRectMake(width*2.0, 0, width, height)];
    _right.backgroundColor = [UIColor blueColor];
    [_right initWeeks];
    [self.scrollView addSubview:_right];
    
    CGSize sz = self.scrollView.contentSize;
    sz.width = width*3.0f;
    [self.scrollView setContentSize:sz];
    [self.scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
}

- (void)_changeCalendarFrame:(CGFloat)delta {
    
}

#pragma mark -- handlePanGesture
- (void)handlePanGesture:(UIPanGestureRecognizer*)panGesture {
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan: {
            [self panDidBegan:panGesture];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self panDidChange:panGesture];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self panDidEnd:panGesture];
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            [self panDidEnd:panGesture];
            break;
        }
        case UIGestureRecognizerStateFailed: {
            [self panDidEnd:panGesture];
            break;
        }
        default: {
            break;
        }
    }
}

- (void)panDidBegan:(UIPanGestureRecognizer*)panGesture {
    NSLog(@"%s", __FUNCTION__);
}

- (void)panDidChange:(UIPanGestureRecognizer*)panGesture {
    NSLog(@"%s", __FUNCTION__);
    CGFloat translation = [panGesture translationInView:panGesture.view].y;
    CGFloat velocity = [panGesture velocityInView:panGesture.view].y;
    // 向上拖动，translation是负数，向下是正数
    // velocity 是负数，方向向上，正数，方向向下
    NSLog(@"{%f, %f}", translation, velocity);
    
    
    if (_calendarMode == CalendarMode_Month) {
        CGFloat delta = -translation;
        delta = MAX(delta, 0.0f); // 最小
        delta = MIN(delta, _monthHeight - _weekHeight);   // 最大
        CGFloat tHeight = _monthHeight - delta;
        CGRect tFrame = self.frame;
        tFrame.size.height = tHeight;
        self.frame = tFrame;
    } else {
        CGFloat delta = translation;
        delta = MAX(delta, 0.0f); // 最小
        delta = MIN(delta, _monthHeight - _weekHeight);   // 最大
        CGFloat tHeight = _weekHeight + delta;
        CGRect tFrame = self.frame;
        tFrame.size.height = tHeight;
        self.frame = tFrame;
    }
    
    [self _changeMonthViewHeight:self.frame.size.height];
    
//    CGFloat delta = -translation;
//    delta = MAX(delta, 0.0f);   // 最小
//    delta = MIN(delta, self.mMonthCalendarHeight - self.mWeekCalendarHeight);   // 最大
//    CGRect tFrame = self.collectionView.frame;
//    tFrame.origin.y = _originY - delta;
//    self.collectionView.frame = tFrame;
//    
//    // change container frame;
//    CGRect containerFrame = self.mCalendarContainer.frame;
//    containerFrame.size.height = self.mContainerHeight - delta;
//    self.mCalendarContainer.frame = containerFrame;
//    
//    // set tableview content offset
//    CGPoint offset = self.tableView.contentOffset;
//    offset.y = -self.mMonthCalendarHeight + delta;
//    self.tableView.contentOffset = offset;
}

- (void)panDidEnd:(UIPanGestureRecognizer*)panGesture {
    NSLog(@"%s", __FUNCTION__);
    CGFloat translation = [panGesture translationInView:panGesture.view].y;
    CGFloat velocity = [panGesture velocityInView:panGesture.view].y;
    // 向上拖动，translation是负数，向下是正数
    // velocity 是负数，方向向上，正数，方向向下
    NSLog(@"{%f, %f}", translation, velocity);
    if (velocity > 0) {
        // change to month mode
        CGRect tFrame = self.frame;
        tFrame.size.height = _monthHeight;
        _calendarMode = CalendarMode_Month;
        
        self.frame = tFrame;
        [_middle changeHeight:_monthHeight complete:^(BOOL finished) {
            
        }];
        
//        [UIView animateWithDuration:3.0f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            self.frame = tFrame;
//            [_middle changeHeight:_monthHeight];
//        } completion:^(BOOL finished) {
//        }];
    } else {
        // change to week mode
        CGRect tFrame = self.frame;
        tFrame.size.height = _weekHeight;
        _calendarMode = CalendarMode_Week;
        
        [_middle changeHeight:_weekHeight complete:^(BOOL finished) {
            self.frame = tFrame;
        }];
//        [UIView animateWithDuration:3.0f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
//            [_middle changeHeight:_weekHeight];
//        } completion:^(BOOL finished) {
//            self.frame = tFrame;
//        }];
    }
}

#pragma mark -- layoutViews
- (void)_layoutViews {
    //    CGFloat width = self.scrollView.frame.size.width;
}

#pragma mark -- UIScrollViewDelegate
- (void)_reloadData {
//    NSInteger leftIndex = (_currentIndex - 1 + _maxCount)%_maxCount;
//    NSInteger rightIndex = (_currentIndex + 1)%_maxCount;
//    _left.labelTitle.text = [NSString stringWithFormat:@"%ld", leftIndex];
//    _middle.labelTitle.text = [NSString stringWithFormat:@"%ld", _currentIndex];
//    _right.labelTitle.text = [NSString stringWithFormat:@"%ld", rightIndex];
    NSInteger leftIndex = _currentIndex - 1;
    NSInteger middleIndex = _currentIndex;
    NSInteger rightIndex = _currentIndex + 1;
    NSDate* leftDate = [[DateManager sharedInstance] dateWithDate:_nowDate monthOffset:leftIndex];
    [_left reloadDate:leftDate];
    NSDate* middleDate = [[DateManager sharedInstance] dateWithDate:_nowDate monthOffset:middleIndex];
    [_middle reloadDate:middleDate];
    NSDate* rightDate = [[DateManager sharedInstance] dateWithDate:_nowDate monthOffset:rightIndex];
    [_right reloadDate:rightDate];
    
    if (self.delegate) {
        [self.delegate didCalendarPageChange:middleDate];
    }
}

#pragma mark -- UIScrollViewDelegate
// UIScrollView 停止滚动时回调
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat width = scrollView.frame.size.width;
    CGFloat ofx = self.scrollView.contentOffset.x;
    if (ofx > width) {
//        _currentIndex = (_currentIndex + 1) % _maxCount;
        _currentIndex++;
        [self _reloadData];
    } else if (ofx < width) {
//        _currentIndex = (_currentIndex - 1 + _maxCount) % _maxCount;
        _currentIndex--;
        [self _reloadData];
    }
    [self.scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
}

@end
