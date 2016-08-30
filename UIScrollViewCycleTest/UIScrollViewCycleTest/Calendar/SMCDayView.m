//
//  SMCDayView.m
//  UIScrollViewCycleTest
//
//  Created by SMC-MAC on 16/8/30.
//  Copyright © 2016年 heyou. All rights reserved.
//

#import "SMCDayView.h"
#import "NSDate+String.h"
#import "DateManager.h"

@implementation SMCDayView

- (void)reloadDate:(NSDate*)date  currentDate:(NSDate*)cDate {
    self.labelTitle.text = [date hy_stringDay];
    
    BOOL isInSameMonth = [[DateManager sharedInstance] isDate:date inSameMonthWithDate:cDate];
    if (isInSameMonth) {
        self.labelTitle.textColor = [UIColor blackColor];
    } else {
        self.labelTitle.textColor = [UIColor lightGrayColor];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSString* nibName = NSStringFromClass([SMCDayView class]);
        self = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] firstObject];
        self.autoresizingMask = UIViewAutoresizingNone;
        self.frame = frame;
    }
    return self;
}

@end
