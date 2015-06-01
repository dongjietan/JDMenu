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
    NSArray *leftSubRowItems;
    NSArray *rightSubRowItems;
    JDMenuRowItemSide rowItemSide;
}

@end

@implementation JDMenuRow

#pragma mark - Setup
- (void)setup {
    NSLog(@"frame:%@",NSStringFromCGRect(self.frame));
    _status = JDMenuRowStatusNormal;
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

#warning 这个里的frame坑定不能这么用
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    normalFrame = frame;
}

#warning 这个里的frame坑定不能这么传过来
- (instancetype)initWithFrame:(CGRect)frame leftMenuItem:(JDMenuItem *)leftMenuItem rightMenuItem:(JDMenuItem *)rightMenuItem{
    if (self = [self initWithFrame:frame]) {
        leftItemView = [[JDMenuItemView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width * 0.5f, JDMenuRowHeightDefault)];
        [leftItemView setWithMenuItem:leftMenuItem];
        leftItemView.delegate = self;
        [self addSubview:leftItemView];
        
        rightItemView = [[JDMenuItemView alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.5f, 0, self.frame.size.width * 0.5f, JDMenuRowHeightDefault)];
        [rightItemView setWithMenuItem:rightMenuItem];
        rightItemView.delegate = self;
        [self addSubview:rightItemView];
        
        [self addSubItems:leftItemView];
        [self addSubItems:rightItemView];
    }
    return self;
}

- (CGFloat)rowhHeight{
    CGFloat height = JDMenuRowHeightDefault;
    if (rowItemSide != JDMenuRowItemSideNone){
        JDMenuItemView *menuItemView = rowItemSide == JDMenuRowItemSideLeft ? leftItemView : rightItemView;
        NSArray *subItems = menuItemView.menuItem.subItems;
        NSInteger count = subItems.count;
        NSInteger totalRow = count == 0 ? 0 : (count - 1) / 4 + 1;
        height = totalRow * JDMenuRowSubRowHeightDefault + JDMenuRowHeightDefault;
    }
    return height;
}

- (void)addSubItems:(JDMenuItemView *)menuItemView
{
    NSArray *subItems = menuItemView.menuItem.subItems;
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
            
            CGFloat startPointX = (self.frame.size.width - totoalWidth) * 0.5f;
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
        if (menuItemView == leftItemView) {
            leftSubRowItems = [NSArray arrayWithArray:mArray];
        }
        else{
            rightSubRowItems = [NSArray arrayWithArray:mArray];
        }
    }
}

- (void)setSubRowItems:(JDMenuRowItemSide)menuRowItemSide hidden:(BOOL)hidden{
    NSArray *subRowItems = menuRowItemSide == JDMenuRowItemSideLeft ? leftSubRowItems : rightSubRowItems;
    for (UIView *view in subRowItems) {
        view.hidden = hidden;
    }
}

- (void)menuItemTaped:(JDMenuItemView *)menuItemView{
    leftItemView.userInteractionEnabled = NO;
    rightItemView.userInteractionEnabled = NO;
    __weak __typeof(&*self)weakSelf = self;
    [UIView animateWithDuration:0.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if (menuItemView.status == JDMenuItemViewStatusSpreaded) {
                             [weakSelf restoreNormalState];
                             [leftItemView restoreNormalState];
                             [rightItemView restoreNormalState];
                         }
                         else{
                             [weakSelf restoreNormalState];
                             if (menuItemView == leftItemView) {
                                 [leftItemView spreadToFrame:CGRectMake(0, 0, self.frame.size.width - 75, JDMenuRowHeightDefault)];
                                 [rightItemView shrinkToFrame:CGRectMake(self.frame.size.width - 75, 0, 75, JDMenuRowHeightDefault)];
                             }
                             else if (menuItemView == rightItemView) {
                                 [leftItemView shrinkToFrame:CGRectMake(0, 0, 75, JDMenuRowHeightDefault)];
                                 [rightItemView spreadToFrame:CGRectMake(75, 0, self.frame.size.width - 75, JDMenuRowHeightDefault)];
                             }
                         }
                     }
                     completion:^(BOOL finished){
                         leftItemView.userInteractionEnabled = YES;
                         rightItemView.userInteractionEnabled = YES;
                         if (menuItemView.status == JDMenuItemViewStatusSpreaded) {
                             leftItemView.status = JDMenuItemViewStatusNormal;
                             rightItemView.status = JDMenuItemViewStatusNormal;
                             _status = JDMenuRowStatusNormal;
                             [weakSelf animationFinishedWithMenuRowItemSide:JDMenuRowItemSideNone];
                         }
                         else{
                             if (menuItemView == leftItemView) {
                                 leftItemView.status = JDMenuItemViewStatusSpreaded;
                                 rightItemView.status = JDMenuItemViewStatusShrinked;
                                 _status = JDMenuRowStatusSpreaded;
                                 [weakSelf animationFinishedWithMenuRowItemSide:JDMenuRowItemSideLeft];
                             }
                             else if (menuItemView == rightItemView) {
                                 leftItemView.status = JDMenuItemViewStatusShrinked;
                                 rightItemView.status = JDMenuItemViewStatusSpreaded;
                                 _status = JDMenuRowStatusSpreaded;
                                 [weakSelf animationFinishedWithMenuRowItemSide:JDMenuRowItemSideRight];
                             }
                         }
                     }];
}

- (void)restoreNormalState{
    self.frame = normalFrame;
    [self setSubRowItems:JDMenuRowItemSideLeft hidden:YES];
    [self setSubRowItems:JDMenuRowItemSideRight hidden:YES];
}

- (void)animationFinishedWithMenuRowItemSide:(JDMenuRowItemSide)menuRowItemSide{
    rowItemSide = menuRowItemSide;
    if (self.delegate && [self.delegate respondsToSelector:@selector(animationFinished:menuRowItemSide:)]) {
        [self.delegate animationFinished:self menuRowItemSide:menuRowItemSide];
    }
}
@end
