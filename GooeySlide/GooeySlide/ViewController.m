//
//  ViewController.m
//  GooeySlide
//
//  Created by Zane on 15/10/28.
//  Copyright © 2015年 Zane. All rights reserved.
//

#import "ViewController.h"
#import "GooeySlideMenu.h"

@interface ViewController ()

@property (nonatomic, weak  ) IBOutlet UIButton *button;

@property (nonatomic, strong) GooeySlideMenu *menu;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.menu = [[GooeySlideMenu alloc] initWithTitles:@[@"首页",@"消息",@"发布",@"探索",@"个人",@"设置"]];
    self.menu.menuClickBlock = ^(NSUInteger index, NSString *title, NSUInteger titleCounts)
    {
        NSLog(@"idx = %ld \n title = %@ \n  titleCounts = %ld",index,title,titleCounts);
    };
}

- (IBAction)buttonTrigger:(id)sender
{
    [self.menu trigger];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
