//
//  ViewController.h
//  WeatherReport
//
//  Created by JavenWong on 16/2/26.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetBackgroundImageByCond.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) NSDictionary *dataDic;

@property (strong, nonatomic) SetBackgroundImageByCond *condView;

@end
