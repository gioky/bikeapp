//
//  ListViewController.m
//  Fiets en Fix
//
//  Created by George Kyriacou on 2/1/14.
//  Copyright (c) 2014 George Kyriacou. All rights reserved.
//

#import "ListViewController.h"
#import "AFNetworking.h"
#import "PlaceDetailsViewController.h"
#import "SimpleTableViewCell.h"

@interface ListViewController ()

@end


@implementation ListViewController
@synthesize myTableView, googlePlacesArrayFromAFNetworking, tempDictionary, rad, placesDistance;


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
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, 320, 430)];
    myTableView.rowHeight = 75.0;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(0, 0, 40, 40);
    activityIndicator.center = self.view.center;
    [self.view addSubview: activityIndicator];
    
    [activityIndicator startAnimating];
    
    
    locationController = [LocationController sharedLocationController];
    myCurrentLocation = locationController.locationManager.location;
    
 
    self.rad = [[NSUserDefaults standardUserDefaults] integerForKey:@"sliderValueKey"];
    [self makeBicycleShopsRequest];
}



#pragma mark - Location Controller delegate
-(void)locationUpdate:(CLLocation *)location {
    
    myCurrentLocation = location;
}




-(void) changeAuthorizationStatus:(CLAuthorizationStatus)status {
    
 
}




-(void)makeBicycleShopsRequest
{
    NSInteger radius = [[NSUserDefaults standardUserDefaults] integerForKey:@"sliderValueKey"];
    radius = radius * 1000;
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=%ld&types=bicycle_store&sensor=false&key=%@", myCurrentLocation.coordinate.latitude, myCurrentLocation.coordinate.longitude, (long)radius, kGOOGLE_API_KEY]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
    //AFNetworking asynchronous url request
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
        [operation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
            
            nextPageToken = [responseObject objectForKey:@"next_page_token"];
            NSLog(@"the page token inside tableView is: %@", nextPageToken);
            
            
            // only one page of results returned
            if (nextPageToken == NULL) {
                
                self.googlePlacesArrayFromAFNetworking = [responseObject objectForKey:@"results"];
                NSLog(@"the results in tableview are: %@", self.googlePlacesArrayFromAFNetworking);
                [self calculateDistance];
                [myTableView reloadData];
                [activityIndicator stopAnimating];
            }
            
            else {
                
                self.googlePlacesArrayFromAFNetworking = [responseObject objectForKey:@"results"];
                
                // wait 2 secs and then fetch additional results using next_page_token
                sleep(2);
                [self receiveAdditionalResults];
            }
        
        
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
        self.googlePlacesArrayFromAFNetworking = [googlePlacesArrayFromAFNetworking arrayByAddingObjectsFromArray:newArray];
        
        NSLog(@"the results in tableview are: %@", self.googlePlacesArrayFromAFNetworking);
        [self calculateDistance];
        [myTableView reloadData];
        [activityIndicator stopAnimating];
        
        
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Request Failed: %@, %@", error, error.userInfo);
    }];
    
    [operation start];
    
}



 -(void)calculateDistance {
   
     CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:myCurrentLocation.coordinate.latitude longitude:myCurrentLocation.coordinate.longitude];
     
     placesDistance = [NSMutableArray arrayWithCapacity:[googlePlacesArrayFromAFNetworking count]];
     
     for (int i=0; i<[googlePlacesArrayFromAFNetworking count]; i++) {
         
         NSDictionary* place = [googlePlacesArrayFromAFNetworking objectAtIndex:i];
         NSDictionary *geolocation = [place objectForKey:@"geometry"];
         NSDictionary *location = [geolocation objectForKey:@"location"];
         
         CLLocationDegrees placeLatitude = [[location objectForKey:@"lat"]doubleValue];
         CLLocationDegrees placeLongitude = [[location objectForKey:@"lng"]doubleValue];
         
         CLLocation *placeLocation = [[CLLocation alloc] initWithLatitude: placeLatitude longitude:placeLongitude];
         
         // returns a double in meters
         CLLocationDistance distance = [placeLocation distanceFromLocation:userLocation];
         distance = distance / 1000;
         NSString *doubleDistance = [NSString stringWithFormat:@"%.01f", distance];
         
         [placesDistance addObject:doubleDistance];
     }
     
     NSLog(@"the array contents: %@", placesDistance);
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [self.googlePlacesArrayFromAFNetworking count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    SimpleTableViewCell *cell = (SimpleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    tempDictionary = [self.googlePlacesArrayFromAFNetworking objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        
        cell = [[SimpleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
   
    cell.nameLabel.text = [tempDictionary objectForKey:@"name"];
    cell.addressLabel.text = [tempDictionary objectForKey:@"vicinity"];
    cell.distanceLabel.text = [self.placesDistance objectAtIndex:indexPath.row];
                               
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath   *)indexPath
{
    
    [self performSegueWithIdentifier:@"PinDetailsSegue" sender:self];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
} 



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"PinDetailsSegue"])
    {

        NSIndexPath *selectedIndexPath = [self.myTableView indexPathForSelectedRow];
                                          
        // Get reference to the destination view controller
        PlaceDetailsViewController *placeDetailsView = [segue destinationViewController];
        
        
        NSDictionary *place = [self.googlePlacesArrayFromAFNetworking objectAtIndex: selectedIndexPath.row];
        NSLog(@" string name printed: %@", place);
        placeDetailsView.shopName = [place objectForKey:@"name"];
        placeDetailsView.addressName = [place objectForKey:@"vicinity"];
        
        NSDictionary *geometryDict = [place objectForKey:@"geometry"];
        NSDictionary *locationDict = [geometryDict objectForKey:@"location"];
        
        latitude = [[locationDict objectForKey:@"lat"] doubleValue];
        longitude = [[locationDict objectForKey:@"lng"] doubleValue];

        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        placeDetailsView.coordinate = coordinate;
    }
}




-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[LocationController sharedLocationController]setDelegate:self];
    [[LocationController sharedLocationController].locationManager startUpdatingLocation];
    
    if (self.rad != [[NSUserDefaults standardUserDefaults] integerForKey:@"sliderValueKey"]) {
        
        self.rad = [[NSUserDefaults standardUserDefaults] integerForKey:@"sliderValueKey"];
        self.googlePlacesArrayFromAFNetworking = NULL;
        [myTableView reloadData];
        [activityIndicator startAnimating];
        [self makeBicycleShopsRequest];
        
    }
    
}



-(void)viewWillDisappear:(BOOL)animated {
    
    [[LocationController sharedLocationController].locationManager stopUpdatingLocation];
    
}


@end
