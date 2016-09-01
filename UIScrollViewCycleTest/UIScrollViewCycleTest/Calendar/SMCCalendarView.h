//
//  SMCCalendarView.h
//  UIScrollViewCycleTest
//
//  Created by SMC-MAC on 16/8/30.
//  Copyright © 2016年 heyou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CalendarMode) {
    CalendarMode_Month, // 月模式 - 默认
    CalendarMode_Week,  // 周模式
};

@protocol SMCCalendarDelegate <NSObject>

@optional
- (void)calendarChangeHeightBegin;
- (void)calendarChangeHeight:(CGFloat)delta;

- (void)calendarWillChangeHeight:(CGFloat)delta animated:(BOOL)animate;
- (void)calendarDidChangeMode:(CalendarMode)mode;
//- (void)didCalendarPageChange:(NSDate*)date;
//- (void)didCalendarHeightChange:(CGFloat)height;

@end

@interface SMCCalendarView : UIView

@property (weak, nonatomic) id<SMCCalendarDelegate> delegate;

- (void)changeCalendarHeightBegin;
/**
    外部调用
 *  改变Calendar的高度，和UIScrollView联动
 *
 *  @param delta，根据UIScrollView的ContentOffset定义，
    向上滚动，delta < 0, Height变小
    @return 返回实际改变的高度
 */
- (void)changeCalendarHeight:(CGFloat)delta;
- (void)changeCalendarHeightEnd:(CGFloat)velocity;

@property (assign, nonatomic) CalendarMode calendarMode;

@end
