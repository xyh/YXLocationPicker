//
//  YXViewController.m
//  YXLocationPicker
//
//  Created by xuyuhang on 11/28/12.
//  Copyright (c) 2012 me.xuyuhang. All rights reserved.
//

#import "YXViewController.h"
#import "YXLocationPickerViewController.h"

@interface YXViewController ()

@end

@implementation YXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pickLocationButtonClicked:(id)sender {
    YXLocationPickerViewController *locationPicker = [[YXLocationPickerViewController alloc] init];
    
    [locationPicker setCancelBlock:^{
        NSLog(@"Picking location cancelled!");
    }];
    
    [locationPicker setCompletionBlock:^(BOOL succeeded, NSDictionary *info) {
        if (succeeded) {
            NSLog(@"Picking location succeeded!");
        }
        else
        {
            NSLog(@"Picking location failed!");
        }
    }];
    
    [self presentViewController:locationPicker animated:YES completion:nil];
}
@end
