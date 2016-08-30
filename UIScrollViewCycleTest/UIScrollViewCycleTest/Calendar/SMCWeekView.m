//
//  SMCWeekView.m
//  UIScrollViewCycleTest
//
//  Created by SMC-MAC on 16/8/30.
//  Copyright © 2016年 heyou. All rights reserved.
//

#import "SMCWeekView.h"
#import "SMCDayView.h"
#import "DateManager.h"

@interface SMCWeekView () {
    NSArray<SMCDayView*>* _days;
}

@end

@implementation SMCWeekView

- (void)reloadDate:(NSDate*)date  currentDate:(NSDate*)cDate{
    for (NSInteger i = 0; i < 7; i++) {
        NSDate* tDate = [[DateManager sharedInstance] dateWithDate:date dayOffset:i];
        SMCDayView* day = [_days objectAtIndex:i];
        [day reloadDate:tDate currentDate:cDate];
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
        NSString* nibName = NSStringFromClass([SMCWeekView class]);
        self = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] firstObject];
        self.autoresizingMask = UIViewAutoresizingNone;
        self.frame = frame;
    }
    return self;
}

- (void)initDays {
    NSMutableArray* mary = [NSMutableArray array];
    
    CGFloat width = self.frame.size.width;
    width = width/7.0f;
    CGFloat height = self.frame.size.height;
    for (NSInteger i = 0; i < 7; i++) {
        CGFloat px = i*width;
        SMCDayView* day = [[SMCDayView alloc] initWithFrame:CGRectMake(px, 0, width, height)];
        day.tag = i;
        day.labelTitle.text = [NSString stringWithFormat:@"%ld,%ld", self.tag, i];
//        day.labelTitle.text = @"";
//        day.backgroundColor = [UIColor whiteColor];
//        [self addSubview:day];
        [self insertSubview:day atIndex:0];
        [mary addObject:day];
    }
    
    _days = mary;
}

@end
