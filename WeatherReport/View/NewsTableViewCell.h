//
//  NewsTableViewCell.h
//  WeatherReport
//
//  Created by lanou on 16/3/5.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"
@interface NewsTableViewCell : UITableViewCell

@property (nonatomic,strong)News *news;
@property (weak, nonatomic) IBOutlet UIImageView *newsImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;


@end
