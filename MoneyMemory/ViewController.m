//
//  ViewController.m
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 16/9/13.
//  Copyright (c) 2013 Rex Jason Alobba. All rights reserved.
//

#import "ViewController.h"
#import "CoreDataManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"This is money memory");
    CoreDataManager* coreDataManager = [[CoreDataManager alloc]init];
    [coreDataManager release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
