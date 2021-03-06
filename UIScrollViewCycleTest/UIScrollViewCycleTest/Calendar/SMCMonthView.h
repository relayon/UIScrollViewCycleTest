//
//  SMCMonthView.h
//  UIScrollViewCycleTest
//
//  Created by SMC-MAC on 16/8/30.
//  Copyright © 2016年 heyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMCMonthView : UIView
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

- (void)initWeeks;

- (void)changeHeight:(CGFloat)height complete:(void (^)(BOOL finished))cb;
//- (void)changeMode:(CalendarMode)mode complete:(void (^)(BOOL finished))cb;
- (void)rawChangeHeight:(CGFloat)height;

- (void)reloadDate:(NSDate*)date;

@end
