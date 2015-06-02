//
//  ViewController.m
//  JDMenuExample
//
//  Created by Jay on 15/5/31.
//  Copyright (c) 2015年 ithooks. All rights reserved.
//

#import "ViewController.h"
#import "JDMenu.h"
#import "JDMenuRow.h"
#import "JDMenuItem.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)menu:(JDMenu *)menu numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (JDMenuRow *)menu:(JDMenu *)menu rowAtIndexPath:(NSIndexPath *)indexPath{
    JDMenuItem *leftMenuItem = [self randomMenuItem];
    NSMutableArray *mArray = [NSMutableArray array];
    NSInteger count = arc4random() % 10 + 1;
    for (int i = 0; i < count; ++i) {
        [mArray addObject:[self randomMenuItem]];
    }
    leftMenuItem.subItems = [NSArray arrayWithArray:mArray];
    
    JDMenuItem *rightMenuItem = [self randomMenuItem];
    mArray = [NSMutableArray array];
    count = arc4random() % 10 + 1;
    for (int i = 0; i < count; ++i) {
        [mArray addObject:[self randomMenuItem]];
    }
    rightMenuItem.subItems = [NSArray arrayWithArray:mArray];
    
    JDMenuRow *menuRow = [[JDMenuRow alloc] initWithFrame:CGRectMake(0, 0, menu.frame.size.width, JDMenuRowHeightDefault) leftMenuItem:leftMenuItem rightMenuItem:rightMenuItem];
    return menuRow;
}

- (CGFloat)menu:(JDMenu *)menu heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (CGFloat)menu:(JDMenu *)menu heightForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92;
}

- (JDMenuItem *)randomMenuItem{
    JDMenuItem *menuItem = [[JDMenuItem alloc] init];
    NSInteger index = arc4random() % 8 + 1;
    menuItem.image = [UIImage imageNamed:[NSString stringWithFormat:@"live_leave1_%ld_icon",(long)index]];
    menuItem.title = [self randomStringWithLength:6];
    menuItem.subTitle = [self randomStringWithLength:6];
    return menuItem;
}
NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

-(NSString *) randomStringWithLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}
@end
