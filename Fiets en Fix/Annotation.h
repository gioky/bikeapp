//
//  MyPins.h
//  Fiets en Fix
//
//  Created by George Kyriacou on 2/2/14.
//  Copyright (c) 2014 George Kyriacou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation>

@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subtitle;

@end
