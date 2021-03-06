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

@interface SMCCalendarView () <UIScrollViewDelegate, UIGestureRecognizerDelegate> {
    NSInteger _maxCount;
    NSInteger _currentIndex;
    CGFloat _monthHeight;
    CGFloat _weekHeight;
    CGFloat _nowHeight;
    
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
        self.calendarMode = CalendarMode_Month;
        
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
//    _left.backgroundColor = [UIColor blueColor];
    [_left initWeeks];
    [self.scrollView addSubview:_left];
    // middle
    _middle = [[SMCMonthView alloc] initWithFrame:CGRectMake(width, 0, width, height)];
//    _middle.backgroundColor = [UIColor blueColor];
    [_middle initWeeks];
    [self.scrollView addSubview:_middle];
    // right
    _right = [[SMCMonthView alloc] initWithFrame:CGRectMake(width*2.0, 0, width, height)];
//    _right.backgroundColor = [UIColor blueColor];
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
    [self changeCalendarHeightBegin];
    
    if (self.delegate) {
        [self.delegate calendarChangeHeightBegin];
    }
}

- (void)panDidChange:(UIPanGestureRecognizer*)panGesture {
    NSLog(@"%s", __FUNCTION__);
//    BOOL pass = NO;
//    CGFloat velocity = [panGesture velocityInView:panGesture.view].y;
//    if (_calendarMode == CalendarMode_Month) {
//        if (velocity > 0) {
//            // 向下
//            if (_nowHeight > _weekHeight && _nowHeight < _monthHeight) {
//                pass = YES;
//            }
//        } else {
//            // 向上
//            if (_nowHeight > _weekHeight && _nowHeight < _monthHeight) {
//                pass = YES;
//            }
//        }
//    } else if (_calendarMode == CalendarMode_Week) {
//        if (velocity > 0) {
//            // 向下
//            if (_nowHeight > _weekHeight && _nowHeight < _monthHeight) {
//                pass = YES;
//            }
//        } else {
//            // 向上
//            if (_nowHeight > _weekHeight && _nowHeight < _monthHeight) {
//                pass = YES;
//            }
//        }
//    }
    
    CGFloat translation = [panGesture translationInView:panGesture.view].y;
    CGFloat delta = translation;
    [self changeCalendarHeight:delta];
    if (self.delegate) {
        [self.delegate calendarChangeHeight:delta];
    }
    
//    NSLog(@"MD:%ld, velocity = %f, _nowHeight = %f", _calendarMode, velocity, _nowHeight);
//    if (_nowHeight >= _weekHeight && _nowHeight <= _monthHeight) {
//        CGFloat translation = [panGesture translationInView:panGesture.view].y;
//        CGFloat delta = translation;
//        [self changeCalendarHeight:delta];
//        if (self.delegate) {
//            [self.delegate calendarChangeHeight:delta];
//        }
//    }
    
//    CGFloat velocity = [panGesture velocityInView:panGesture.view].y;
//    // 向上拖动，translation是负数，向下是正数
//    // velocity 是负数，方向向上，正数，方向向下
//    NSLog(@"{%f, %f}", translation, velocity);
//    
//    CGFloat delta = 0.0f;
//    if (self.calendarMode == CalendarMode_Month) {
//        delta = -translation;
//        delta = MAX(delta, 0.0f); // 最小
//        delta = MIN(delta, _monthHeight - _weekHeight);   // 最大
//        CGFloat tHeight = _monthHeight - delta;
//        CGRect tFrame = self.frame;
//        tFrame.size.height = tHeight;
//        self.frame = tFrame;
//    } else {
//        delta = translation;
//        delta = MAX(delta, 0.0f); // 最小
//        delta = MIN(delta, _monthHeight - _weekHeight);   // 最大
//        CGFloat tHeight = _weekHeight + delta;
//        CGRect tFrame = self.frame;
//        tFrame.size.height = tHeight;
//        self.frame = tFrame;
//    }
//    
//    [self _changeMonthViewHeight:self.frame.size.height];
}

- (void)panDidEnd:(UIPanGestureRecognizer*)panGesture {
    NSLog(@"%s", __FUNCTION__);
//    CGFloat translation = [panGesture translationInView:panGesture.view].y;
    CGFloat velocity = [panGesture velocityInView:panGesture.view].y;
    [self changeCalendarHeightEnd:velocity];
#if 0
    // 向上拖动，translation是负数，向下是正数
    // velocity 是负数，方向向上，正数，方向向下
    NSLog(@"{%f, %f}", translation, velocity);
    if (velocity > 0) {
        // change to month mode
        CGRect tFrame = self.frame;
        tFrame.size.height = _monthHeight;
        self.calendarMode = CalendarMode_Month;
        
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
        self.calendarMode = CalendarMode_Week;
        
        [_middle changeHeight:_weekHeight complete:^(BOOL finished) {
            self.frame = tFrame;
        }];
//        [UIView animateWithDuration:3.0f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
//            [_middle changeHeight:_weekHeight];
//        } completion:^(BOOL finished) {
//            self.frame = tFrame;
//        }];
    }
#endif
}

#pragma mark -- 外部调用，改变日历高度
- (void)changeCalendarHeightBegin {
    NSLog(@"%s", __FUNCTION__);
}

- (void)changeCalendarHeight:(CGFloat)delta {
    CGFloat currentHeight;
    if (self.calendarMode == CalendarMode_Month) {
        currentHeight = _monthHeight;
    } else {
        currentHeight = _weekHeight;
    }
    
    CGFloat tHeight = currentHeight + delta;
    [self _changeCalendarHeightTo:tHeight animated:NO];
}

- (void)changeCalendarHeightEnd:(CGFloat)velocity {
    NSLog(@"%s - velocity = %f", __FUNCTION__, velocity);
    if (self.calendarMode == CalendarMode_Month) {
        // 月模式
        if (velocity > 0) {
            // 向下
            // 当前是 月模式，并且已经向下拖动 超过了2周的高度 -》恢复到月模式
            if (_nowHeight > (_weekHeight*2)) {
                [self _changeCalendarModeTo:CalendarMode_Month];
            } else {
                // 切换到 周模式
                [self _changeCalendarModeTo:CalendarMode_Week];
            }
        } else {
            // 向上
            // 当前是 月模式，并且已经向上拖动 超过了2周的高度 -》切换到周模式
            if (_nowHeight < (_monthHeight - _weekHeight*2)) {
                [self _changeCalendarModeTo:CalendarMode_Week];
            } else {
                // 恢复到月模式
                [self _changeCalendarModeTo:CalendarMode_Month];
            }
        }
    } else if (self.calendarMode == CalendarMode_Week){
        // 周模式
        if (velocity > 0) {
            // 向下
            // 当前是 周模式，并且已经向下拖动 超过了2周的高度 -》切换到月模式
            if (_nowHeight > (_weekHeight*2)) {
                [self _changeCalendarModeTo:CalendarMode_Month];
            } else {
                // 恢复到 周模式
                [self _changeCalendarModeTo:CalendarMode_Week];
            }
        } else {
            // 向上
            // 当前是 周模式，并且向上拖动，导致当前高度小于2周的高度-》恢复到周模式
            if (_nowHeight < (_weekHeight*2)) {
                [self _changeCalendarModeTo:CalendarMode_Week];
            } else {
                // 切换到月模式
                [self _changeCalendarModeTo:CalendarMode_Month];
            }
        }
    }
}

#pragma mark -- 具体改变日历模式和高度
- (void)_changeCalendarModeTo:(CalendarMode)mode {
    CGFloat toHeight = _monthHeight;
    if (mode == CalendarMode_Month) {
        //
    } else if (mode == CalendarMode_Week) {
        toHeight = _weekHeight;
    }
    [self _changeCalendarHeightTo:toHeight animated:YES];
    _calendarMode = mode;
}

- (void)_changeCalendarHeightTo:(CGFloat)height animated:(BOOL)animate {
    if (animate) {
        CGFloat tHeight = MAX(height, _weekHeight);    // 最小不能小于 周模式高度
        tHeight = MIN(tHeight, _monthHeight);       // 最大不能大于 月模式高度
        CGRect tFrame = self.frame;
        CGFloat delta = tHeight - tFrame.size.height;
        tFrame.size.height = tHeight;
        _nowHeight = tHeight;
//        [UIView animateWithDuration:1 animations:^{
//            self.frame = tFrame;
//        }];
        [UIView animateWithDuration:1 animations:^{
            self.frame = tFrame;
        } completion:^(BOOL finished) {
            [self.delegate calendarDidChangeMode:_calendarMode];
        }];
        // 回调代理
        if (self.delegate) {
            [self.delegate calendarWillChangeHeight:delta animated:animate];
        }
    } else {
        CGFloat tHeight = MAX(height, _weekHeight);    // 最小不能小于 周模式高度
        tHeight = MIN(tHeight, _monthHeight);       // 最大不能大于 月模式高度
        CGRect tFrame = self.frame;
        tFrame.size.height = tHeight;
        _nowHeight = tHeight;
        self.frame = tFrame;
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
    
//    if (self.delegate) {
//        [self.delegate didCalendarPageChange:middleDate];
//    }
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
