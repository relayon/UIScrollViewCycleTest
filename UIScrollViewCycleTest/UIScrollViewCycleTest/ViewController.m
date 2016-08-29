//
//  ViewController.m
//  UIScrollViewCycleTest
//
//  Created by SMC-MAC on 16/8/29.
//  Copyright © 2016年 heyou. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate> {
    NSInteger _maxCount;
    NSInteger _currentIndex;
    
    UILabel* _left;
    UILabel* _middle;
    UILabel* _right;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _maxCount = 10;
    _currentIndex = 1;
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.backgroundColor = [UIColor redColor];
    self.scrollView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self _layoutViews];
    [self _reloadData];
}

#pragma mark -- layoutViews
- (void)_layoutViews {
    //
    CGFloat width = self.scrollView.frame.size.width;
//    CGFloat width = self.view.frame.size.width;
    // left
    _left = [UILabel new];
    _left.backgroundColor = [UIColor blueColor];
    _left.frame = CGRectMake(0, 0, 50, 50);
    [self.scrollView addSubview:_left];
    // middle
    _middle = [UILabel new];
    _middle.backgroundColor = [UIColor blueColor];
    _middle.frame = CGRectMake(width, 0, 50, 50);
    [self.scrollView addSubview:_middle];
    // right
    _right = [UILabel new];
    _right.backgroundColor = [UIColor blueColor];
    _right.frame = CGRectMake(width*2.0, 0, 50, 50);
    [self.scrollView addSubview:_right];
    
    CGSize sz = self.scrollView.contentSize;
    sz.width = width*3;
    [self.scrollView setContentSize:sz];
}

- (void)_reloadData {
    NSInteger leftIndex = (_currentIndex - 1 + _maxCount)%_maxCount;
    NSInteger rightIndex = (_currentIndex + 1)%_maxCount;
    _left.text = [NSString stringWithFormat:@"%ld", leftIndex];
    _middle.text = [NSString stringWithFormat:@"%ld", _currentIndex];
    _right.text = [NSString stringWithFormat:@"%ld", rightIndex];
}

#pragma mark -- UIScrollViewDelegate
// UIScrollView 停止滚动时回调
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat width = scrollView.frame.size.width;
    CGFloat ofx = self.scrollView.contentOffset.x;
    if (ofx > width) {
        _currentIndex = (_currentIndex + 1) % _maxCount;
        [self _reloadData];
    } else if (ofx < width) {
        _currentIndex = (_currentIndex - 1 + _maxCount) % _maxCount;
        [self _reloadData];
    }
    [self.scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
}

@end
