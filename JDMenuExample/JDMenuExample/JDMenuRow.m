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

#warning 这个里的frame坑定不能这么传过来
- (instancetype)initWithFrame:(CGRect)frame leftMenuItem:(JDMenuItem *)leftMenuItem rightMenuItem:(JDMenuItem *)rightMenuItem{
    if (self = [self initWithFrame:frame]) {
        leftItemView = [[JDMenuItemView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width * 0.5f, JDMenuRowHeightDefault)];
        [leftItemView setWithMenuItem:leftMenuItem];
        leftItemView.side = JDMenuItemViewSideLeft;
        leftItemView.delegate = self;
        [self addSubview:leftItemView];
        
        rightItemView = [[JDMenuItemView alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.5f, 0, self.frame.size.width * 0.5f, JDMenuRowHeightDefault)];
        [rightItemView setWithMenuItem:rightMenuItem];
        rightItemView.side = JDMenuItemViewSideRight;
        rightItemView.delegate = self;
        [self addSubview:rightItemView];
        
        [self addSubItems:leftItemView];
        [self addSubItems:rightItemView];
    }
    return self;
}

- (CGFloat)rowhHeight{
#warning need delete JDMenuRowItemSide
    if (_status == JDMenuRowStatusNormal) {
        rowItemSide = JDMenuRowItemSideNone;
    }
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
            CGFloat labelStartPointY = JDMenuRowHeightDefault + JDMenuRowTitleOriginY;
            
            CGRect frame = CGRectZero;
            frame.origin.x = startPointX + col * (JDMenuRowIconWidthDefault + JDMenuRowIconSpaceDefault);
            frame.origin.y = startPointY + row * JDMenuRowSubRowHeightDefault;
            frame.size.width = JDMenuRowIconWidthDefault;
            frame.size.height = JDMenuRowIconWidthDefault;
            
            UIButton *button = [[UIButton alloc] initWithFrame:frame];
            [button setImage:menuItem.image forState:UIControlStateNormal];
            [button addTarget:self action:@selector(subItemTaped:) forControlEvents:UIControlEventTouchUpInside];
            button.hidden = YES;
            button.tag = i;
            [self addSubview:button];
            
            frame = CGRectZero;
            frame.origin.x = startPointX + col * (JDMenuRowIconWidthDefault + JDMenuRowIconSpaceDefault);
            frame.origin.y = labelStartPointY + row * JDMenuRowSubRowHeightDefault;
            frame.size.width = JDMenuRowIconWidthDefault;
            frame.size.height = JDMenuRowTitleHeightDefault;
            
            UILabel *label = [[UILabel alloc] initWithFrame:frame];
            label.text = menuItem.title;
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor darkGrayColor];
            label.hidden = YES;
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
            
            [mArray addObject:button];
            [mArray addObject:label];
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


- (void)restoreNormalState{
    [self setSubRowItems:JDMenuRowItemSideLeft hidden:YES];
    [self setSubRowItems:JDMenuRowItemSideRight hidden:YES];
}

- (void)setRowStatus:(JDMenuRowStatus)status{
    leftItemView.userInteractionEnabled = NO;
    rightItemView.userInteractionEnabled = NO;
    __weak __typeof(&*self)weakSelf = self;
    [UIView animateWithDuration:0.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [weakSelf restoreNormalState];
                         if (status == JDMenuRowStatusNormal) {
                             [leftItemView restoreNormalState];
                             [rightItemView restoreNormalState];
                         }
                         else if(status == JDMenuRowStatusSpreadedLeft){
                             [leftItemView spreadToFrame:CGRectMake(0, 0, self.frame.size.width - 75, JDMenuRowHeightDefault)];
                             [rightItemView shrinkToFrame:CGRectMake(self.frame.size.width - 75, 0, 75, JDMenuRowHeightDefault)];
                         }
                         else{
                             [leftItemView shrinkToFrame:CGRectMake(0, 0, 75, JDMenuRowHeightDefault)];
                             [rightItemView spreadToFrame:CGRectMake(75, 0, self.frame.size.width - 75, JDMenuRowHeightDefault)];
                         }
                     }
                     completion:^(BOOL finished){
                         leftItemView.userInteractionEnabled = YES;
                         rightItemView.userInteractionEnabled = YES;
                         _status = status;
                         if (status == JDMenuRowStatusNormal) {
                             leftItemView.status = JDMenuItemViewStatusNormal;
                             rightItemView.status = JDMenuItemViewStatusNormal;
                             [weakSelf animationFinishedWithMenuRowItemSide:JDMenuRowItemSideNone];
                         }
                         else if(status == JDMenuRowStatusSpreadedLeft){
                             leftItemView.status = JDMenuItemViewStatusSpreaded;
                             rightItemView.status = JDMenuItemViewStatusShrinked;
                             [weakSelf animationFinishedWithMenuRowItemSide:JDMenuRowItemSideLeft];
                         }
                         else{
                             leftItemView.status = JDMenuItemViewStatusShrinked;
                             rightItemView.status = JDMenuItemViewStatusSpreaded;
                             [weakSelf animationFinishedWithMenuRowItemSide:JDMenuRowItemSideRight];
                         }
                     }];
}

#pragma mark - Delegate

- (void)subItemTaped:(UIButton *)sender{
    JDMenuItemView *menuItemView;
    if ([leftSubRowItems containsObject:sender]) {
        menuItemView = leftItemView;
    }
    else if ([rightSubRowItems containsObject:sender]){
        menuItemView = rightItemView;
    }
    NSArray *subItems = menuItemView.menuItem.subItems;
    JDMenuItem *menuItem = [subItems objectAtIndex:sender.tag];
    if (self.delegate && [self.delegate respondsToSelector:@selector(subItemTaped:menuItemView:menuRow:)]) {
        [self.delegate subItemTaped:menuItem menuItemView:menuItemView menuRow:self];
    }
}

- (void)menuItemTaped:(JDMenuItemView *)menuItemView{
    JDMenuRowStatus status;
    if (menuItemView.status == JDMenuItemViewStatusSpreaded) {
        status = JDMenuRowStatusNormal;
    }
    else{
        if (menuItemView.side == JDMenuItemViewSideLeft) {
            status = JDMenuRowStatusSpreadedLeft;
        }
        else{
            status = JDMenuRowStatusSpreadedRight;
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuRow:shouldChangeToStatus:)]) {
        [self.delegate menuRow:self shouldChangeToStatus:status];
    }
}

- (void)animationFinishedWithMenuRowItemSide:(JDMenuRowItemSide)menuRowItemSide{
    rowItemSide = menuRowItemSide;
    if (self.delegate && [self.delegate respondsToSelector:@selector(animationFinished:menuRowItemSide:)]) {
        [self.delegate animationFinished:self menuRowItemSide:menuRowItemSide];
    }
}
@end
