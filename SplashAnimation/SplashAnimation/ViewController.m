//
//  ViewController.m
//  SplashAnimation
//
//  Created by Zane on 15/11/10.
//  Copyright © 2015年 Zane. All rights reserved.
//

#import "ViewController.h"

#import <Masonry/Masonry.h>

@interface ViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"首页";
    [self.view addSubview:self.backgroundImageView];
    [self initialConstraints];
}

- (void)initialConstraints
{
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.edges.equalTo(self.view);
    }];
}


#pragma mark - Getter
- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView)
    {
        _backgroundImageView = [[UIImageView alloc] init];
        [_backgroundImageView setContentMode:UIViewContentModeScaleAspectFit];
        [_backgroundImageView setImage:[UIImage imageNamed:@"home_demo"]];
    }
    return _backgroundImageView;
}

@end
