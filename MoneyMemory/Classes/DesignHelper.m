//
//  DesignHelper.m
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 28/6/16.
//  Copyright © 2016 Rex Jason Alobba. All rights reserved.
//

#import "DesignHelper.h"

@implementation DesignHelper

-(UIImage*)addBackgroundByScreenSize {
    if([UIScreen mainScreen].bounds.size.height == 480) {
        NSLog(@"iPhone 4");
        return [UIImage imageNamed:@"background640x960.png"];
    }
    if([UIScreen mainScreen].bounds.size.height == 568) {
        NSLog(@"iPhone 5");
        return [UIImage imageNamed:@"background640x1136.png"];
        
    }
    if([UIScreen mainScreen].bounds.size.height == 667) {
        NSLog(@"iPhone 6");
        return [UIImage imageNamed:@"background750x1334.png"];
    }
    if([UIScreen mainScreen].bounds.size.height == 736) {
        NSLog(@"iPhone 6 Plus");
        return [UIImage imageNamed:@"background1242x2208.png"];
    }
    NSLog(@"iPhone");
    return [UIImage imageNamed:@"background320x480"];
}


@end
