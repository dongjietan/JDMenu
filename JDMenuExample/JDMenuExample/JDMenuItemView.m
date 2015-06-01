//
//  JDMenuItemView.m
//  JayMenu
//
//  Created by Jay on 15/5/30.
//  Copyright (c) 2015年 ithooks. All rights reserved.
//

#import "JDMenuItemView.h"
#import "JDMenuItem.h"

@interface JDMenuItemView(){
    CGRect normalFrame;
}

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLB;
@end

@implementation JDMenuItemView

#pragma mark - Setup

- (void)setup{
    _status = JDMenuItemViewStatusNormal;
    normalFrame = self.frame;
    
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    tapGestureRecognize.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGestureRecognize];
}

- (instancetype)initWithFrame:(CGRect)frame {
#warning 改为手动添加以及自动布局
    NSString *className = NSStringFromClass([self class]);
    JDMenuItemView *customView = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
    customView.frame = frame;
    [customView setup];
    return customView;
}

- (void)setWithMenuItem:(JDMenuItem *)menuItem
{
    _menuItem = menuItem;
    [self.iconImgView setImage:menuItem.image];;
    self.titleLB.text = menuItem.title;
    self.subTitleLB.text = menuItem.subTitle;
}

- (void)singleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer{
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuItemTaped:)]) {
        [self.delegate menuItemTaped:self];
    }
}

- (void)shrinkToFrame:(CGRect)frame{
    self.frame = frame;
    self.containerView.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
    [self setBackgroundColorFitIcon];
    self.titleLB.alpha = 0;
    self.subTitleLB.alpha = 0;
}

- (void)spreadToFrame:(CGRect)frame{
    self.frame = frame;
    CGPoint center = CGPointMake(frame.size.width * 0.5f, frame.size.height * 0.5f);
    self.containerView.center = center;
    [self setBackgroundColorFitIcon];
    self.titleLB.alpha = 1;
    self.subTitleLB.alpha = 1;
    self.titleLB.textColor = [UIColor whiteColor];
    self.subTitleLB.textColor = [UIColor whiteColor];
}

- (void)restoreNormalState{
    self.frame = normalFrame;
    self.containerView.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
    self.backgroundColor = [UIColor whiteColor];
    self.titleLB.alpha = 1;
    self.subTitleLB.alpha = 1;
    self.titleLB.textColor = [UIColor blackColor];
    self.subTitleLB.textColor = [UIColor darkGrayColor];
}

- (void)setBackgroundColorFitIcon{
    UIImage *image = [self.iconImgView image];
    UIColor *color = [[self getRGBAsFromImage:image atX:image.size.height * 0.5f andY:4 count:1] firstObject];
    self.backgroundColor = color;
}

- (NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)x andY:(int)y count:(int)count
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    NSUInteger byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
    for (int i = 0 ; i < count ; ++i)
    {
        CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
        CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
        CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
        CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
        byteIndex += bytesPerPixel;
        
        UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        [result addObject:acolor];
    }
    
    free(rawData);
    
    return result;
}
@end
