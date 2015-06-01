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
    [self.iconImgView setImage:menuItem.image];;
//    self.titleLB.text = menuItem.title;
//    self.subTitleLB.text = menuItem.subTitle;
}

- (void)singleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer{
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(JDMenuItemViewDelegate)]) {
        [self.delegate menuItemTaped:self];
    }
}

- (void)shrinkToFrame:(CGRect)frame{
    self.userInteractionEnabled = NO;
    __weak __typeof(&*self)weakSelf = self;
    [UIView animateWithDuration:0.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         weakSelf.frame = frame;
                         weakSelf.containerView.frame = CGRectMake(0, 0, weakSelf.containerView.frame.size.width, weakSelf.containerView.frame.size.height);
                         [weakSelf setBackgroundColorFitIcon];
                         weakSelf.titleLB.alpha = 0;
                         weakSelf.subTitleLB.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         weakSelf.userInteractionEnabled = YES;
                         _status = JDMenuItemViewStatusShrinked;
                     }];
}

- (void)spreadToFrame:(CGRect)frame{
    self.userInteractionEnabled = NO;
    __weak __typeof(&*self)weakSelf = self;
    CGPoint center = CGPointMake(frame.size.width * 0.5f, frame.size.height * 0.5f);
    [UIView animateWithDuration:0.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         weakSelf.frame = frame;
                         weakSelf.containerView.center = center;
                         [weakSelf setBackgroundColorFitIcon];
                         weakSelf.titleLB.alpha = 1;
                         weakSelf.subTitleLB.alpha = 1;
                         weakSelf.titleLB.textColor = [UIColor whiteColor];
                         weakSelf.subTitleLB.textColor = [UIColor whiteColor];
                     }
                     completion:^(BOOL finished){
                         weakSelf.userInteractionEnabled = YES;
                         _status = JDMenuItemViewStatusSpreaded;
                         if (finished) {
                             if (self.delegate && [self.delegate conformsToProtocol:@protocol(JDMenuItemViewDelegate)]) {
                                 [self.delegate animationFinished:self];
                             }
                         }
                     }];
}

- (void)restoreNormalState{
    self.userInteractionEnabled = NO;
    __weak __typeof(&*self)weakSelf = self;
    [UIView animateWithDuration:0.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         weakSelf.frame = normalFrame;
                         weakSelf.containerView.frame = CGRectMake(0, 0, weakSelf.containerView.frame.size.width, weakSelf.containerView.frame.size.height);
                         weakSelf.backgroundColor = [UIColor whiteColor];
                         weakSelf.titleLB.alpha = 1;
                         weakSelf.subTitleLB.alpha = 1;
                         weakSelf.titleLB.textColor = [UIColor blackColor];
                         weakSelf.subTitleLB.textColor = [UIColor darkGrayColor];
                     }
                     completion:^(BOOL finished){
                         weakSelf.userInteractionEnabled = YES;
                         _status = JDMenuItemViewStatusNormal;
                     }];
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
