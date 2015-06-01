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

#define JDMenuRowIconOriginY 12
#define JDMenuRowTitleOriginY 68

typedef NS_ENUM(NSInteger,JDMenuRowStatus){
    JDMenuRowStatusNormal   = 0,
    JDMenuRowStatusSpreaded = 1 << 0,
};

typedef NS_ENUM(NSInteger,JDMenuRowItemSide){
    JDMenuRowItemSideLeft   = 0,
    JDMenuRowItemSideRight  = 1 << 0,
};

@class JDMenuRow;
@class JDMenuItem;
@protocol JDMenuRowDelegate <NSObject>
- (void)spreadAnimationFinished:(JDMenuRow *)menuRow menuRowItemSide:(JDMenuRowItemSide)menuRowItemSide;
@end

@interface JDMenuRow : UIView

@property(nonatomic,weak) id <JDMenuRowDelegate> delegate;
@property(nonatomic,readonly) JDMenuRowStatus status;

- (instancetype)initWithFrame:(CGRect)frame leftMenuItem:(JDMenuItem *)leftMenuItem rightMenuItem:(JDMenuItem *)rightMenuItem;

- (void)setSubRowItems:(JDMenuRowItemSide)menuRowItemSide hidden:(BOOL)hidden;
- (CGFloat)spreadHeightForMenuRowItemSide:(JDMenuRowItemSide)menuRowItemSide;
@end
