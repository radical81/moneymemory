//
//  ViewController.m
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 16/9/13.
//  Copyright (c) 2013 Rex Jason Alobba. All rights reserved.
//

#import "ViewController.h"
#import "RunTestCoreData.h"
#import "SpendMoneyViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"This is money memory");
    RunTestCoreData* rc = [[RunTestCoreData alloc]init];
    //[rc runTestData];
    [rc release];
    
}

-(IBAction)spendButtonClicked:(id)sender {
    SpendMoneyViewController* spendMoneyViewController = [[SpendMoneyViewController alloc]initWithNibName:@"SpendMoneyViewController" bundle:nil];
    [self.navigationController pushViewController:spendMoneyViewController animated:YES];
    [spendMoneyViewController release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_spendButton release];
    [super dealloc];
}
@end
