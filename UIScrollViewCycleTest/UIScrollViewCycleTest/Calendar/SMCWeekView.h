//
//  SMCWeekView.h
//  UIScrollViewCycleTest
//
//  Created by SMC-MAC on 16/8/30.
//  Copyright © 2016年 heyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMCWeekView : UIView

- (void)initDays;

- (void)reloadDate:(NSDate*)date currentDate:(NSDate*)cDate;

@end
