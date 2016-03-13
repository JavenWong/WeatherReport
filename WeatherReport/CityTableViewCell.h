//
//  CityTableViewCell.h
//  WeatherReport
//
//  Created by JavenWong on 16/2/27.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *CityNameLb;
@property (weak, nonatomic) IBOutlet UILabel *minTmpLb;
@property (weak, nonatomic) IBOutlet UILabel *maxTmpLb;

@end
