//
//  JDMenu.m
//  JayMenu
//
//  Created by Jay on 15/5/30.
//  Copyright (c) 2015年 ithooks. All rights reserved.
//

#import "JDMenu.h"
#import "JDMenuRow.h"

@interface JDMenu()<JDMenuRowDelegate>{
    NSArray *menuRows;
}

@end

@implementation JDMenu

#pragma mark - Setup
- (void)setup {
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
    menuRows = [NSArray arrayWithArray:mArray];
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

- (NSIndexPath *)indexPathForMenuRow:(JDMenuRow *)menuRow{
    NSInteger index = [menuRows indexOfObject:menuRow];
    return [NSIndexPath indexPathForRow:index inSection:0];
}

- (void)spreadAnimationFinished:(JDMenuRow *)menuRow menuRowItemSide:(JDMenuRowItemSide)menuRowItemSide{
    [UIView animateWithDuration:0.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGFloat originY = 0;
                         for (int i = 0; i < menuRows.count; ++i) {
                             JDMenuRow *row = [menuRows objectAtIndex:i];
                             CGFloat height = row == menuRow ? [menuRow spreadHeightForMenuRowItemSide:menuRowItemSide] : JDMenuRowHeightDefault;
                             row.frame = CGRectMake(0, originY, row.frame.size.width, height);
                             originY += height;
                         }
                         self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,originY);
                     }
                     completion:^(BOOL finished){
                        [menuRow setSubRowItems:menuRowItemSide hidden:NO];
                     }];
}

- (void)spread:(JDMenuRow *)menuRow{
    NSInteger count = 4;
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
    CGFloat startPointX = (menuRow.frame.size.width - totoalWidth) * 0.5f;
    CGFloat startPointY = 64 + 12;
    CGFloat labelStartPointY = 64 + 68;
    
    CGRect newFrame = menuRow.frame;
    newFrame.size.height = 64 + height * ((count - 1) / 4 + 1);
    
    [UIView animateWithDuration:0.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         menuRow.frame = newFrame;
                         JDMenuRow *row1 = [menuRows objectAtIndex:1];
                         CGRect frame = CGRectMake(0, newFrame.origin.y + newFrame.size.height, row1.frame.size.width, row1.frame.size.height);
                         row1.frame = frame;
                         JDMenuRow *row2 = [menuRows objectAtIndex:2];
                         frame = CGRectMake(0, frame.origin.y + frame.size.height, row1.frame.size.width, row1.frame.size.height);
                         row2.frame = frame;
                         self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, frame.origin.y + frame.size.height);
                     }
                     completion:^(BOOL finished){
//                         [menuRow setSubRowItems:menuRowItemSide hidden:NO];
                     }];
}
@end
