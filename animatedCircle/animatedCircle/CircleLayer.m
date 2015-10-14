//
//  CircleLayer.m
//  animatedCircle
//
//  Created by Zane on 15/10/14.
//  Copyright © 2015年 Zane. All rights reserved.
//

#import "CircleLayer.h"
#import "ViewController.h"

typedef NS_ENUM(NSInteger, MovingPoint)
{
    POINT_D,
    POINT_B
};

int const kOutsideRectSize = 90;

@interface CircleLayer ()

/**
 *  外接矩形
 */
@property (nonatomic, assign) CGRect outsideRect;

/**
 *  记录上次progress，方便做差值得出滑动方向
 */
@property (nonatomic, assign) CGFloat lastProgress;

/**
 *  实时记录滑动方向
 */
@property (nonatomic, assign) MovingPoint movePoint;

@end

@implementation CircleLayer

- (instancetype)init
{
    if (self = [super init])
    {
        self.lastProgress = .5f;
    }
    return self;
}

- (instancetype)initWithLayer:(CircleLayer *)layer
{
    if (self = [super initWithLayer:layer])
    {
        self.progress = layer.progress;
        self.outsideRect = layer.outsideRect;
        self.lastProgress = layer.lastProgress;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    //外接矩形在左边改变B，在右边改变D点
    if (progress <= .5f)
    {
        self.movePoint = POINT_B;
        NSLog(@"B点动");
    }
    else
    {
        self.movePoint = POINT_D;
        NSLog(@"D点动");
    }
    
    self.lastProgress = progress;
    
    //计算圆在layer里的坐标
    CGFloat originX = self.position.x - kOutsideRectSize / 2 + (progress - .5) * (CGRectGetWidth(self.frame) - kOutsideRectSize);
    CGFloat originY = self.position.y - kOutsideRectSize / 2;
    
    self.outsideRect = CGRectMake(originX, originY, kOutsideRectSize, kOutsideRectSize);
    
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx
{
    //A-C1、B-C2 的距离，当设置为正方形的1/3.6倍时，画出来的圆弧最贴近圆形
    //http://blog.csdn.net/nibiewuxuanze/article/details/48103059
    CGFloat offset = CGRectGetWidth(self.outsideRect) / 3.6;
    
    //A.B.C.D实际需要移动的距离：系数为滑块偏离中心点.5的绝对值乘以2(最大为1)。当滑动到两端的时候，movedDistance为最大值：「外接正方形边长的 1/6」
    CGFloat movedDistance = CGRectGetWidth(self.outsideRect) / 6 * fabs(self.progress - .5) * 2;
    
    //计算外接矩形中心点
    CGPoint outsideRectPosition = CGPointMake(self.outsideRect.origin.x + self.outsideRect.size.width/2 , self.outsideRect.origin.y + self.outsideRect.size.height/2);
    
    //计算出A.B.C.D各点坐标
    CGPoint pointA = CGPointMake(outsideRectPosition.x, CGRectGetMinY(self.outsideRect) + movedDistance);
    CGPoint pointB = CGPointMake(self.movePoint == POINT_D ? CGRectGetMaxX(self.outsideRect) : CGRectGetMaxX(self.outsideRect) + movedDistance * 2, outsideRectPosition.y);
    CGPoint pointC = CGPointMake(outsideRectPosition.x, CGRectGetMaxY(self.outsideRect) - movedDistance);
    CGPoint pointD = CGPointMake(self.movePoint == POINT_D ? CGRectGetMinX(self.outsideRect) - movedDistance * 2 : CGRectGetMinX(self.outsideRect), outsideRectPosition.y);
    
    CGPoint pointC1 = CGPointMake(outsideRectPosition.x + offset, pointA.y);
    CGPoint pointC2 = CGPointMake(pointB.x, self.movePoint == POINT_D ? outsideRectPosition.y - offset : outsideRectPosition.y - offset + movedDistance);
    CGPoint pointC3 = CGPointMake(pointB.x, self.movePoint == POINT_D ? outsideRectPosition.y + offset : outsideRectPosition.y + offset - movedDistance);
    CGPoint pointC4 = CGPointMake(outsideRectPosition.x + offset, pointC.y);
    CGPoint pointC5 = CGPointMake(outsideRectPosition.x - offset, pointC.y);
    CGPoint pointC6 = CGPointMake(pointD.x, self.movePoint == POINT_D ? outsideRectPosition.y + offset - movedDistance : outsideRectPosition.y + offset);
    CGPoint pointC7 = CGPointMake(pointD.x, self.movePoint == POINT_D ? outsideRectPosition.y - offset + movedDistance : outsideRectPosition.y - offset);
    CGPoint pointC8 = CGPointMake(outsideRectPosition.x - offset, pointA.y);
    
    //!!!: 这里如果使用UIKit
    //外接矩形
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:self.outsideRect];
//    [rectPath setLineWidth:1];
//    CGFloat dash[] = {5.0, 5.0};
//    [rectPath setLineDash:dash count:2 phase:1];
//    [[UIColor blackColor] setStroke];
//    [rectPath stroke];
//    [rectPath closePath];
    CGContextAddPath(ctx, rectPath.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(ctx, 1);
    CGFloat dash[] = {5.0,5.0};
    //!!!: 这里设置为虚线
    CGContextSetLineDash(ctx, 0.0, dash, 2);
    CGContextStrokePath(ctx);
    
    //圆形边
    UIBezierPath *ovalPath = [UIBezierPath bezierPath];
    [ovalPath moveToPoint:pointA];
    [ovalPath addCurveToPoint:pointB controlPoint1:pointC1 controlPoint2:pointC2];
    [ovalPath addCurveToPoint:pointC controlPoint1:pointC3 controlPoint2:pointC4];
    [ovalPath addCurveToPoint:pointD controlPoint1:pointC5 controlPoint2:pointC6];
    [ovalPath addCurveToPoint:pointA controlPoint1:pointC7 controlPoint2:pointC8];
    [ovalPath closePath];
//    [[UIColor redColor] setFill];
//    [[UIColor blackColor] setStroke];
//    [ovalPath stroke];
//    [ovalPath fill];
//    [ovalPath closePath];
    CGContextAddPath(ctx, ovalPath.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
    //!!!: 这里需要把上面的虚线改回为实线，如果不改变那么还会是上面的虚线样式
    CGContextSetLineDash(ctx, 0, NULL, 0);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    //链接辅助线A-C!-C2-B-C3-C4-C-C5-C6-D-C7-C8-A
    UIBezierPath *helperPath = [UIBezierPath bezierPath];
    [helperPath moveToPoint:pointA];
    [helperPath addLineToPoint:pointC1];
    [helperPath addLineToPoint:pointC2];
    [helperPath addLineToPoint:pointB];
    [helperPath addLineToPoint:pointC3];
    [helperPath addLineToPoint:pointC4];
    [helperPath addLineToPoint:pointC];
    [helperPath addLineToPoint:pointC5];
    [helperPath addLineToPoint:pointC6];
    [helperPath addLineToPoint:pointD];
    [helperPath addLineToPoint:pointC7];
    [helperPath addLineToPoint:pointC8];
//    [helperPath addLineToPoint:pointA];
    [helperPath closePath];
    
    CGFloat dash2[] = {2.0, 2.0};
//    [helperPath setLineDash:dash2 count:2 phase:1];
//    [[UIColor blackColor] setStroke];
//    [helperPath stroke];
//    [helperPath closePath];
    CGContextAddPath(ctx, helperPath.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetLineDash(ctx, 0, dash2, 2);
    CGContextStrokePath(ctx);
}

@end
