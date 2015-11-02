//
//  GooeySlideMenu.h
//  GooeySlide
//
//  Created by Zane on 15/10/28.
//  Copyright © 2015年 Zane. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MenuButtonClickedBlock)(NSUInteger index, NSString *title, NSUInteger titleCounts);

@interface GooeySlideMenu : UIView

@property (nonatomic, assign) CGFloat menuButtonHeight;

@property (nonatomic, copy) MenuButtonClickedBlock menuClickBlock;

- (instancetype)initWithTitles:(NSArray *)titles;

- (instancetype)initWithTitles:(NSArray *)titles buttonHeight:(CGFloat)height menuColor:(UIColor *)menuColor backBlurStyle:(UIBlurEffectStyle)style;

- (void)trigger;

@end
