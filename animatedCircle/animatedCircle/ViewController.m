//
//  ViewController.m
//  animatedCircle
//
//  Created by Zane on 15/10/14.
//  Copyright © 2015年 Zane. All rights reserved.
//

#import "ViewController.h"

#import <Masonry.h>
#import "CircleView.h"

@interface ViewController ()

@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, strong) UILabel *currentValueLabel;

@property (nonatomic, strong) CircleView *circleView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.slider];
    [self.view addSubview:self.currentValueLabel];
    [self.view addSubview:self.circleView];
    [self initialConstraints];
}

- (void)initialConstraints
{
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-50);
        make.size.mas_equalTo(CGSizeMake(200, 10));
    }];
    
    [self.currentValueLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.slider.mas_top).offset(-15);
        make.size.mas_equalTo(CGSizeMake(300, 21));
    }];
}

#pragma mark - UISlider Action
- (void)valueChanged:(UISlider *)sender
{
    [self.currentValueLabel setText:[NSString stringWithFormat:@"Current Value:   %@",@(self.slider.value)]];
    self.circleView.circleLayer.progress = sender.value;
}

#pragma mark - Getter
- (UISlider *)slider
{
    if (!_slider)
    {
        _slider = [[UISlider alloc] initWithFrame:CGRectZero];
        _slider.value = .5f;
        [_slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

- (UILabel *)currentValueLabel
{
    if (!_currentValueLabel)
    {
        _currentValueLabel = [[UILabel alloc] init];
        [_currentValueLabel setTextAlignment:NSTextAlignmentCenter];
        [_currentValueLabel setText:[NSString stringWithFormat:@"Current Value:   %@",@(self.slider.value)]];
    }
    return _currentValueLabel;
}

- (CircleView *)circleView
{
    if (!_circleView)
    {
        _circleView = [[CircleView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 320/2, self.view.frame.size.height/2 - 320/2, 320, 320)];
        _circleView.circleLayer.progress = .5f;
    }
    return _circleView;
}

@end
