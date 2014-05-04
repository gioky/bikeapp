//
//  SimpleTableViewCell.h
//  Fiets en Fix
//
//  Created by George Kyriacou on 3/24/14.
//  Copyright (c) 2014 George Kyriacou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleTableViewCell : UITableViewCell

@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *addressLabel;
@property(nonatomic, strong) UILabel *distanceLabel;
@property(nonatomic, strong) UILabel *kmLabel;

@end
