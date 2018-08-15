//
//  MYTMapScreenViewModel.h
//  MYTPoC
//
//  Created by Mukesh on 27/05/18.
//  Copyright © 2018 com.murugananda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@class CodableContainer;

@protocol MapScreenDelegate <NSObject>

- (void)showCamera:(CLLocation *)location;
- (void)showAlert;
- (void)plotMarkers: (CodableContainer *) response;
- (void)updateMarkers;

@end

@interface MYTMapScreenViewModel : NSObject <CLLocationManagerDelegate, GMSMapViewDelegate>

@property (weak, nonatomic) id <MapScreenDelegate> customDelegate;
@property (nonatomic, assign) BOOL isDragged;

- (void)initiateLocation;
- (void)getVehicleDetails:(GMSCoordinateBounds *)bounds;

@end
