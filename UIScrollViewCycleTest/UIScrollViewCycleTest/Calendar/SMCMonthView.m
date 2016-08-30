//
//  SMCMonthView.m
//  UIScrollViewCycleTest
//
//  Created by SMC-MAC on 16/8/30.
//  Copyright © 2016年 heyou. All rights reserved.
//

#import "SMCMonthView.h"
#import "SMCWeekView.h"

@interface SMCMonthView () {
    NSArray<SMCWeekView*>* _weeks;
    CGFloat _nowHeight; // 高度
    CGFloat _weekHeight;
    NSInteger _anchorIndex; // 悬浮index
}

@end

@implementation SMCMonthView

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
        _anchorIndex = 2;
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
        CGFloat py = _nowHeight - (nc - wv.tag)*weekHeight;
        if (wv.tag == _anchorIndex) {
            py = MAX(py, 0.0f);
        }
        tFrame.origin.y = py;
        wv.frame = tFrame;
    }
}

- (void)changeHeight:(CGFloat)height {
    _nowHeight = height;
    [self _layoutWeekViews];
}

@end
