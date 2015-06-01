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

@class JDMenuRow;
@class JDMenuItem;
@protocol JDMenuRowDelegate <NSObject>
- (void)itemAnimationFinished:(JDMenuRow *)menuRow;
@end

@interface JDMenuRow : UIView

@property(nonatomic,weak) id <JDMenuRowDelegate> delegate;
@property(nonatomic,readonly) JDMenuRowStatus status;

- (instancetype)initWithFrame:(CGRect)frame leftMenuItem:(JDMenuItem *)leftMenuItem rightMenuItem:(JDMenuItem *)rightMenuItem subItems:(NSArray *)subItems;

- (void)setSubRowItemsHidden:(BOOL)hidden;
@end
