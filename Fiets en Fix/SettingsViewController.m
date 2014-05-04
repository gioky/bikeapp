//
//  SettingsViewController.m
//  Fiets en Fix
//
//  Created by George Kyriacou on 1/25/14.
//  Copyright (c) 2014 George Kyriacou. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController


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
    
    // set background color to view and configure the labels
    
    self.view.backgroundColor = [UIColor blackColor];
    
    LabelVicinity = [[UILabel alloc] initWithFrame:CGRectMake(40, 40, 100, 40)];
    LabelVicinity.text = [NSString stringWithFormat:@"Vicinity"];
    LabelVicinity.textColor = [UIColor whiteColor];
    LabelVicinity.font = [UIFont fontWithName:@"Helvetica" size:18];
    [self.view addSubview:LabelVicinity];
    
    
    LabelSale = [[UILabel alloc] initWithFrame:CGRectMake(40, 180, 100, 40)];
    LabelSale.text = [NSString stringWithFormat:@"Sale Shops"];
    LabelSale.textColor = [UIColor whiteColor];
    LabelSale.font = [UIFont fontWithName:@"Helvetica" size:18];
    [self.view addSubview:LabelSale];
    
    
    LabelRepair = [[UILabel alloc] initWithFrame:CGRectMake(40, 260, 140, 40)];
    LabelRepair.text = [NSString stringWithFormat:@"Repair Shops"];
    LabelRepair.textColor = [UIColor whiteColor];
    LabelRepair.font = [UIFont fontWithName:@"Helvetica" size:18];
    [self.view addSubview:LabelRepair];
    
    
    LabelParking = [[UILabel alloc] initWithFrame:CGRectMake(40, 340, 140, 40)];
    LabelParking.text = [NSString stringWithFormat:@"Parking Slots"];
    LabelParking.textColor = [UIColor whiteColor];
    LabelParking.font = [UIFont fontWithName:@"Helvetica" size:18];
    [self.view addSubview:LabelParking];
    
    
    
    // configure the UISlider and UISwitches
    
    radiusSlider = [[UISlider alloc] initWithFrame:CGRectMake(40, 90, 260, 34)];
    [self.view addSubview:radiusSlider];
    radiusSlider.minimumValue = 1;
    radiusSlider.maximumValue = 5;
    radiusSlider.continuous = YES;
    radiusSlider.value = 3;
    [radiusSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    radiusSlider.value = [[NSUserDefaults standardUserDefaults] integerForKey:@"sliderValueKey"];
    
    
    switch_sale = [[UISwitch alloc] initWithFrame:CGRectMake(250, 185, 51, 31)];
    [self.view addSubview:switch_sale];
    [switch_sale addTarget:self action:@selector(switchSale:) forControlEvents:UIControlEventValueChanged];
    switch_sale.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"salesKey"];
    
    
    switch_repair = [[UISwitch alloc] initWithFrame:CGRectMake(250, 265, 51, 31)];
    [self.view addSubview:switch_repair];
    [switch_repair addTarget:self action:@selector(switchRepair:) forControlEvents:UIControlEventValueChanged];
    switch_repair.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"repairKey"];
    
    
    switch_parking = [[UISwitch alloc] initWithFrame:CGRectMake(250, 345, 51, 31)];
    [self.view addSubview:switch_parking];
    [switch_parking addTarget:self action:@selector(switchParking:) forControlEvents:UIControlEventValueChanged];
    switch_parking.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"parkingKey"];
    
    
    // set labels for vicinity and km (under UISlider)
    
    VicinityValue = [[UILabel alloc] initWithFrame:CGRectMake(120, 130, 30, 30)];
    VicinityValue.text = [NSString stringWithFormat:@"%ld", (long)radiusSlider.value];
    VicinityValue.textColor = [UIColor whiteColor];
    VicinityValue.font = [UIFont fontWithName:@"Helvetica" size:18];
    
    [self.view addSubview:VicinityValue];
    
    
    LabelKm = [[UILabel alloc] initWithFrame:CGRectMake(160, 130, 40, 30)];
    LabelKm.text = [NSString stringWithFormat:@"Km."];
    LabelKm.font = [UIFont fontWithName:@"Helvetica" size:17];
    LabelKm.textColor = [UIColor whiteColor];
    [self.view addSubview:LabelKm];

}



-(void)switchSale:(id)sender {
    
    if (switch_sale.on) {
        userPreferences = [NSUserDefaults standardUserDefaults];
        [userPreferences setBool:YES forKey:@"salesKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        
        userPreferences = [NSUserDefaults standardUserDefaults];
        [userPreferences setBool:NO forKey:@"salesKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}



-(void)switchRepair:(id)sender {
    
    if (switch_repair.on) {
        userPreferences = [NSUserDefaults standardUserDefaults];
        [userPreferences setBool:YES forKey:@"repairKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        
        userPreferences = [NSUserDefaults standardUserDefaults];
        [userPreferences setBool:NO forKey:@"repairKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}



-(void)switchParking:(id)sender {
    
    if (switch_parking.on) {
        userPreferences = [NSUserDefaults standardUserDefaults];
        [userPreferences setBool:YES forKey:@"parkingKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        
        userPreferences = [NSUserDefaults standardUserDefaults];
        [userPreferences setBool:NO forKey:@"parkingKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}



-(void)sliderAction:(id)sender {
    
    NSInteger val = radiusSlider.value;
    VicinityValue.text = [NSString stringWithFormat:@"%ld", (long)val];
    VicinityValue.textColor = [UIColor whiteColor];
    VicinityValue.font = [UIFont fontWithName:@"Helvetica" size:18];
    
    userPreferences = [NSUserDefaults standardUserDefaults];
    [userPreferences setInteger:val forKey:@"sliderValueKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
     
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
