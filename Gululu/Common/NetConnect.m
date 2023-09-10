//
//  NetConnect.m
//  Gululu
//
//  Created by baker on 2017/11/17.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

#import "NetConnect.h"

@implementation NetConnect

+ (BOOL)isVPNConnected {
    UIApplication *app = [UIApplication sharedApplication];
    UIView *statusView = [app valueForKey:@"statusBar"];
    NSArray *subViews = [[statusView valueForKey:@"foregroundView"] subviews];
    
    Class StatusBarIndicatorItemViewClass = NSClassFromString(@"UIStatusBarIndicatorItemView");
    for (UIView *subView in subViews) {
        Class SubStatusBarIndicatorItemViewClass = [subView class];
        if ([SubStatusBarIndicatorItemViewClass isSubclassOfClass:StatusBarIndicatorItemViewClass]) {
            return [[subView valueForKey:@"_visible"] boolValue];
        }
    }
    return NO;
}

+ (BOOL)isVPNConnected_VPN {
    UIApplication *app = [UIApplication sharedApplication];
    UIView *statusView = [app valueForKey:@"statusBar"];
    NSArray *subViews = [[statusView valueForKey:@"foregroundView"] subviews];
    
    BOOL isHaveVpn = NO;
    for (UIView *subView in subViews) {
        if ([[subView description] containsString:@"VPN"]){
            isHaveVpn = YES;
        }
    }
    return isHaveVpn;
}


@end
