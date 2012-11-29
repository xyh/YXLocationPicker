//
//  YXLocationPickerViewController.m
//  YXLocationPicker
//
//  Created by xuyuhang on 11/28/12.
//  Copyright (c) 2012 me.xuyuhang. All rights reserved.
//

#import "YXLocationPickerViewController.h"

@interface YXLocationPickerViewController ()
{
    YXLocationPickerCompletionBlock _completionBlock;
    YXLocationPickerCancelBlock _cancelBlock;
}

@end

@implementation YXLocationPickerViewController

- (id)init
{
    
    
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"Location";
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.rootViewController = [[UIViewController alloc] init];
    [self.rootViewController.view setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.rootViewController];
    self.navigationController.view.frame = self.view.bounds;
    
    [self.view addSubview:self.navigationController.view];
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                         target:self
                                                                         action:@selector(doneItemClicked:)];
    [[self navigationItem] setRightBarButtonItem:doneItem];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                target:self
                                                                                action:@selector(cancelButtonClicked:)];
    [[self navigationItem] setLeftBarButtonItem:cancelItem];
    [[self navigationItem] setTitle:self.title];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCompletionBlock:(YXLocationPickerCompletionBlock)completionBlock
{
    _completionBlock = completionBlock;
}

- (UINavigationItem *)navigationItem
{
    return self.rootViewController.navigationItem;
}

- (void)setCancelBlock:(YXLocationPickerCancelBlock)cancelBlock
{
    _cancelBlock = cancelBlock;
}

- (void)cancelButtonClicked:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:^{
        _cancelBlock();
    }];
}

- (void)doneItemClicked:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:^{
        _completionBlock(NO, nil);
    }];
}

@end
