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
    
    BOOL _isFirstTimeUpdateUserLocation;
}

@end

@implementation YXLocationPickerViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"Location";
        self.currentLocationButtonImageName = @"current-location-icon.png";
        _isFirstTimeUpdateUserLocation = YES;
        
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
    
    // navigation bar
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                         target:self
                                                                         action:@selector(doneItemClicked:)];
    [[self navigationItem] setRightBarButtonItem:doneItem];
    
//    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
//                                                                                target:self
//                                                                                action:@selector(cancelButtonClicked:)];
//    [[self navigationItem] setLeftBarButtonItem:cancelItem];
    [[self navigationItem] setTitle:self.title];
    
    // current location button
    self.currentLocationButton = [[UIButton alloc] initWithFrame:CURRENT_LOCATION_BUTTON_FRAME];
    [self.currentLocationButton setImage:[UIImage imageNamed:self.currentLocationButtonImageName] forState:UIControlStateNormal];
    self.currentLocationButton.imageEdgeInsets = CURRENT_LOCATION_BUTTON_IMAGE_EDGE_INSET;
    self.currentLocationButton.backgroundColor = [UIColor whiteColor];
    self.currentLocationButton.layer.shadowColor = [UIColor colorWithWhite:0.12 alpha:1].CGColor;
    self.currentLocationButton.layer.shadowOffset = CGSizeMake(0, 0.5);
    self.currentLocationButton.layer.shadowRadius = 1;
    self.currentLocationButton.layer.shadowOpacity = 1;
    [self.currentLocationButton setUserInteractionEnabled:YES];
    [self.currentLocationButton addTarget:self
                                   action:@selector(currentLocationButtonClicked:)
                         forControlEvents:UIControlEventTouchUpInside];
    [self.rootViewController.view addSubview:self.currentLocationButton];
    
    // address text field
    self.addressTextField = [[UITextField alloc] initWithFrame:ADDRESS_TEXT_FIELD_FRAME];
    self.addressTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 12, 18, 18)];
    imageView.image = [UIImage imageNamed:@"magnifying-glass.png"];
    self.addressTextField.leftView = imageView;
    self.addressTextField.placeholder = @"Enter an Address";
    self.addressTextFieldBackgroundView = [[UIView alloc] initWithFrame:ADDRESS_TEXT_FIELD_BACKGROUND_FRAME];
    [self.addressTextFieldBackgroundView addSubview:self.addressTextField];
    self.addressTextFieldBackgroundView.backgroundColor = [UIColor whiteColor];
    self.addressTextFieldBackgroundView.layer.shadowColor = [UIColor colorWithWhite:0.12 alpha:1].CGColor;
    self.addressTextFieldBackgroundView.layer.shadowOffset = CGSizeMake(0, 0.5);
    self.addressTextFieldBackgroundView.layer.shadowRadius = 1;
    self.addressTextFieldBackgroundView.layer.shadowOpacity = 1;
    [self.addressTextField setDelegate:self];
    [self.rootViewController.view addSubview:self.addressTextFieldBackgroundView];
    
    // map view
    self.mapView = [[MKMapView alloc] initWithFrame:MAP_VIEW_FRAME];
    [self.mapView setDelegate:self];
    [self.mapView setShowsUserLocation:YES];
    [self.rootViewController.view insertSubview:self.mapView atIndex:0];
    
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
//    [self.locationManager startUpdatingLocation];
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

- (void)currentLocationButtonClicked:(id)sender
{
    NSLog(@"Current address button is clicked!");
    if (!_isFirstTimeUpdateUserLocation) {
        MKUserLocation *userLocation = [self.mapView userLocation];
        CLLocationCoordinate2D center = userLocation.location.coordinate;
        [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(center, 200, 200) animated:YES];
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{

}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (_isFirstTimeUpdateUserLocation) {
        _isFirstTimeUpdateUserLocation = NO;
        CLLocationCoordinate2D center = userLocation.location.coordinate;
        [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(center, 200, 200) animated:YES];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.addressTextField resignFirstResponder];
    return YES;
}

#pragma mark - helpers


@end
