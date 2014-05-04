//
//  LocationController.m
//  Fiets en Fix
//
//  Created by George Kyriacou on 3/15/14.
//  Copyright (c) 2014 George Kyriacou. All rights reserved.
//

#import "LocationController.h"


@implementation LocationController
@synthesize locationManager, location, delegate;


- (id)init
{
    self = [super init];
    if (self != nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return self;
}


#pragma mark -
#pragma mark CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager*)manager
    didUpdateToLocation:(CLLocation*)newLocation
           fromLocation:(CLLocation*)oldLocation
{
//    self.dblLatitude = newLocation.coordinate.latitude;
//    self.dblLongitude =newLocation.coordinate.longitude;
    
    [self.delegate locationUpdate:newLocation];
}



- (void)locationManager:(CLLocationManager*)manager
       didFailWithError:(NSError*)error
{
    [manager stopUpdatingLocation];
    NSLog(@"error %@", error);
    
    
    switch ([error code]) {
            
        case kCLErrorNetwork:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please check your network connection" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
            
        case kCLErrorDenied:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"User has denied to use current location" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
            [alert show];
        }
            break;
            
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unknown Network Error" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
            [alert show];
            
        }
            break;
    }
    
}



-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    
    if (status == kCLAuthorizationStatusDenied) {
        
        // location denied, handle accordingly
        NSLog(@"Denied");
        [self.delegate changeAuthorizationStatus:status];
    }
    
    else if (status == kCLAuthorizationStatusAuthorized) {
        
        NSLog(@"Authorized");
        [self.delegate changeAuthorizationStatus:status];
    }
    
    
}


#pragma mark - Singleton implementation in ARC

+ (LocationController *) sharedLocationController

{
    static LocationController *sharedLocationControllerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedLocationControllerInstance = [[self alloc] init];
    });
    return sharedLocationControllerInstance;
}


@end
