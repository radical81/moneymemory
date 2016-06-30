//
//  DesignHelper.m
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 28/6/16.
//  Copyright © 2016 Rex Jason Alobba. All rights reserved.
//

#import "DesignHelper.h"

@implementation DesignHelper

-(UIImage*)addBackgroundByScreenSize:(NSString*)imageName {
    if([UIScreen mainScreen].bounds.size.height == 480) {
        NSLog(@"iPhone 4");
        return [UIImage imageNamed:[NSString stringWithFormat: @"%@640x960.png", imageName]];
    }
    if([UIScreen mainScreen].bounds.size.height == 568) {
        NSLog(@"iPhone 5");
        return [UIImage imageNamed: [NSString stringWithFormat: @"%@640x1136.png", imageName]];
        
    }
    if([UIScreen mainScreen].bounds.size.height == 667) {
        NSLog(@"iPhone 6");
        return [UIImage imageNamed: [NSString stringWithFormat: @"%@750x1334.png", imageName]];
    }
    if([UIScreen mainScreen].bounds.size.height == 736) {
        NSLog(@"iPhone 6 Plus");
        return [UIImage imageNamed: [NSString stringWithFormat: @"%@1242x2208.png", imageName]];
    }
    NSLog(@"iPhone");
    return [UIImage imageNamed: [NSString stringWithFormat: @"%@320x480", imageName]];
}


@end
