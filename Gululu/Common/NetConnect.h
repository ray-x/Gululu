//
//  NetConnect.h
//  Gululu
//
//  Created by baker on 2017/11/17.
//  Copyright © 2017年 Ray Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NetConnect : NSObject

+ (BOOL)isVPNConnected;
+ (BOOL)isVPNConnected_VPN;

@end
