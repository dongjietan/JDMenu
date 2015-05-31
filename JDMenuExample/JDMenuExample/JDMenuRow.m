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
}

@end

@implementation JDMenuRow

#pragma mark - Setup
- (void)setup {
    NSLog(@"frame:%@",NSStringFromCGRect(self.frame));
    JDMenuItem *menuItem = [[JDMenuItem alloc] init];
    menuItem.image = [UIImage imageNamed:@"live_leave1_3_icon"];
    leftItemView = [[JDMenuItemView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width * 0.5f, 64)];
    [leftItemView setWithMenuItem:menuItem];
    leftItemView.delegate = self;
    [self addSubview:leftItemView];
    
    menuItem = [[JDMenuItem alloc] init];
    menuItem.image = [UIImage imageNamed:@"live_leave1_6_icon"];
    rightItemView = [[JDMenuItemView alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.5f, 0, self.frame.size.width * 0.5f, 64)];
    [rightItemView setWithMenuItem:menuItem];
    rightItemView.delegate = self;
    [self addSubview:rightItemView];
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

- (void)menuItemTaped:(JDMenuItemView *)menuItemView{
    if (menuItemView == leftItemView) {
        if (menuItemView.status == JDMenuItemViewStatusSpreaded){
            [menuItemView restoreNormalState];
            [rightItemView restoreNormalState];
        }
        else{
            [leftItemView spreadToFrame:CGRectMake(0, 0, self.frame.size.width - 75, 64)];
            [rightItemView shrinkToFrame:CGRectMake(self.frame.size.width - 75, 0, 75, 64)];
        }
    }
    else if (menuItemView == rightItemView) {
        if (menuItemView.status == JDMenuItemViewStatusSpreaded){
            [leftItemView restoreNormalState];
            [rightItemView restoreNormalState];
        }
        else{
            [leftItemView shrinkToFrame:CGRectMake(0, 0, 75, 64)];
            [rightItemView spreadToFrame:CGRectMake(75, 0, self.frame.size.width - 75, 64)];
        }
    }
}
@end
