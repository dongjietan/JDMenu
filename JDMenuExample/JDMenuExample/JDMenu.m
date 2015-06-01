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
    NSArray *rows;
}
@end

@implementation JDMenu

#pragma mark - Setup
- (void)setup {
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < 3; ++i) {
        JDMenuRow *row = [[JDMenuRow alloc] initWithFrame:CGRectMake(0, i * 64, self.frame.size.width, 64)];
        row.delegate = self;
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

- (void)itemAnimationFinished:(JDMenuRow *)menuRow{
    for (int i = 0; i < 3; ++i) {
        JDMenuRow *row = [rows objectAtIndex:i];
        if (i == 0) {
            [self spread:row];
        }
    }
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (JDMenuRow *)rowAtIndexPath:(NSIndexPath *)indexPath{
    return [rows objectAtIndex:indexPath.row];
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
                         JDMenuRow *row1 = [rows objectAtIndex:1];
                         CGRect frame = CGRectMake(0, newFrame.origin.y + newFrame.size.height, row1.frame.size.width, row1.frame.size.height);
                         row1.frame = frame;
                         JDMenuRow *row2 = [rows objectAtIndex:2];
                         frame = CGRectMake(0, frame.origin.y + frame.size.height, row1.frame.size.width, row1.frame.size.height);
                         row2.frame = frame;
                         self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, frame.origin.y + frame.size.height);
                     }
                     completion:^(BOOL finished){
                         for (int i = 0; i < count; ++i) {
                             UIImage *image = [UIImage imageNamed:@"live_leave1_5_icon"];
                             NSInteger row = i / 4;
                             NSInteger col = i % 4;
                             CGRect frame = CGRectZero;
                             frame.origin.x = startPointX + col * (width + space);
                             frame.origin.y = startPointY + row * height;
                             frame.size.width = width;
                             frame.size.height = width;
                             UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
                             imageView.image = image;
                             [menuRow addSubview:imageView];
                         }
                     }];
}
@end
