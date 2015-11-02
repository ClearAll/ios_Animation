//
//  SlideMenuButton.h
//  GooeySlide
//
//  Created by Zane on 15/10/28.
//  Copyright © 2015年 Zane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideMenuButton : UIView

@property (nonatomic, strong)  UIColor *buttonColor;

@property (nonatomic, copy) void(^buttonClickBlock)(void);

- (instancetype)initWithTitle:(NSString *)title;

@end
