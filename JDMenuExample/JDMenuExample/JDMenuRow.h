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

typedef NS_ENUM(NSInteger,JDMenuRowStatus){
    JDMenuRowStatusNormal   = 0,
    JDMenuRowStatusSpreaded = 1 << 0,
};

@class JDMenuRow;
@protocol JDMenuRowDelegate <NSObject>
- (void)itemAnimationFinished:(JDMenuRow *)menuRow;
@end

@interface JDMenuRow : UIView

@property(nonatomic,weak) id <JDMenuRowDelegate> delegate;
@property(nonatomic,readonly) JDMenuRowStatus status;

@end
