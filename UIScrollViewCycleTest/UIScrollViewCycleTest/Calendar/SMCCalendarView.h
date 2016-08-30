//
//  SMCCalendarView.h
//  UIScrollViewCycleTest
//
//  Created by SMC-MAC on 16/8/30.
//  Copyright © 2016年 heyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMCCalendarDelegate <NSObject>

@optional
- (void)didCalendarPageChange:(NSDate*)date;
- (void)didCalendarHeightChange:(CGFloat)height;

@end

@interface SMCCalendarView : UIView

@property (weak, nonatomic) id<SMCCalendarDelegate> delegate;

- (void)changeCalendarHeight:(CGFloat)delta;

@end
