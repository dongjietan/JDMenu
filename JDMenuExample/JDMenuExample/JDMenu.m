//
//  JDMenu.m
//  JayMenu
//
//  Created by Jay on 15/5/30.
//  Copyright (c) 2015年 ithooks. All rights reserved.
//

#import "JDMenu.h"
#import "JDMenuRow.h"
#import "JDMenuItem.h"

@interface JDMenu()<JDMenuRowDelegate>{
    NSArray *menuRows;
    BOOL _initFrames;
}

@end

@implementation JDMenu

#pragma mark - Setup
- (void)setup {
    
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

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}

- (void)layoutSubviews{
    if (!_initFrames) {
        _initFrames = YES;
        NSInteger number = [self.dataSource menu:self numberOfRowsInSection:0];
        NSMutableArray *mArray = [NSMutableArray array];
        CGFloat originY = 0;
        for (int i = 0; i < number; ++i) {
            CGFloat height = JDMenuRowHeightDefault;
            if (self.delegate && [self.delegate respondsToSelector:@selector(menu:heightForRowAtIndexPath:)]) {
                height = [self.delegate menu:self heightForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            JDMenuRow *row;
            if (self.dataSource && [self.dataSource respondsToSelector:@selector(menu:rowAtIndexPath:)]) {
                row = [self.dataSource menu:self rowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            row.frame = CGRectMake(0, originY, self.frame.size.width, height);
            originY += height;
            row.delegate = self;
            [self addSubview:row];
            [mArray addObject:row];
        }
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, originY);
        [self menuFrameDidChanged];
        menuRows = [NSArray arrayWithArray:mArray];
    }
}

- (NSIndexPath *)indexPathForMenuRow:(JDMenuRow *)menuRow{
    NSInteger index = [menuRows indexOfObject:menuRow];
    return [NSIndexPath indexPathForRow:index inSection:0];
}

- (void)animationWillStart:(JDMenuRow *)menuRow{
    //    [UIView animateWithDuration:0.2f
    //                          delay:0.f
    //                        options:UIViewAnimationOptionCurveEaseInOut
    //                     animations:^{
    //                         CGFloat originY = 0;
    //                         for (int i = 0; i < menuRows.count; ++i) {
    //                             JDMenuRow *row = [menuRows objectAtIndex:i];
    //                             CGFloat height = [row defaultRowHeight];
    //                             row.frame = CGRectMake(0, originY, row.frame.size.width, height);
    //                             originY += height;
    //                         }
    //                         self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,originY);
    //                     }
    //                     completion:^(BOOL finished){
    //                         if (menuRow.status == JDMenuRowStatusNormal) {
    //                             [menuRow setSubRowItems:JDMenuItemViewSideLeft hidden:YES];
    //                             [menuRow setSubRowItems:JDMenuItemViewSideRight hidden:YES];
    //                         }
    //                         else if(menuRow.status == JDMenuRowStatusSpreadedLeft){
    //                             [menuRow setSubRowItems:JDMenuItemViewSideLeft hidden:NO];
    //                         }
    //                         else{
    //                             [menuRow setSubRowItems:JDMenuItemViewSideRight hidden:NO];
    //                         }
    //                     }];
}

- (void)animationFinished:(JDMenuRow *)menuRow{
    [UIView animateWithDuration:0.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGFloat originY = 0;
                         for (int i = 0; i < menuRows.count; ++i) {
                             JDMenuRow *row = [menuRows objectAtIndex:i];
                             CGFloat height = [row rowhHeight];
                             row.frame = CGRectMake(0, originY, row.frame.size.width, height);
                             originY += height;
                         }
                         self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,originY);
                         [self menuFrameDidChanged];
                     }
                     completion:^(BOOL finished){
                         if (menuRow.status == JDMenuRowStatusNormal) {
                             [menuRow setSubRowItems:JDMenuItemViewSideLeft hidden:YES];
                             [menuRow setSubRowItems:JDMenuItemViewSideRight hidden:YES];
                         }
                         else if(menuRow.status == JDMenuRowStatusSpreadedLeft){
                             [menuRow setSubRowItems:JDMenuItemViewSideLeft hidden:NO];
                         }
                         else{
                             [menuRow setSubRowItems:JDMenuItemViewSideRight hidden:NO];
                         }
                     }];
}

- (void)menuRow:(JDMenuRow *)menuRow shouldChangeToStatus:(JDMenuRowStatus)status{
    for (int i = 0; i < menuRows.count; ++i) {
        JDMenuRow *row = [menuRows objectAtIndex:i];
        if (row == menuRow) {
            [row setRowStatus:status];
        }
        else{
            [row setRowStatus:JDMenuRowStatusNormal];
        }
    }
}

- (void)subItemTaped:(JDMenuItem *)menuItem menuItemView:(JDMenuItemView *)menuItemView menuRow:(JDMenuRow *)menuRow{
    NSLog(@"subItemTaped:%@",menuItem.title);
}

- (void)menuFrameDidChanged{
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuFrameDidChanged:)]) {
        [self.delegate menuFrameDidChanged:self];
    }
}
@end
