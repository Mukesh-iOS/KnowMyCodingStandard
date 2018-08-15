//
//  MYTMapViewController.m
//  MYTPoC
//
//  Created by Mukesh on 27/05/18.
//  Copyright © 2018 com.murugananda. All rights reserved.
//

#import "MYTMapViewController.h"
#import <MYTPoC-Swift.h>

@interface MYTMapViewController ()<MapScreenDelegate>

@property (strong, nonatomic) IBOutlet GMSMapView *viewMap;

@end

@implementation MYTMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewSetup];
}

// MARK: Settingup Screen

- (void) viewSetup
{
    self.navigationItem.title = @"Map View";

    UIButton *backBtn = [self addNavigationButtonWithImage:[UIImage imageNamed:@"BackNavigation"] isBackButton:YES];
    [backBtn addTarget:self action:@selector(popScreen) forControlEvents:UIControlEventTouchUpInside];
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        self.mapScreenVM = [MYTMapScreenViewModel new];
        self.mapScreenVM.customDelegate = self;
        [self.mapScreenVM initiateLocation];
        
        self.viewMap.delegate = self.mapScreenVM;
        self.viewMap.myLocationEnabled =  YES;
        self.viewMap.settings.myLocationButton =  YES;
    }
}

// MARK: Showing Map Position For First Time

- (void)showCamera:(CLLocation *)location
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.coordinate.latitude
                                                            longitude:location.coordinate.longitude
                                                                 zoom:13];
    self.viewMap.camera = camera;
    
    // get current map view bound
    GMSVisibleRegion visibleRegion = [self.viewMap.projection visibleRegion];
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc]initWithRegion:visibleRegion];
    
    self.mapScreenVM.isDragged = NO;
    
    [self.mapScreenVM getVehicleDetails:bounds];
}

// MARK: Updating Markers When Bounds Change

- (void)updateMarkers
{
    // get current map view bound
    GMSVisibleRegion visibleRegion = [self.viewMap.projection visibleRegion];
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc]initWithRegion:visibleRegion];
    
    [self.mapScreenVM getVehicleDetails:bounds];
}

// MARK: Plotting Markers

- (void)plotMarkers: (CodableContainer *) response
{
    
    [self.viewMap clear];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:response.poiList[0].coordinate.latitude
                                    longitude:response.poiList[0].coordinate.longitude
                                         zoom:self.viewMap.camera.zoom];
    self.viewMap.camera = camera;
    
    self.mapScreenVM.isDragged = NO;
    
    for (lists *list in response.poiList) {
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(list.coordinate.latitude, list.coordinate.longitude);
        
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        marker.title = [NSString stringWithFormat:@"%@", [list.fleetType  isEqual: @"POOLING"] ? @"Pooling" : @"Taxi"];
        marker.appearAnimation = YES;
        marker.map = self.viewMap;
    }
}

// MARK: Helper Methods

- (void) popScreen
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showAlert
{
    UIAlertController *alertCont =[UIAlertController alertControllerWithTitle:@"Location Service Disabled" message:@"To re-enable, please go to Settings and turn on Location Service for this app." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
    [alertCont addAction:ok];
    [self presentViewController:alertCont animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
