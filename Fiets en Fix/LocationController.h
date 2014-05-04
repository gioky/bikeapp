//
//  LocationController.h
//  Fiets en Fix
//
//  Created by George Kyriacou on 3/15/14.
//  Copyright (c) 2014 George Kyriacou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


// protocol for sending location updates to another view controller
@protocol LocationControllerDelegate

//@required

-(void)locationUpdate:(CLLocation *)location;
-(void)changeAuthorizationStatus:(CLAuthorizationStatus)status;

@end



@interface LocationController : NSObject <CLLocationManagerDelegate> {
    
    CLLocationManager* locationManager;
    CLLocation* location;
    __weak id delegate;
  
}

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLLocation* location;
@property (nonatomic, weak) id  delegate;
/*
@property (nonatomic, assign) double dblLatitude;
@property (nonatomic, assign) double dblLongitude; */

+ (LocationController *) sharedLocationController; // Singleton method


@end
