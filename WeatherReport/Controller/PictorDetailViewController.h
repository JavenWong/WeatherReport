//
//  PictorDetailViewController.h
//  WeatherReport
//
//  Created by lanou on 16/3/5.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictoralModel.h"

@interface PictorDetailViewController : UIViewController

@property (nonatomic, strong) NSString *urlStr;

@property (nonatomic, strong) PictoralModel *model;

@end
