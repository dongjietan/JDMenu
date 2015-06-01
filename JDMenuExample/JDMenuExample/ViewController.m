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
    JDMenuRow *menuRow = [[JDMenuRow alloc] init];
    return menuRow;
}

- (CGFloat)menu:(JDMenu *)menu heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (CGFloat)menu:(JDMenu *)menu heightForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92;
}

@end
