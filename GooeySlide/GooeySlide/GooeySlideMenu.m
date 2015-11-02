//
//  GooeySlideMenu.m
//  GooeySlide
//
//  Created by Zane on 15/10/28.
//  Copyright © 2015年 Zane. All rights reserved.
//

#import "GooeySlideMenu.h"
#import "SlideMenuButton.h"

int const kSpace = 30;
int const kExtraArea = 50;
int const kButtonHegiht = 40;

@interface GooeySlideMenu ()

@property (nonatomic, strong) CADisplayLink      *displayLink;

@property (nonatomic, assign) NSInteger          animationCount;

@property (nonatomic, strong) UIView             *helperCenterView;

@property (nonatomic, strong) UIView             *helperSideView;

@property (nonatomic, strong) UIVisualEffectView *blurView;

@property (nonatomic, strong) UIWindow           *keyWindow;

@property (nonatomic, assign) BOOL               triggered;

@property (nonatomic, assign) CGFloat            diff;

@property (nonatomic, strong) UIColor            *menuColor;

@end

@implementation GooeySlideMenu

- (instancetype)initWithTitles:(NSArray *)titles
{
    return [self initWithTitles:titles buttonHeight:kButtonHegiht menuColor:[UIColor colorWithRed:0.938 green:0.429 blue:1.000 alpha:1.000] backBlurStyle:UIBlurEffectStyleDark];
}

- (instancetype)initWithTitles:(NSArray *)titles buttonHeight:(CGFloat)height menuColor:(UIColor *)menuColor backBlurStyle:(UIBlurEffectStyle)style
{
    if (self = [super init])
    {
        _keyWindow = [UIApplication sharedApplication].keyWindow;
        
        _blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:style]];
        _blurView.frame = _keyWindow.frame;
        _blurView.alpha = .0f;
        
        _helperSideView = [[UIView alloc] initWithFrame:CGRectMake(-40, 0, 40, 40)];
        _helperSideView.backgroundColor = [UIColor redColor];
        _helperSideView.hidden = YES;
        [_keyWindow addSubview:_helperSideView];
        
        _helperCenterView = [[UIView alloc] initWithFrame:CGRectMake(-40, CGRectGetHeight(_keyWindow.frame) / 2, 40, 40)];
        _helperCenterView.backgroundColor = [UIColor yellowColor];
        _helperCenterView.hidden = YES;
        [_keyWindow addSubview:_helperCenterView];
        
        CGFloat width = CGRectGetWidth(_keyWindow.frame) / 2 + kExtraArea;
        self.frame = CGRectMake(-width, 0, width, CGRectGetHeight(_keyWindow.frame));
        self.backgroundColor = [UIColor clearColor];
        
        [_keyWindow insertSubview:self belowSubview:_helperSideView];
        
        _menuColor = menuColor;
        _menuButtonHeight = height;
        [self addButtons:titles];
    }
    return self;
}


- (void)addButtons:(NSArray *)titles
{
    CGFloat index = 0;
    if (titles.count % 2 == 0)
    {
        index = titles.count / 2;
    }
    else
    {
        index = titles.count / 2.0 + 1;
    }
    
    for (int idx = 0; idx < titles.count; idx++)
    {
        NSString *title = titles[idx];
        SlideMenuButton *menuButton = [[SlideMenuButton alloc] initWithTitle:title];
        menuButton.center = CGPointMake(CGRectGetWidth(_keyWindow.frame) / 4, CGRectGetHeight(_keyWindow.frame) / 2 + ((idx - index) * _menuButtonHeight + (idx - index) * kSpace) + _menuButtonHeight / 2 + kSpace / 2);
        menuButton.bounds = CGRectMake(0, 0, CGRectGetWidth(_keyWindow.frame) / 2 - 20 * 2, _menuButtonHeight);
        menuButton.buttonColor = _menuColor;
        
        [self addSubview:menuButton];
        menuButton.buttonClickBlock = ^()
        {
            self.menuClickBlock(idx, title, titles.count);
        };
    }
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame) - kExtraArea, 0)];
    
    [path addQuadCurveToPoint:CGPointMake(CGRectGetWidth(self.frame) - kExtraArea, CGRectGetHeight(self.frame)) controlPoint:CGPointMake(CGRectGetWidth(_keyWindow.frame) / 2 + _diff, CGRectGetHeight(_keyWindow.frame) / 2)];
    
    [path addLineToPoint:CGPointMake(0, CGRectGetHeight(self.frame))];
    [path closePath];

    [_menuColor setFill];
    [path fill];
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextAddPath(context, path.CGPath);
//    [_menuColor set];
//    CGContextFillPath(context);
}

- (void)animateButtons
{
    for (int idx = 0; idx < self.subviews.count; idx++)
    {
        UIView *menuButton = self.subviews[idx];
        menuButton.transform = CGAffineTransformMakeTranslation(-90, 0);
        
        [UIView animateWithDuration:.7f
                              delay:idx * (.3 / self.subviews.count)
             usingSpringWithDamping:.6f
              initialSpringVelocity:0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                         animations:^
        {
            menuButton.transform = CGAffineTransformIdentity;
        }               completion:NULL];
    }
}

- (void)trigger
{
    if (!_triggered)
    {
        [_keyWindow insertSubview:_blurView belowSubview:self];
        
        [UIView animateWithDuration:.3 animations:^
        {
            self.frame = self.bounds;
        }];
        
        [self beforeAnimation];
        [UIView animateWithDuration:.7f
                              delay:.0
             usingSpringWithDamping:.5f
              initialSpringVelocity:.9f
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^
        {
            _helperSideView.center = CGPointMake(_keyWindow.center.x,CGRectGetHeight(_helperSideView.frame) / 2);
        }
                         completion:^(BOOL finished)
        {
            [self finishAnimation];
        }];
        
        [UIView animateWithDuration:.3f animations:^
        {
            _blurView.alpha = 1;
        }];
        
        [self beforeAnimation];
        [UIView animateWithDuration:.7
                              delay:0
             usingSpringWithDamping:.8f
              initialSpringVelocity:2
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                         animations:^
        {
            _helperCenterView.center = _keyWindow.center;
        }
                         completion:^(BOOL finished)
        {
            if (finished)
            {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToUnTrigger:)];
                [_blurView addGestureRecognizer:tap];
                [self finishAnimation];
            }
        }];
        
        [self animateButtons];
        
        _triggered = YES;
    }
    else
    {
        [self tapToUnTrigger:nil];
    }
}

- (void)tapToUnTrigger:(UIButton *)sender
{
    [UIView animateWithDuration:.3 animations:^
    {
        self.frame = CGRectMake(-CGRectGetWidth(_keyWindow.frame) / 2 - kExtraArea, 0, CGRectGetWidth(_keyWindow.frame) / 2 + kExtraArea, CGRectGetHeight(_keyWindow.frame));
    }];
    
    [self beforeAnimation];
    
    [UIView animateWithDuration:.7
                          delay:0
         usingSpringWithDamping:.6
          initialSpringVelocity:.9
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                     animations:^
    {
        _helperSideView.center = CGPointMake(-CGRectGetHeight(_helperSideView.frame) / 2, CGRectGetHeight(_helperSideView.frame) / 2);
    }
                     completion:^(BOOL finished)
    {
        [self finishAnimation];
    }];
    
    [UIView animateWithDuration:.3 animations:^
    {
        _blurView.alpha = 0;
    }];
    
    [self beforeAnimation];
    
    [UIView animateWithDuration:.7
                          delay:0
         usingSpringWithDamping:.6
          initialSpringVelocity:.9
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                     animations:^
    {
        _helperCenterView.center = CGPointMake(-CGRectGetHeight(_helperSideView.frame) / 2, CGRectGetHeight(_keyWindow.frame) / 2);
    }
                     completion:^(BOOL finished)
    {
        [self finishAnimation];
    }];
    
    _triggered = NO;
}

- (void)beforeAnimation
{
    if (!_displayLink)
    {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    self.animationCount++;
}

- (void)finishAnimation
{
    self.animationCount--;
    if (self.animationCount == 0)
    {
        [_displayLink invalidate];
        self.displayLink = nil;
    }
}

- (void)displayLinkAction:(CADisplayLink *)dis
{
    CALayer *sideHelperPresentationLayer = (CALayer *)[_helperSideView.layer presentationLayer];
    CALayer *centerHelperPresentationLayer = (CALayer *)[_helperCenterView.layer presentationLayer];
    
    CGRect centerRect = [[centerHelperPresentationLayer valueForKeyPath:@"frame"] CGRectValue];
    CGRect sideRect = [[sideHelperPresentationLayer valueForKeyPath:@"frame"] CGRectValue];
    
    _diff = sideRect.origin.x - centerRect.origin.x;
    [self setNeedsDisplay];
}

@end
