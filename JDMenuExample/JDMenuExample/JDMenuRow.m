//
//  JDMenuRow.m
//  JayMenu
//
//  Created by Jay on 15/5/30.
//  Copyright (c) 2015年 ithooks. All rights reserved.
//

#import "JDMenuRow.h"
#import "JDMenuItemView.h"
#import "JDMenuItem.h"

@interface JDMenuRow()<JDMenuItemViewDelegate>
{
    JDMenuItemView *leftItemView;
    JDMenuItemView *rightItemView;
    CGRect normalFrame;
}

@end

@implementation JDMenuRow

#pragma mark - Setup
- (void)setup {
    NSLog(@"frame:%@",NSStringFromCGRect(self.frame));
    _status = JDMenuRowStatusNormal;
    normalFrame = self.frame;
    JDMenuItem *menuItem = [[JDMenuItem alloc] init];
    menuItem.image = [UIImage imageNamed:@"live_leave1_3_icon"];
    leftItemView = [[JDMenuItemView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width * 0.5f, 64)];
    [leftItemView setWithMenuItem:menuItem];
    leftItemView.delegate = self;
    [self addSubview:leftItemView];
    
    menuItem = [[JDMenuItem alloc] init];
    menuItem.image = [UIImage imageNamed:@"live_leave1_6_icon"];
    rightItemView = [[JDMenuItemView alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.5f, 0, self.frame.size.width * 0.5f, 64)];
    [rightItemView setWithMenuItem:menuItem];
    rightItemView.delegate = self;
    [self addSubview:rightItemView];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [self setup];
}

- (void)menuItemTaped:(JDMenuItemView *)menuItemView{
    if (menuItemView == leftItemView) {
        if (menuItemView.status == JDMenuItemViewStatusSpreaded){
            [self restoreNormalState];
            [menuItemView restoreNormalState];
            [rightItemView restoreNormalState];
        }
        else{
            [leftItemView spreadToFrame:CGRectMake(0, 0, self.frame.size.width - 75, 64)];
            [rightItemView shrinkToFrame:CGRectMake(self.frame.size.width - 75, 0, 75, 64)];
        }
    }
    else if (menuItemView == rightItemView) {
        if (menuItemView.status == JDMenuItemViewStatusSpreaded){
            [self restoreNormalState];
            [leftItemView restoreNormalState];
            [rightItemView restoreNormalState];
        }
        else{
            [leftItemView shrinkToFrame:CGRectMake(0, 0, 75, 64)];
            [rightItemView spreadToFrame:CGRectMake(75, 0, self.frame.size.width - 75, 64)];
        }
    }
}

- (void)spreadSubMenu{
    NSInteger count = 7;
    CGFloat width = 52;
    CGFloat height = 92;
    CGFloat space = 30;
    CGFloat totoalWidth = (count - 1) * space + count * width;
    if (count > 4) {
        totoalWidth = (4 - 1) * space + 4 * width;
    }
    else{
        totoalWidth = (count - 1) * space + count * width;
    }
    CGFloat startPointX = (self.frame.size.width - totoalWidth) * 0.5f;
    CGFloat startPointY = 64 + 12;
    CGFloat labelStartPointY = 64 + 68;
    
    CGRect newFrame = self.frame;
    newFrame.size.height = 64 + height * ((count - 1) / 4 + 1);
    
    NSLog(@"frame:%@",NSStringFromCGRect(self.frame));
    __weak __typeof(&*self)weakSelf = self;
    [UIView animateWithDuration:0.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         weakSelf.frame = newFrame;
                     }
                     completion:^(BOOL finished){
                         for (int i = 0; i < count; ++i) {
                             UIImage *image = [UIImage imageNamed:@"live_leave1_5_icon"];
                             NSInteger row = i / 4;
                             NSInteger col = i % 4;
                             CGRect frame = CGRectZero;
                             frame.origin.x = startPointX + col * (width + space);
                             frame.origin.y = startPointY + row * height;
                             frame.size.width = width;
                             frame.size.height = width;
                             UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
                             imageView.image = image;
                             [self addSubview:imageView];
                         }
                     }];
}

- (void)restoreNormalState{
    __weak __typeof(&*self)weakSelf = self;
    [UIView animateWithDuration:0.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         weakSelf.frame = normalFrame;
                         for (UIView *view in self.subviews) {
                             if (view != leftItemView && view != rightItemView) {
                                 [view removeFromSuperview];
                             }
                         }
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void)animationFinished:(JDMenuItemView *)menuItemView{
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(JDMenuRowDelegate)]) {
        [self.delegate itemAnimationFinished:self];
    }
}

@end
