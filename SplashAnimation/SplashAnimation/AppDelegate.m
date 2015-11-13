//
//  AppDelegate.m
//  SplashAnimation
//
//  Created by Zane on 15/11/10.
//  Copyright © 2015年 Zane. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    [self.window setBackgroundColor:[UIColor colorWithRed:0.502 green:0.000 blue:0.000 alpha:1.000]];
    
    UINavigationController *navc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    [self.window setRootViewController:navc];
    
    //logo mask
    CALayer *maskLayer = [CALayer layer];
    maskLayer.contents = (id)[UIImage imageNamed:@"logo"].CGImage;
    maskLayer.position = navc.view.center;
    maskLayer.bounds = CGRectMake(0, 0, 60, 60);
    navc.view.layer.mask = maskLayer;
    
    //logo mask backgroundview
    UIView *maskBackgroundView = [[UIView alloc] initWithFrame:navc.view.bounds];
    [navc.view addSubview:maskBackgroundView];
    [navc.view bringSubviewToFront:maskBackgroundView];
    
    //logo mask animation
    CAKeyframeAnimation *logoMaskAnimation = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    logoMaskAnimation.duration = 1;
    logoMaskAnimation.beginTime = CACurrentMediaTime() + 1.0f;
    
    CGRect initialBounds = maskLayer.bounds;
    CGRect secondBounds = CGRectMake(0, 0, 50, 50);
    CGRect finalBounds = CGRectMake(0, 0, 2000,2000);//CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
    
    logoMaskAnimation.values = @[[NSValue valueWithCGRect:initialBounds],[NSValue valueWithCGRect:secondBounds],[NSValue valueWithCGRect:finalBounds]];
    logoMaskAnimation.keyTimes = @[@0, @.5, @1];logoMaskAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    logoMaskAnimation.removedOnCompletion = NO;
    logoMaskAnimation.fillMode = kCAFillModeForwards;
    [navc.view.layer.mask addAnimation:logoMaskAnimation forKey:@"logoMaskAnimation"];
    
    //nav.view bounce animation
    [UIView animateWithDuration:.1 delay:1.35 options:UIViewAnimationOptionCurveEaseIn animations:^
    {
        maskBackgroundView.alpha = 0;
    }
                              completion:^(BOOL finished)
    {
        [maskBackgroundView removeFromSuperview];
    }];
    
    [UIView animateWithDuration:.25 delay:1.3 options:UIViewAnimationOptionTransitionNone animations:^
    {
        navc.view.transform = CGAffineTransformMakeScale(1.05, 1.05);
    }
                     completion:^(BOOL finished)
    {
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^
        {
            navc.view.transform = CGAffineTransformIdentity;
        }
                         completion:^(BOOL finished)
        {
            navc.view.layer.mask = nil;
        }];
    }];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
