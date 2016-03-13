//
//  PictureViewController.h
//  WeatherReport
//
//  Created by lanou on 16/3/8.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RealistModel.h"


@interface PictureViewController : UIViewController

@property (nonatomic, strong) NSString *urlStr;

@property (nonatomic, strong) RealistModel *picturemodel;


@end
