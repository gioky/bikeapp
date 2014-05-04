//
//  PlaceDetailsViewController.m
//  Fiets en Fix
//
//  Created by George Kyriacou on 2/23/14.
//  Copyright (c) 2014 George Kyriacou. All rights reserved.
//

#import "PlaceDetailsViewController.h"
#import "Annotation.h"

@interface PlaceDetailsViewController ()

@end

@implementation PlaceDetailsViewController
@synthesize addressName, addressLabel, shopName, shopLabel, coordinate, scrollBar;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    scrollBar = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 800)];
    [scrollBar setScrollEnabled:YES];
    scrollBar.delegate = self;
    [self.view addSubview:scrollBar];
    
    
    detailMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    detailMapView.mapType = MKMapTypeStandard;
    detailMapView.delegate = self;
    detailMapView.showsUserLocation = YES;
    [scrollBar addSubview:detailMapView];
    
    // add the annotation of mapitem clicked
    Annotation *pin = [[Annotation alloc] init];
    pin.coordinate = coordinate;
    [detailMapView addAnnotation:pin];
    
    
    // create the address label
    addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 350, 250, 30)];
    addressLabel.text = addressName;
//    addressLabel.text = [self.dictio objectForKey:@"vicinity"];
    addressLabel.textColor = [UIColor blackColor];
    addressLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
    [scrollBar addSubview:addressLabel];

    
    // create the shop name label
    shopLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 390, 200, 30)];
    shopLabel.text = shopName;
    shopLabel.textColor = [UIColor blackColor];
    shopLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
    [scrollBar addSubview:shopLabel];
    
    
    
    // create the get route button and bind an action to it
    routeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [routeButton setFrame:CGRectMake(10, 310, 80, 30)];
    routeButton.backgroundColor = [UIColor blackColor];
    routeButton.layer.cornerRadius = 5;
    routeButton.clipsToBounds = YES;
    [routeButton setTitle:@"Get Route" forState:UIControlStateNormal];
    [routeButton addTarget:self action:@selector(showRoute:) forControlEvents:UIControlEventTouchUpInside];
    [scrollBar addSubview:routeButton];
    
    
    // create the clear route button and bind an action to it
    clearRouteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [clearRouteButton setFrame:CGRectMake(210, 310, 100, 30)];
    clearRouteButton.backgroundColor = [UIColor blackColor];
    clearRouteButton.layer.cornerRadius = 5;
    clearRouteButton.clipsToBounds = YES;
    [clearRouteButton setTitle:@"Clear Route" forState:UIControlStateNormal];
    [clearRouteButton addTarget:self action:@selector(clearRoute:) forControlEvents:UIControlEventTouchUpInside];
    [scrollBar addSubview:clearRouteButton];
    
    [detailMapView showAnnotations:detailMapView.annotations animated:YES];
}



// Displays the route between 2 points

-(void)showRoute:(id)sender {
    
    MKDirectionsRequest *directionsRequest = [[MKDirectionsRequest alloc] init];
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
    
    [directionsRequest setSource:[MKMapItem mapItemForCurrentLocation]];
    [directionsRequest setDestination:[[MKMapItem alloc] initWithPlacemark:placemark]];
    [directionsRequest setTransportType:MKDirectionsTransportTypeAutomobile];
    
    
    MKDirections *direction = [[MKDirections alloc] initWithRequest:directionsRequest];
    
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        if (error) {
            NSLog(@"Error %@", error.description);
            
        } else {
            
            routeDetails = response.routes.lastObject;
            [detailMapView addOverlay:routeDetails.polyline];
            NSLog(@"total distance in meters: %f", routeDetails.distance);
        }
    }];
}



// Clears the route between the 2 points on the map

-(void)clearRoute:(id)sender {
    
    [detailMapView removeOverlay:routeDetails.polyline];
    
}



// Draws the line between the 2 points on the map
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor redColor];
    renderer.lineWidth = 4.0;
    return  renderer;
}




-(void)viewDidLayoutSubviews {
    
    self.scrollBar.contentSize = CGSizeMake(320, 800);
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
