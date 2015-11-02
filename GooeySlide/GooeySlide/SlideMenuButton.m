//
//  SlideMenuButton.m
//  GooeySlide
//
//  Created by Zane on 15/10/28.
//  Copyright © 2015年 Zane. All rights reserved.
//

#import "SlideMenuButton.h"

@interface SlideMenuButton ()

@property (nonatomic, strong) NSString *buttonTitle;

@end

@implementation SlideMenuButton

- (instancetype)initWithTitle:(NSString *)title
{
    if (self = [super init])
    {
        self.backgroundColor = [UIColor clearColor];
        self.buttonTitle = title;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //CGRectInset(rect,x,y)  以左上角为0，0   x  y为正是缩小，为负是放大
    UIBezierPath *roundRectanglePath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, 1, 1) cornerRadius:CGRectGetHeight(rect) / 2];
    
    [roundRectanglePath setLineWidth:1];
    [self.buttonColor setFill];
    [[UIColor whiteColor] setStroke];
    [roundRectanglePath fill];
    [roundRectanglePath stroke];
    
    NSMutableParagraphStyle *paraphStyle = [NSMutableParagraphStyle defaultParagraphStyle].mutableCopy;
    paraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attr = @{NSParagraphStyleAttributeName:   paraphStyle,
                           NSForegroundColorAttributeName:  [UIColor whiteColor],
                           NSFontAttributeName:             [UIFont systemFontOfSize:24]};
    
    CGSize size = [self.buttonTitle sizeWithAttributes:attr];
    
    CGRect r = CGRectMake(rect.origin.x, rect.origin.y + (CGRectGetHeight(rect) - size.height) / 2, CGRectGetWidth(rect), size.height);
    
    [self.buttonTitle drawInRect:r withAttributes:attr];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    NSUInteger tapCount = touch.tapCount;
    
    switch (tapCount)
    {
        case 1:
        {
            self.buttonClickBlock();
            break;
        }
        default:
            break;
    }
}

@end
