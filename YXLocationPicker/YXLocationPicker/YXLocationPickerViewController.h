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
#import <CoreLocation/CoreLocation.h>
#import "AFJSONRequestOperation.h"
#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>

#define GOOGLE_V3_API_KEY @"AIzaSyC0l97FTm4Nc91OC2Js_sq3RM70GbHN0V0"
#define MAP_VIEW_SPAN_WIDTH 200

// current location button
#define CURRENT_LOCATION_BUTTON_X 6
#define CURRENT_LOCATION_BUTTON_Y 6
#define CURRENT_LOCATION_BUTTON_W 40
#define CURRENT_LOCATION_BUTTON_H 40
#define CURRENT_LOCATION_BUTTON_FRAME CGRectMake(CURRENT_LOCATION_BUTTON_X, CURRENT_LOCATION_BUTTON_Y, CURRENT_LOCATION_BUTTON_W, CURRENT_LOCATION_BUTTON_H)

#define CURRENT_LOCATION_BUTTON_IMAGE_PADDING 5
#define CURRENT_LOCATION_BUTTON_IMAGE_EDGE_INSET UIEdgeInsetsMake(CURRENT_LOCATION_BUTTON_IMAGE_PADDING, CURRENT_LOCATION_BUTTON_IMAGE_PADDING, CURRENT_LOCATION_BUTTON_IMAGE_PADDING, CURRENT_LOCATION_BUTTON_IMAGE_PADDING)

// text field
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

// result view
#define RESULT_VIEW_W ([UIScreen mainScreen].bounds.size.width)
#define RESULT_VIEW_H 50
#define RESULT_VIEW_X 0
#define RESULT_VIEW_Y ([UIScreen mainScreen].bounds.size.height-20-44-RESULT_VIEW_H)
#define RESULT_VIEW_FRAME CGRectMake(RESULT_VIEW_X, RESULT_VIEW_Y, RESULT_VIEW_W, RESULT_VIEW_H)

// address table
#define ADDRESS_TABLE_BACKGROUND_W ([UIScreen mainScreen].bounds.size.width)
#define ADDRESS_TABLE_BACKGROUND_H 152
#define ADDRESS_TABLE_BACKGROUND_X 0
#define ADDRESS_TABLE_BACKGROUND_Y (RESULT_VIEW_Y-ADDRESS_TABLE_BACKGROUND_H)

#define ADDRESS_TABLE_BACKGROUND_FRAME CGRectMake(ADDRESS_TABLE_BACKGROUND_X, ADDRESS_TABLE_BACKGROUND_Y, ADDRESS_TABLE_BACKGROUND_W, ADDRESS_TABLE_BACKGROUND_H)
#define ADDRESS_TABLE_BACKGROUND_FRAME_UP CGRectMake(ADDRESS_TABLE_BACKGROUND_X, CURRENT_LOCATION_BUTTON_Y+CURRENT_LOCATION_BUTTON_H+10, ADDRESS_TABLE_BACKGROUND_W, ADDRESS_TABLE_BACKGROUND_H)

#define ADDRESS_TABLE_X 0
#define ADDRESS_TABLE_Y 0
#define ADDRESS_TABLE_W ADDRESS_TABLE_BACKGROUND_W
#define ADDRESS_TABLE_H (ADDRESS_TABLE_BACKGROUND_H-ADDRESS_TABLE_Y)
#define ADDRESS_TABLE_FRAME CGRectMake(ADDRESS_TABLE_X, ADDRESS_TABLE_Y, ADDRESS_TABLE_W, ADDRESS_TABLE_H)

// map view
#define MAP_VIEW_X 0
#define MAP_VIEW_Y 0
#define MAP_VIEW_W ([UIScreen mainScreen].bounds.size.width)
#define MAP_VIEW_H ([UIScreen mainScreen].bounds.size.height-20-44-RESULT_VIEW_H-ADDRESS_TABLE_BACKGROUND_H)
#define MAP_VIEW_FRAME CGRectMake(MAP_VIEW_X, MAP_VIEW_Y, MAP_VIEW_W, MAP_VIEW_H)



typedef void (^YXLocationPickerCompletionBlock)(BOOL succeeded, NSDictionary *info);
typedef void (^YXLocationPickerCancelBlock)(void);

@interface YXLocationPickerViewController : UIViewController <MKMapViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, strong) UINavigationController *navigationController;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *currentLocationButtonImageName;

@property (nonatomic, strong) UIButton *currentLocationButton;
@property (nonatomic, strong) UITextField *addressTextField;
@property (nonatomic, strong) UIView *addressTextFieldBackgroundView;
//@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UITableView *addressTable;
@property (nonatomic, strong) UIView *addressTableBackgroundView;
@property (nonatomic, strong) UIView *resultView;

@property (nonatomic, strong) NSArray *suggestArray;
@property (nonatomic) double resultLat;
@property (nonatomic) double resultLng;
@property (nonatomic) BOOL resultChoosen;

@property (nonatomic, strong) CLGeocoder *geoCoder;
@property (nonatomic, strong) AFJSONRequestOperation *operation;

- (UINavigationItem *)navigationItem;

- (void)setCompletionBlock:(YXLocationPickerCompletionBlock)completionBlock;
- (void)setCancelBlock:(YXLocationPickerCancelBlock)cancelBlock;

@end
