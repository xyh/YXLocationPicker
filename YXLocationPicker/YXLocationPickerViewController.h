//
//  YXLocationPickerViewController.h
//  YXLocationPicker
//
//  Created by xuyuhang on 11/28/12.
//  Copyright (c) 2012 me.xuyuhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^YXLocationPickerCompletionBlock)(BOOL succeeded, NSDictionary *info);
typedef void (^YXLocationPickerCancelBlock)(void);

@interface YXLocationPickerViewController : UIViewController

@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, strong) UINavigationController *navigationController;

@property (nonatomic, copy) NSString *title;

- (UINavigationItem *)navigationItem;

- (void)setCompletionBlock:(YXLocationPickerCompletionBlock)completionBlock;
- (void)setCancelBlock:(YXLocationPickerCancelBlock)cancelBlock;

@end
