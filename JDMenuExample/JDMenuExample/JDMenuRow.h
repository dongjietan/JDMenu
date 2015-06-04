//
//  JDMenuRow.h
//  JayMenu
//
//  Created by Jay on 15/5/30.
//  Copyright (c) 2015年 ithooks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDMenuItemView.h"

#define JDMenuRowHeightDefault 64
#define JDMenuRowSubRowHeightDefault 92

#define JDMenuRowIconWidthDefault 52
#define JDMenuRowIconSpaceDefault 30

#define JDMenuRowTitleHeightDefault 16

#define JDMenuRowIconOriginY 12
#define JDMenuRowTitleOriginY 68

typedef NS_ENUM(NSInteger,JDMenuRowStatus){
    JDMenuRowStatusNormal           = 0,
    JDMenuRowStatusSpreadedLeft     = 1 << 0,
    JDMenuRowStatusSpreadedRight    = 1 << 1,
};

@class JDMenuRow;
@class JDMenuItem;

@protocol JDMenuRowDelegate <NSObject>
- (void)subItemTaped:(JDMenuItem *)menuItem menuItemView:(JDMenuItemView *)menuItemView menuRow:(JDMenuRow *)menuRow;
- (void)menuRow:(JDMenuRow *)menuRow shouldChangeToStatus:(JDMenuRowStatus)status;
- (void)animationWillStart:(JDMenuRow *)menuRow;
- (void)animationFinished:(JDMenuRow *)menuRow;
@end

@interface JDMenuRow : UIView

@property(nonatomic,weak) id <JDMenuRowDelegate> delegate;
@property(nonatomic,readonly) JDMenuRowStatus status;

- (instancetype)initWithFrame:(CGRect)frame leftMenuItem:(JDMenuItem *)leftMenuItem rightMenuItem:(JDMenuItem *)rightMenuItem;

- (void)setSubRowItems:(JDMenuItemViewSide)menuItemViewSide hidden:(BOOL)hidden;
- (CGFloat)rowhHeight;
- (CGFloat)defaultRowHeight;
- (void)setRowStatus:(JDMenuRowStatus)status;
@end
