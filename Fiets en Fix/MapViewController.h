//
//  ViewController.h
//  Fiets en Fix
//
//  Created by George Kyriacou on 1/22/14.
//  Copyright (c) 2014 George Kyriacou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Annotation.h"
#import "LocationController.h"

@interface MapViewController : UIViewController <MKMapViewDelegate,LocationControllerDelegate, UIAlertViewDelegate> {
    
    MKMapView *myMapView;
    
//    UIButton *findMeButton;
    
    NSArray *placesArray;
    
    LocationController* locationController;
    CLLocation *myLocation;
    
    NSDictionary *nextPageToken;
    
    UIActivityIndicatorView *activityIndicator;
    
}

@property(nonatomic, copy) NSArray *placesArray;
@property(nonatomic, strong) MKMapView *myMapView;
@property (nonatomic, assign) NSInteger radi;

// -(void)calculateDistance:(double)longi withArg2:(double)lati;

@end


