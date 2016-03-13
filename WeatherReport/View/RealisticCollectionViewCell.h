//
//  RealisticCollectionViewCell.h
//  WeatherReport
//
//  Created by lanou on 16/3/1.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RealistModel.h"

@interface RealisticCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageview;

@property (nonatomic, strong) RealistModel *realistModel;

@property (nonatomic, strong) UILabel *titleLabel;



@end
