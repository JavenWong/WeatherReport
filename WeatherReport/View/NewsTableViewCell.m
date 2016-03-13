//
//  NewsTableViewCell.m
//  WeatherReport
//
//  Created by lanou on 16/3/5.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation NewsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNews:(News *)news{
    _news = news;
    self.titleLabel.text = news.title;
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.numberOfLines = 0;
    
    self.detailLabel.text = news.digest;
    self.detailLabel.font = [UIFont systemFontOfSize:15];
    self.detailLabel.numberOfLines = 0;
    
    [self.newsImage sd_setImageWithURL:[NSURL URLWithString:news.imgsrc]];
}

@end
