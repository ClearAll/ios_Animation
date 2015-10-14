//
//  CircleView.m
//  animatedCircle
//
//  Created by Zane on 15/10/14.
//  Copyright © 2015年 Zane. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView

+ (Class)layerClass
{
    return [CircleLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.circleLayer = [CircleLayer layer];
        self.circleLayer.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        self.circleLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:self.circleLayer];
    }
    return self;
}

@end
