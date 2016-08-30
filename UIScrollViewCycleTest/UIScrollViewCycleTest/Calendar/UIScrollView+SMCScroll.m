//
//  UIScrollView+SMCScroll.m
//  UIScrollViewCycleTest
//
//  Created by SMC-MAC on 16/8/30.
//  Copyright © 2016年 heyou. All rights reserved.
//

#import "UIScrollView+SMCScroll.h"

@implementation UIScrollView (SMCScroll)

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    return YES;
}

- (void)smc_disableTouchDelay {
    self.delaysContentTouches = NO;
    self.canCancelContentTouches = YES;
    NSArray* subview = [self subviews];
    for (id view in subview) {
        if ([NSStringFromClass([view class]) isEqualToString:@"UITableViewWrapperView"]) {
            // this test is necessary for safety and because a "UITableViewWrapperView" is NOT a UIScrollView in iOS7
            if([view isKindOfClass:[UIScrollView class]]) {
                // turn OFF delaysContentTouches in the hidden subview
                UIScrollView *scroll = (UIScrollView *)view;
                scroll.delaysContentTouches = NO;
            }
            break;
        }
    }
}

@end
