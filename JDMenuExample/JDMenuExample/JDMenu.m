//
//  JDMenu.m
//  JayMenu
//
//  Created by Jay on 15/5/30.
//  Copyright (c) 2015年 ithooks. All rights reserved.
//

#import "JDMenu.h"
#import "JDMenuRow.h"

@interface JDMenu(){
    NSArray *rows;
}
@end

@implementation JDMenu

#pragma mark - Setup
- (void)setup {
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < 3; ++i) {
        JDMenuRow *row = [[JDMenuRow alloc] initWithFrame:CGRectMake(0, i * 64, self.frame.size.width, 64)];
        [self addSubview:row];
        [mArray addObject:row];
    }
    rows = [NSArray arrayWithArray:mArray];
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

@end
