//
//  ListViewController.h
//  Fiets en Fix
//
//  Created by George Kyriacou on 2/1/14.
//  Copyright (c) 2014 George Kyriacou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LocationController.h"

#define kGOOGLE_API_KEY @"AIzaSyD4fkk16M0M_TOKnRRaApDWg1tkQ3tSzFo"


@interface ListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,LocationControllerDelegate> {
    
    UITableView *myTableView;
    NSDictionary *tempDictionary;
    NSDictionary *nextPageToken;
    
    LocationController* locationController;
    
    CLLocation *myCurrentLocation;
    CLLocationDegrees latitude;
    CLLocationDegrees longitude;
    
    UIActivityIndicatorView *activityIndicator;
    
}

@property (nonatomic, copy) NSArray *googlePlacesArrayFromAFNetworking;
@property (nonatomic, copy) NSMutableArray *placesDistance;
@property (nonatomic, copy) UITableView *myTableView;
@property (nonatomic, strong) NSDictionary *tempDictionary;

@property (nonatomic, assign) NSInteger rad;
@end
