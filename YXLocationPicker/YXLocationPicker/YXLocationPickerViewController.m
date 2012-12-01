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
        self.resultChoosen = NO;
        self.suggestArray = [NSArray array];
        self.geoCoder = [[CLGeocoder alloc] init];
        
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
    self.addressTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.addressTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.addressTextField.autocorrectionType = UITextAutocorrectionTypeNo;
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
    
    // address names table
    self.addressTableBackgroundView = [[UIView alloc] initWithFrame:ADDRESS_TABLE_BACKGROUND_FRAME];
    self.addressTableBackgroundView.backgroundColor = [UIColor whiteColor];
    self.addressTableBackgroundView.layer.shadowColor = [UIColor colorWithWhite:0.12 alpha:1].CGColor;
    self.addressTableBackgroundView.layer.shadowOffset = CGSizeMake(0, 0.5);
    self.addressTableBackgroundView.layer.shadowRadius = 1;
    self.addressTableBackgroundView.layer.shadowOpacity = 1;
    [self.rootViewController.view addSubview:self.addressTableBackgroundView];
    
    self.addressTable = [[UITableView alloc] initWithFrame:ADDRESS_TABLE_FRAME style:UITableViewStylePlain];
    self.addressTable.delegate = self;
    self.addressTable.dataSource = self;
    [self.addressTableBackgroundView addSubview:self.addressTable];
    
    // result view
    self.resultView = [[UIView alloc] initWithFrame:RESULT_VIEW_FRAME];
    self.resultView.backgroundColor = [UIColor colorWithRed:1.0f green:0.984f blue:0.941 alpha:1];
    self.resultView.layer.shadowColor = [UIColor colorWithWhite:0.12 alpha:1].CGColor;
    self.resultView.layer.shadowOffset = CGSizeMake(0, 0.5);
    self.resultView.layer.shadowRadius = 1;
    self.resultView.layer.shadowOpacity = 1;
    [self.rootViewController.view addSubview:self.resultView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
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



#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (_isFirstTimeUpdateUserLocation) {
        _isFirstTimeUpdateUserLocation = NO;
        CLLocationCoordinate2D center = userLocation.location.coordinate;
        [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(center, 200, 200) animated:YES];
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self.addressTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self.suggestArray count] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.addressTextField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *oldText = [textField text];
    NSString *newText = [oldText stringByReplacingCharactersInRange:range withString:string];
    
    // if text is empty, clear suggest list
    if ([newText isEqualToString:@""]) {
        self.suggestArray = [NSArray array];
        [[self addressTable] reloadData];
        return YES;
    }
    
    // update suggest list
    [self predictUncompletedAddress:newText];
    
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + [self.suggestArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXAddressTableCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"YXAddressTableCell"];
    }
    
    cell.detailTextLabel.text = nil;
    cell.textLabel.font = [UIFont fontWithName:@"Helvatica" size:10];
    if (indexPath.row == [self.suggestArray count]) {
        cell.textLabel.text = @"Use Pin on the Map";
        CLLocationCoordinate2D currentFocusedCoordinate = self.mapView.centerCoordinate;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%f, %f", currentFocusedCoordinate.latitude, currentFocusedCoordinate.longitude];
    }
    else {
        id place = [self.suggestArray objectAtIndex:indexPath.row];
        NSString *addressString = [place objectForKey:@"description"];
        cell.textLabel.text = addressString;
        NSRange range = [addressString rangeOfString:@", " options:NSBackwardsSearch];
        int index = range.location;
        
        if (index != NSNotFound) {
            NSString *countryString = [addressString substringFromIndex:index+1];
            countryString = [countryString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            cell.detailTextLabel.text = countryString;
        }
        
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%@", [tableView cellForRowAtIndexPath:indexPath].textLabel.text);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.addressTextField resignFirstResponder];
    
    if (indexPath.row < [self.suggestArray count]) {
        id place = [self.suggestArray objectAtIndex:indexPath.row];
        NSString * addressString = [place objectForKey:@"description"];
        
        [self searchAddressString:addressString]; 
    }
    else {
        CLLocationCoordinate2D currentFocusedCoordinate = self.mapView.centerCoordinate;
        [self focusOnLocation:currentFocusedCoordinate];
    }
    
}

#pragma mark - Keyboard notification
-(void) keyboardWasShown:(NSNotification*)aNotification
{ 
    NSDictionary* info = [aNotification userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    self.addressTableBackgroundView.frame = ADDRESS_TABLE_BACKGROUND_FRAME_UP;
    
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification*)aNotification
{     
    NSDictionary* info = [aNotification userInfo];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    self.addressTableBackgroundView.frame = ADDRESS_TABLE_BACKGROUND_FRAME;
    
    [UIView commitAnimations];
}


#pragma mark - helpers

- (void)predictUncompletedAddress:(NSString *)addressString
{
	// Forward geocode!
    CLLocationCoordinate2D location = [self.mapView userLocation].location.coordinate;
    NSString *formattedAddressString = [self validizeAddressStringForGoogleAPI:addressString];
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=geocode&location=%f,%f&radius=200000&sensor=false&key=%@", formattedAddressString, location.latitude, location.longitude, GOOGLE_V3_API_KEY];
    //NSLog(@"%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([[JSON objectForKey:@"status"] isEqual:@"OK"]) {
            self.suggestArray = [JSON objectForKey:@"predictions"];
            [self.addressTable reloadData];
        }
    } failure:nil];
    [self.operation start];
    
}

- (void)searchAddressString:(NSString *)addressString
{
//    NSString *formattedAddressString = [self validizeAddressStringForGoogleAPI:addressString];
    if (!self.geoCoder) {
        self.geoCoder = [[CLGeocoder alloc] init];
    }
    
    [self.geoCoder geocodeAddressString:addressString completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error && [placemarks count] > 0) {
            CLPlacemark *place = [placemarks objectAtIndex:0];
//            NSString *placeString = ABCreateStringWithAddressDictionary(place.addressDictionary, YES);
            self.resultLat = place.location.coordinate.latitude;
            self.resultLng = place.location.coordinate.longitude;
            
            [self focusOnLocation:place.location.coordinate];
            
        }
    }];
    
}

- (void)focusOnLocation:(CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D center = coordinate;
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(center, MAP_VIEW_SPAN_WIDTH, MAP_VIEW_SPAN_WIDTH) animated:YES];
}

- (NSString *)validizeAddressStringForGoogleAPI:(NSString *)originalString
{
    NSString *formattedAddressString = [originalString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    formattedAddressString = [formattedAddressString stringByReplacingOccurrencesOfString:@"/" withString:@""];
    formattedAddressString = [formattedAddressString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    formattedAddressString = [formattedAddressString stringByReplacingOccurrencesOfString:@"&" withString:@""];
    formattedAddressString = [formattedAddressString stringByReplacingOccurrencesOfString:@"?" withString:@""];
    return formattedAddressString;
}

@end
