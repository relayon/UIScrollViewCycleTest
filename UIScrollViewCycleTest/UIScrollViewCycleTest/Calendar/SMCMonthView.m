//
//  SMCMonthView.m
//  UIScrollViewCycleTest
//
//  Created by SMC-MAC on 16/8/30.
//  Copyright © 2016年 heyou. All rights reserved.
//

#import "SMCMonthView.h"
#import "SMCWeekView.h"
#import "DateManager.h"

@interface SMCMonthView () {
    NSArray<SMCWeekView*>* _weeks;
    CGFloat _nowHeight; // 高度
    CGFloat _weekHeight;
    NSInteger _anchorIndex; // 悬浮index
    CGFloat _velocity;
    
    NSDate* _currentDate;
}

@end

@implementation SMCMonthView

- (void)reloadDate:(NSDate*)date {
    _currentDate = date;
    NSDate* firstDayOfMonth = [[DateManager sharedInstance] firstDayOfMonth:date];
    NSDate* firstDayOfWeek = [[DateManager sharedInstance] firstDayOfWeek:firstDayOfMonth];
    for (NSInteger idx = 0; idx < 6; idx++) {
        NSDate* tDate = [[DateManager sharedInstance] dateWithDate:firstDayOfWeek weekOffset:idx];
        SMCWeekView* wv = [_weeks objectAtIndex:idx];
        [wv reloadDate:tDate currentDate:date];
    }
}

#pragma mark -- init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSString* nibName = NSStringFromClass([SMCMonthView class]);
        self = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] firstObject];
        self.autoresizingMask = UIViewAutoresizingNone;
        self.frame = frame;
        
        _nowHeight = frame.size.height;
        _weekHeight = frame.size.width / 7.0f;
        _anchorIndex = 3;
        _velocity = 100.0f;
    }
    return self;
}

- (void)initWeeks {
    NSMutableArray* mary = [NSMutableArray array];
    CGFloat width = self.frame.size.width;
    CGFloat height = _weekHeight;
    
//    SMCWeekView* fView = nil;
    for (int i = 0; i < 6; i++) {
        CGFloat py = i*height;
        SMCWeekView* wk = [[SMCWeekView alloc] initWithFrame:CGRectMake(0, py, width, height)];
        wk.tag = i;
        wk.backgroundColor = [UIColor orangeColor];
        [self addSubview:wk];
//        if (fView == nil) {
//            [self addSubview:wk];
//            fView = wk;
//        } else {
//            [self insertSubview:wk belowSubview:fView];
//        }
        [wk initDays];
        [mary addObject:wk];
    }
    
    _weeks = mary;
    
    SMCWeekView* fView = [_weeks objectAtIndex:_anchorIndex];
    [self bringSubviewToFront:fView];
}

- (void)_layoutWeekViews {
    CGFloat weekHeight = _weekHeight;
    NSInteger nc = _weeks.count;
    for (SMCWeekView* wv in _weeks) {
        CGRect tFrame = wv.frame;
        NSInteger dnc = nc - wv.tag;
        NSLog(@"dnc = %ld", dnc);
        CGFloat py = _nowHeight - (nc - wv.tag)*weekHeight;
        if (wv.tag == _anchorIndex) {
            py = MAX(py, 0.0f);
        }
        tFrame.origin.y = py;
        wv.frame = tFrame;
    }
}

- (void)_layoutOtherWeekViews {
    CGFloat weekHeight = _weekHeight;
    NSInteger nc = _weeks.count;
    for (SMCWeekView* wv in _weeks) {
        if (wv.tag != _anchorIndex) {
            CGRect tFrame = wv.frame;
            CGFloat py = _nowHeight - (nc - wv.tag)*weekHeight;
            CGFloat delta = tFrame.origin.y - py;
            NSLog(@"delta ===== %f", delta);
            tFrame.origin.y = py;
            wv.frame = tFrame;
        }
    }
}

- (void)_layoutAnchorWeekView {
    NSInteger nc = _weeks.count;
    SMCWeekView* wv = [_weeks objectAtIndex:_anchorIndex];
    CGFloat py = _nowHeight - (nc - wv.tag)*_weekHeight;
    py = MAX(py, 0.0f);
    CGRect tFrame = wv.frame;
    tFrame.origin.y = py;
    wv.frame = tFrame;
}

- (CGFloat)_getAnchorWeekViewOriginY:(CGFloat)atHeight {
    NSInteger nc = _weeks.count;
    SMCWeekView* wv = [_weeks objectAtIndex:_anchorIndex];
    CGFloat py = atHeight - (nc - wv.tag)*_weekHeight;
    return py;
}

- (void)changeHeight:(CGFloat)height complete:(void (^)(BOOL finished))cb {
    // 获取当前高度（改变高度之前）下，悬浮的WeekView应该在的位置
    CGFloat py1 = [self _getAnchorWeekViewOriginY:_nowHeight];
    _nowHeight = height;
    // 获取改变高度后，悬浮的WeekView应该在的位置
    CGFloat py2 = [self _getAnchorWeekViewOriginY:height];
    // 修改高度后应该移动的距离
    CGFloat dis = fabs(py2 - py1);
    CGFloat tm = dis / _velocity;
    [UIView animateWithDuration:tm delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        [self _layoutOtherWeekViews];
    } completion:^(BOOL finished) {
        if (cb) {
            cb(YES);
        }
    }];
    
    // 悬浮窗实际所在的位置
    CGFloat py3 = MAX(py1, 0.0f);
    // 两者只差，为动画应该delay的时间
    CGFloat ddis = fabs(py3 - py1);
    CGFloat dtm = ddis / _velocity;
    
    // 改变高度后，实际所在位置
    CGFloat py4 = MAX(py2, 0.0f);
    CGFloat tdis = fabs(py4 - py3);
    CGFloat ttm = tdis / _velocity;
    [UIView animateWithDuration:ttm delay:dtm options:UIViewAnimationOptionCurveLinear animations:^{
        [self _layoutAnchorWeekView];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)rawChangeHeight:(CGFloat)height {
    _nowHeight = height;
    [self _layoutAnchorWeekView];
    [self _layoutOtherWeekViews];
}

@end
