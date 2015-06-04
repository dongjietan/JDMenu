//
//  JDMenu.h
//  JayMenu
//
//  Created by Jay on 15/5/30.
//  Copyright (c) 2015年 ithooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDMenu;
@class JDMenuRow;
@protocol JDMenuDataSource;

//_______________________________________________________________________________________________________________
// this represents the display and behaviour of the cells.

@protocol JDMenuDelegate<NSObject>

@optional
// Variable height support

- (CGFloat)menu:(JDMenu *)menu heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)menu:(JDMenu *)menu heightForSubRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)menuFrameDidChanged:(JDMenu *)menu;
@end

//_______________________________________________________________________________________________________________
// this protocol represents the data model object. as such, it supplies no information about appearance (including the cells)

@protocol JDMenuDataSource<NSObject>
@required
- (NSInteger)menu:(JDMenu *)menu numberOfRowsInSection:(NSInteger)section;
- (JDMenuRow *)menu:(JDMenu *)menu rowAtIndexPath:(NSIndexPath *)indexPath;
@required
@end


@interface JDMenu : UIView

@property (nonatomic, weak) IBOutlet id <JDMenuDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id <JDMenuDelegate>   delegate;

- (NSIndexPath *)indexPathForMenuRow:(JDMenuRow *)menuRow;

@end
