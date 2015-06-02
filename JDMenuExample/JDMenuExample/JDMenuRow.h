//
//  JDMenuRow.h
//  JayMenu
//
//  Created by Jay on 15/5/30.
//  Copyright (c) 2015年 ithooks. All rights reserved.
//

#import <UIKit/UIKit.h>

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

typedef NS_ENUM(NSInteger,JDMenuRowItemSide){
    JDMenuRowItemSideNone   = 0,        //normal
    JDMenuRowItemSideLeft   = 1 << 0,   
    JDMenuRowItemSideRight  = 1 << 1,
};

@class JDMenuRow;
@class JDMenuItem;
@class JDMenuItemView;
@protocol JDMenuRowDelegate <NSObject>
- (void)subItemTaped:(JDMenuItem *)menuItem menuItemView:(JDMenuItemView *)menuItemView menuRow:(JDMenuRow *)menuRow;
- (void)menuRow:(JDMenuRow *)menuRow shouldChangeToStatus:(JDMenuRowStatus)status;
- (void)animationFinished:(JDMenuRow *)menuRow menuRowItemSide:(JDMenuRowItemSide)menuRowItemSide;
@end

@interface JDMenuRow : UIView

@property(nonatomic,weak) id <JDMenuRowDelegate> delegate;
@property(nonatomic,readonly) JDMenuRowStatus status;

- (instancetype)initWithFrame:(CGRect)frame leftMenuItem:(JDMenuItem *)leftMenuItem rightMenuItem:(JDMenuItem *)rightMenuItem;

- (void)setSubRowItems:(JDMenuRowItemSide)menuRowItemSide hidden:(BOOL)hidden;
- (CGFloat)rowhHeight;
- (void)setRowStatus:(JDMenuRowStatus)status;
@end
