//
//  SettingsViewController.h
//  Fiets en Fix
//
//  Created by George Kyriacou on 1/25/14.
//  Copyright (c) 2014 George Kyriacou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController {
    
    
    UILabel *LabelVicinity;
    UILabel *VicinityValue;
    UILabel *LabelSale;
    UILabel *LabelRepair;
    UILabel *LabelParking;
    UILabel *LabelKm;
    
    UISwitch *switch_sale;
    UISwitch *switch_repair;
    UISwitch *switch_parking;
    
    UISlider *radiusSlider;
    
    NSUserDefaults *userPreferences;
}

@end
