//
//  PlaceDetailsViewController.h
//  Fiets en Fix
//
//  Created by George Kyriacou on 2/23/14.
//  Copyright (c) 2014 George Kyriacou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface PlaceDetailsViewController : UIViewController<MKMapViewDelegate, UIScrollViewDelegate> {
    
    MKMapView *detailMapView;

    UILabel *addressLabel;
    UILabel *shopLabel;
    
    NSString *addressName;
    NSString *shopName;
    
    CLLocationCoordinate2D coordinate;
    CLLocationDegrees latitude;
    CLLocationDegrees longitude;
    
    UIScrollView *scrollBar;
    
    UIButton *routeButton;
    UIButton *clearRouteButton;
    MKRoute *routeDetails;
    
}


@property(nonatomic, strong) UILabel *addressLabel;
@property(nonatomic, strong) UILabel *shopLabel;

@property(nonatomic, copy) NSString *addressName;
@property(nonatomic, copy) NSString *shopName;

@property(nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property(nonatomic, strong) UIScrollView *scrollBar;

@end
