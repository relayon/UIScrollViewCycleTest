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

@end

@interface SMCCalendarView : UIView

@property (weak, nonatomic) id<SMCCalendarDelegate> delegate;

@end
