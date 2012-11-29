//
//  YXLocationPickerViewController.h
//  YXLocationPicker
//
//  Created by xuyuhang on 11/28/12.
//  Copyright (c) 2012 me.xuyuhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>

#define CURRENT_LOCATION_BUTTON_X 6
#define CURRENT_LOCATION_BUTTON_Y 6
#define CURRENT_LOCATION_BUTTON_W 40
#define CURRENT_LOCATION_BUTTON_H 40
#define CURRENT_LOCATION_BUTTON_FRAME CGRectMake(CURRENT_LOCATION_BUTTON_X, CURRENT_LOCATION_BUTTON_Y, CURRENT_LOCATION_BUTTON_W, CURRENT_LOCATION_BUTTON_H)

#define CURRENT_LOCATION_BUTTON_IMAGE_PADDING 5
#define CURRENT_LOCATION_BUTTON_IMAGE_EDGE_INSET UIEdgeInsetsMake(CURRENT_LOCATION_BUTTON_IMAGE_PADDING, CURRENT_LOCATION_BUTTON_IMAGE_PADDING, CURRENT_LOCATION_BUTTON_IMAGE_PADDING, CURRENT_LOCATION_BUTTON_IMAGE_PADDING)

#define ADDRESS_TEXT_FIELD_BACKGROUND_X (CURRENT_LOCATION_BUTTON_X+CURRENT_LOCATION_BUTTON_W+10)
#define ADDRESS_TEXT_FIELD_BACKGROUND_Y CURRENT_LOCATION_BUTTON_Y
#define ADDRESS_TEXT_FIELD_BACKGROUND_W (320-ADDRESS_TEXT_FIELD_BACKGROUND_X-10)
#define ADDRESS_TEXT_FIELD_BACKGROUND_H CURRENT_LOCATION_BUTTON_H
#define ADDRESS_TEXT_FIELD_BACKGROUND_FRAME CGRectMake(ADDRESS_TEXT_FIELD_BACKGROUND_X, ADDRESS_TEXT_FIELD_BACKGROUND_Y, ADDRESS_TEXT_FIELD_BACKGROUND_W, ADDRESS_TEXT_FIELD_BACKGROUND_H)

#define ADDRESS_TEXT_FIELD_X 6
#define ADDRESS_TEXT_FIELD_Y 9
#define ADDRESS_TEXT_FIELD_W (ADDRESS_TEXT_FIELD_BACKGROUND_W-ADDRESS_TEXT_FIELD_X*2)
#define ADDRESS_TEXT_FIELD_H (ADDRESS_TEXT_FIELD_BACKGROUND_H-ADDRESS_TEXT_FIELD_Y*2+4)
#define ADDRESS_TEXT_FIELD_FRAME CGRectMake(ADDRESS_TEXT_FIELD_X, ADDRESS_TEXT_FIELD_Y, ADDRESS_TEXT_FIELD_W, ADDRESS_TEXT_FIELD_H)

#define MAP_VIEW_X 0
//#define MAP_VIEW_Y (CURRENT_LOCATION_BUTTON_Y+CURRENT_LOCATION_BUTTON_H+6)
#define MAP_VIEW_Y 0
#define MAP_VIEW_W 320
#define MAP_VIEW_H (200-MAP_VIEW_Y)
#define MAP_VIEW_FRAME CGRectMake(MAP_VIEW_X, MAP_VIEW_Y, MAP_VIEW_W, MAP_VIEW_H)

typedef void (^YXLocationPickerCompletionBlock)(BOOL succeeded, NSDictionary *info);
typedef void (^YXLocationPickerCancelBlock)(void);

@interface YXLocationPickerViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, strong) UINavigationController *navigationController;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *currentLocationButtonImageName;

@property (nonatomic, strong) UIButton *currentLocationButton;
@property (nonatomic, strong) UITextField *addressTextField;
@property (nonatomic, strong) UIView *addressTextFieldBackgroundView;
@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong) CLLocationManager *locationManager;

- (UINavigationItem *)navigationItem;

- (void)setCompletionBlock:(YXLocationPickerCompletionBlock)completionBlock;
- (void)setCancelBlock:(YXLocationPickerCancelBlock)cancelBlock;

@end
