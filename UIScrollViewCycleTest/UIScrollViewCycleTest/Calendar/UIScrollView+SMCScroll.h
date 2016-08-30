//
//  UIScrollView+SMCScroll.h
//  UIScrollViewCycleTest
//
//  Created by SMC-MAC on 16/8/30.
//  Copyright © 2016年 heyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (SMCScroll)

/**
 *  覆盖系统方法，返回TURE
 *
 *  @param view --
 *
 *  @return TRUE
 */
- (BOOL)touchesShouldCancelInContentView:(UIView *)view;

- (void)smc_disableTouchDelay;

@end
