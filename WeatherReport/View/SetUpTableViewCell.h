//
//  SetUpTableViewCell.h
//  WeatherReport
//
//  Created by JavenWong on 16/3/5.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetUpTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fileSizeLb;
@property (weak, nonatomic) IBOutlet UILabel *DataLb;
@property (strong, nonatomic) UISwitch *choiceSwitch;
@end
