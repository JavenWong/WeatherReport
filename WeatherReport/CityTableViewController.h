//
//  CityTableViewController.h
//  WeatherReport
//
//  Created by JavenWong on 16/2/27.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityTableViewController : UITableViewController

@property (strong, nonatomic) NSDictionary *dataDic;


@property (copy, nonatomic) void(^changeCityNameBlock) (NSString *);


@end
