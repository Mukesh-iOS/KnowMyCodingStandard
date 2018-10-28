//
//  MYTMapScreenViewModel.m
//  MYTPoC
//
//  Created by Mukesh on 27/05/18.
//  Copyright © 2018 com.murugananda. All rights reserved.
//

#import "MYTMapScreenViewModel.h"
#import <MYTPoC-Swift.h>

@interface MYTMapScreenViewModel ()
    
@property (nonatomic, strong) CLLocationManager *currentLocationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
    
@end

@implementation MYTMapScreenViewModel

#pragma mark - Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {

        [self.customDelegate showAlert];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations.lastObject;
    
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    
    if (newLocation.horizontalAccuracy < 0) return;
    
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:self.currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    double distance = [loc1 distanceFromLocation:loc2];
    self.currentLocation = newLocation;
    
    if(distance > 20) {
        [self.customDelegate showCamera:self.currentLocation];
    }
}

#pragma mark - Helper Methods

- (void)initiateLocation {
    self.currentLocationManager = [CLLocationManager new];
    self.currentLocationManager.delegate = self;
    
    [self.currentLocationManager requestAlwaysAuthorization];
    
    [self.currentLocationManager setPausesLocationUpdatesAutomatically:YES];
    self.currentLocationManager.distanceFilter = kCLDistanceFilterNone;
    self.currentLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [self.currentLocationManager startUpdatingLocation];
}

- (void)getVehicleDetails:(GMSCoordinateBounds *)bounds {
    CLLocationCoordinate2D northEast = bounds.northEast;
    CLLocationCoordinate2D northWest = CLLocationCoordinate2DMake(bounds.northEast.latitude, bounds.southWest.longitude);
    CLLocationCoordinate2D southEast = CLLocationCoordinate2DMake(bounds.southWest.latitude, bounds.northEast.longitude);
    CLLocationCoordinate2D  southWest = bounds.southWest;
    
    MYTModel *webEngine = [MYTModel new];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:[[NSNumber numberWithDouble:northEast.latitude] stringValue] forKey:@"p1Lat"];
    [params setValue:[[NSNumber numberWithDouble:northEast.longitude] stringValue] forKey:@"p1Lon"];
    [params setValue:[[NSNumber numberWithDouble:northWest.latitude] stringValue] forKey:@"p2Lat"];
    [params setValue:[[NSNumber numberWithDouble:northWest.longitude] stringValue] forKey:@"p2Lon"];
    [params setValue:[[NSNumber numberWithDouble:southEast.latitude] stringValue] forKey:@"p3Lat"];
    [params setValue:[[NSNumber numberWithDouble:southEast.longitude] stringValue] forKey:@"p3Lon"];
    [params setValue:[[NSNumber numberWithDouble:southWest.latitude] stringValue] forKey:@"p4Lat"];
    [params setValue:[[NSNumber numberWithDouble:southWest.longitude] stringValue] forKey:@"p4Lon"];
    
    [webEngine getListDetailsFromRestWithParameter:params withSuccess:^(CodableContainer * response, NSString * userInfo) {

        [self.customDelegate plotMarkers:response];
        
    } withFail:^(NSError * err, NSString * userInfo) {
       
        NSLog(@"%@", err.localizedDescription);
    }];
}

#pragma mark - MapView Delegate

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    self.isDragged = NO;
    return NO;
}

-(void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position {
    if (self.isDragged) {
        [self.customDelegate updateMarkers];
    }
    self.isDragged = YES;
}

@end
