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
    NSArray *subRowItems;
}

@end

@implementation JDMenuRow

#pragma mark - Setup
- (void)setup {
    NSLog(@"frame:%@",NSStringFromCGRect(self.frame));
    _status = JDMenuRowStatusNormal;
    normalFrame = self.frame;
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

- (instancetype)initWithFrame:(CGRect)frame leftMenuItem:(JDMenuItem *)leftMenuItem rightMenuItem:(JDMenuItem *)rightMenuItem subItems:(NSArray *)subItems{
    if (self = [self initWithFrame:frame]) {
        leftItemView = [[JDMenuItemView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width * 0.5f, JDMenuRowHeightDefault)];
        [leftItemView setWithMenuItem:leftMenuItem];
        leftItemView.delegate = self;
        [self addSubview:leftItemView];
        
        rightItemView = [[JDMenuItemView alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.5f, 0, self.frame.size.width * 0.5f, JDMenuRowHeightDefault)];
        [rightItemView setWithMenuItem:rightMenuItem];
        rightItemView.delegate = self;
        [self addSubview:rightItemView];
        
        NSInteger count = subItems.count;
        NSInteger totalRow = count == 0 ? 0 : (count - 1) / 4 + 1;
        if (totalRow > 0) {
            NSMutableArray *mArray = [NSMutableArray array];
            for (int i = 0; i < subItems.count; ++i) {
                JDMenuItem *menuItem = [subItems objectAtIndex:i];
                NSInteger row = i / 4;
                NSInteger col = i % 4;
                NSInteger numberInRow = row + 1 < totalRow ? 4 : count - (totalRow - 1) * 4;
                CGFloat totoalWidth = (numberInRow - 1) * JDMenuRowIconSpaceDefault + numberInRow * JDMenuRowIconWidthDefault;
    
                CGFloat startPointX = (frame.size.width - totoalWidth) * 0.5f;
                CGFloat startPointY = JDMenuRowHeightDefault + JDMenuRowIconOriginY;
                CGFloat labelStartPointY = 64 + JDMenuRowTitleOriginY;
                
                CGRect frame = CGRectZero;
                frame.origin.x = startPointX + col * (JDMenuRowIconWidthDefault + JDMenuRowIconSpaceDefault);
                frame.origin.y = startPointY + row * JDMenuRowSubRowHeightDefault;
                frame.size.width = JDMenuRowIconWidthDefault;
                frame.size.height = JDMenuRowIconWidthDefault;
                
                UIButton *button = [[UIButton alloc] initWithFrame:frame];
                [button setImage:menuItem.image forState:UIControlStateNormal];
                button.hidden = YES;
                [self addSubview:button];
                [mArray addObject:button];
            }
            subRowItems = [NSArray arrayWithArray:mArray];
        }
    }
    return self;
}

- (void)setSubRowItemsHidden:(BOOL)hidden{
    for (UIView *view in subRowItems) {
        view.hidden = hidden;
    }
}

- (void)menuItemTaped:(JDMenuItemView *)menuItemView{
    if (menuItemView == leftItemView) {
        if (menuItemView.status == JDMenuItemViewStatusSpreaded){
            [self restoreNormalState];
            [menuItemView restoreNormalState];
            [rightItemView restoreNormalState];
        }
        else{
            [leftItemView spreadToFrame:CGRectMake(0, 0, self.frame.size.width - 75, JDMenuRowHeightDefault)];
            [rightItemView shrinkToFrame:CGRectMake(self.frame.size.width - 75, 0, 75, JDMenuRowHeightDefault)];
        }
    }
    else if (menuItemView == rightItemView) {
        if (menuItemView.status == JDMenuItemViewStatusSpreaded){
            [self restoreNormalState];
            [leftItemView restoreNormalState];
            [rightItemView restoreNormalState];
        }
        else{
            [leftItemView shrinkToFrame:CGRectMake(0, 0, 75, JDMenuRowHeightDefault)];
            [rightItemView spreadToFrame:CGRectMake(75, 0, self.frame.size.width - 75, JDMenuRowHeightDefault)];
        }
    }
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
