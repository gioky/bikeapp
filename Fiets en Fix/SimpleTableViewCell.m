//
//  SimpleTableViewCell.m
//  Fiets en Fix
//
//  Created by George Kyriacou on 3/24/14.
//  Copyright (c) 2014 George Kyriacou. All rights reserved.
//

#import "SimpleTableViewCell.h"

@implementation SimpleTableViewCell
@synthesize addressLabel, nameLabel, distanceLabel, kmLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Create and position UI Elements
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 220, 25)];
        nameLabel.font = [UIFont systemFontOfSize:16.0];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [self addSubview:nameLabel];
        
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 220, 25)];
        addressLabel.font = [UIFont systemFontOfSize:14.0];
        addressLabel.textColor = [UIColor blackColor];
        addressLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [self addSubview:addressLabel];
        
        
        self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 0, 25, 25)];
        distanceLabel.font = [UIFont systemFontOfSize:14.0];
        distanceLabel.textColor = [UIColor blackColor];
        distanceLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [self addSubview:distanceLabel];
        
        self.kmLabel = [[UILabel alloc] initWithFrame:CGRectMake(275, 0, 20, 25)];
        kmLabel.text = @"km";
        kmLabel.font = [UIFont systemFontOfSize:12.0];
        kmLabel.textColor = [UIColor blackColor];
        kmLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [self addSubview:kmLabel];

    }
    return self;
}



- (void)awakeFromNib
{
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
