//
//  UILabel+boldify.m
//  Ubinect
//
//  Created by iKick on 20/06/2014.
//  Copyright (c) 2014 Roger Ingouacka. All rights reserved.
//

#import "UINavigationController+Fade.h"


@implementation UINavigationController (Fade)

- (void)pushFadeViewController:(UIViewController *)viewController
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.view.layer addAnimation:transition forKey:nil];
    
    [self pushViewController:viewController animated:NO];
}

- (void)fadePopViewController
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.view.layer addAnimation:transition forKey:nil];
    [self popViewControllerAnimated:NO];
}

@end