//
//  JDMenuItemView.h
//  JayMenu
//
//  Created by Jay on 15/5/30.
//  Copyright (c) 2015年 ithooks. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,JDMenuItemViewStatus){
    JDMenuItemViewStatusNormal      = 0,
    JDMenuItemViewStatusShrinked    = 1 << 0,
    JDMenuItemViewStatusSpreaded    = 1 << 1,
};

@class JDMenuItemView;
@protocol JDMenuItemViewDelegate <NSObject>
- (void)menuItemTaped:(JDMenuItemView *)menuItemView;
@end

@class JDMenuItem;
@interface JDMenuItemView : UIView

@property(nonatomic,weak) id <JDMenuItemViewDelegate> delegate;
@property(nonatomic,assign) JDMenuItemViewStatus status;
@property(nonatomic,strong,readonly) JDMenuItem *menuItem;

- (void)setWithMenuItem:(JDMenuItem *)menuItem;

- (void)shrinkToFrame:(CGRect)frame;
- (void)spreadToFrame:(CGRect)frame;
- (void)restoreNormalState;

@end
