//
//  SMCDayView.h
//  UIScrollViewCycleTest
//
//  Created by SMC-MAC on 16/8/30.
//  Copyright © 2016年 heyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMCDayView : UIView
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

- (void)reloadDate:(NSDate*)date  currentDate:(NSDate*)cDate;

@end
