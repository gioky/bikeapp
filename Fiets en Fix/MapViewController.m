//
//  ViewController.m
//  Fiets en Fix
//
//  Created by George Kyriacou on 1/22/14.
//  Copyright (c) 2014 George Kyriacou. All rights reserved.
//

#import "MapViewController.h"
#import "PlaceDetailsViewController.h"
#import "AFNetworking.h"
#import "ListViewController.h"

@interface MapViewController ()

@end


@implementation MapViewController
@synthesize myMapView, placesArray, radi;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create our MapView
    myMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    myMapView.mapType = MKMapTypeStandard;
    myMapView.zoomEnabled = YES;
    myMapView.scrollEnabled = YES;
    myMapView.delegate = self;
    
    // Add our MKMapView object as a subview in our view
    [self.view addSubview:myMapView];
    
    myMapView.showsUserLocation = YES;
    
    // check if the project uses ARC - Automatic Reference Counting
    //[[[NSObject alloc] init] autorelease];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(0, 0, 40, 40);
    activityIndicator.center = self.view.center;
    [self.view addSubview: activityIndicator];
    [activityIndicator startAnimating];
    
    
    locationController = [LocationController sharedLocationController];
    self.radi = [[NSUserDefaults standardUserDefaults] integerForKey:@"sliderValueKey"];
    
}


#pragma mark - Location Controller delegate
-(void)locationUpdate:(CLLocation *)location {
    
        myLocation = location;
    
}



-(void)changeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    
    NSLog(@"changeAuthorizationStatus");
    if (status == kCLAuthorizationStatusAuthorized)  {
        
        myLocation = locationController.locationManager.location;
        [self getPlacesWithAnnotations];
    }
    
} 



-(void) getPlacesWithAnnotations {
    
    NSInteger radius = [[NSUserDefaults standardUserDefaults] integerForKey:@"sliderValueKey"];
    radius = radius * 1000;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=%ld&types=bicycle_store&sensor=false&key=%@", myLocation.coordinate.latitude, myLocation.coordinate.longitude, (long)radius, kGOOGLE_API_KEY]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //AFNetworking asynchronous url request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        nextPageToken = [responseObject objectForKey:@"next_page_token"];
        NSLog(@"next page token: %@", nextPageToken);
        
        if (nextPageToken == NULL) {
            
            self.placesArray = [responseObject objectForKey:@"results"];
            NSLog(@"The Array: %@", self.placesArray);
            [activityIndicator stopAnimating];
            [self plotPositions];
            
        } // end if statement
        
        else {
            
            self.placesArray = [responseObject objectForKey:@"results"];
            
            // wait 2 secs and then fetch additional results using next_page_token
            sleep(2);
            [self receiveAdditionalResults];
            
        } // end else statement
        
        
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Request Failed: %@, %@", error, error.userInfo);
    }];
    
    [operation start];
    
}



-(void) receiveAdditionalResults {
    
    NSLog(@"inside receiveAdditionalResults");
    
    NSInteger radius = [[NSUserDefaults standardUserDefaults] integerForKey:@"sliderValueKey"];
    radius = radius * 1000;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?pagetoken=%@&sensor=false&key=%@", nextPageToken,kGOOGLE_API_KEY ]];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //AFNetworking asynchronous url request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
            NSArray *newArray = [responseObject objectForKey:@"results"];
            self.placesArray = [placesArray arrayByAddingObjectsFromArray:newArray];
            NSLog(@"The Array in map is: %@", self.placesArray);
            [activityIndicator stopAnimating];
            [self plotPositions];
        
        
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Request Failed: %@, %@", error, error.userInfo);
    }];
    
    [operation start];
    
}



-(void)plotPositions {
    
    if ([placesArray count] != 0) {
    
        for (int i=0; i<[placesArray count]; i++) {
        
            //Retrieve the NSDictionary object in each index of the array.
            NSDictionary* place = [placesArray objectAtIndex:i];
        
            // 3 - There is a specific NSDictionary object that gives us the location info.
            NSDictionary *geo = [place objectForKey:@"geometry"];
        
            // Get the lat and long for the location.
            NSDictionary *loc = [geo objectForKey:@"location"];
        
            // 4 - Get your name and address info for adding to a pin.
            NSString *name = [place objectForKey:@"name"];
            NSString *vicinity = [place objectForKey:@"vicinity"];
        
            // Create a special variable to hold this coordinate info.
            CLLocationCoordinate2D placeCoord;
        
            // Set the lat and long.
            placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
            placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
            
            // 5 - Create a new annotation.
            Annotation *myAnnotation = [Annotation alloc];
            myAnnotation.coordinate = placeCoord;
            myAnnotation.title = name;
            myAnnotation.subtitle = vicinity;
        
            [myMapView addAnnotation:myAnnotation];
        
        } // end for loop
    
        [myMapView showAnnotations:myMapView.annotations animated:YES];

    } // end if statement
    
    else {
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@" No bicycle shops in the selected vicinity. Increase vicinity to view results."                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    
    } // end else statement

}




// Whenever we call addAnnotation method the following delegate method gets called
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    

    MKAnnotationView *annotationView = nil ;
    
    // if statement in order to avoid annotating user's location
    if ([annotation isKindOfClass:[Annotation class]]) {
        
        static NSString *startPinId = @"StartPinIdentifier";
        annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:startPinId];
        
        annotationView.image = [UIImage imageNamed:@"pins.png"];
        annotationView.canShowCallout = YES;
        
        if (annotationView == nil) {
            
            annotationView = [[MKAnnotationView alloc] initWithAnnotation :annotation reuseIdentifier:startPinId];
            annotationView.image = [UIImage imageNamed:@"pins.png"];
            annotationView.canShowCallout = YES;
        }
        
        // instatiate a detail-disclosure button and set it to appear on right side of annotation
        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.rightCalloutAccessoryView = infoButton;
        
        return annotationView;
        
    } // end if statement
    
    else
        return nil;
}



// gets called when accessory control tapped
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[Annotation class]]) {
     
            [self performSegueWithIdentifier:@"PinDetailsSegue" sender:view];
    }
    
    else
        return;
}




// This will get called too before the view appears
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(MKAnnotationView *)sender
{
    
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"PinDetailsSegue"])
    {
        
        // Get reference to the destination view controller
        PlaceDetailsViewController *placeDetailsView = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like... and grab the annotation from sender
        placeDetailsView.shopName = sender.annotation.title;
        placeDetailsView.addressName = sender.annotation.subtitle;
        placeDetailsView.coordinate = sender.annotation.coordinate;
    }
} 




-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[LocationController sharedLocationController]setDelegate:self];
    [[LocationController sharedLocationController].locationManager startUpdatingLocation];
    
//    NSLog(@"viewWillAppear");

    if (self.radi != [[NSUserDefaults standardUserDefaults] integerForKey:@"sliderValueKey"]) {
        
        self.radi = [[NSUserDefaults standardUserDefaults] integerForKey:@"sliderValueKey"];
        self.placesArray = NULL;
        [myMapView removeAnnotations:myMapView.annotations];
        [activityIndicator startAnimating];
        [self getPlacesWithAnnotations];
        
    }
    
}



-(void) viewWillDisappear:(BOOL)animated {
    
    [[LocationController sharedLocationController].locationManager stopUpdatingLocation];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
