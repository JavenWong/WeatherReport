//
//  RealisticCollectionViewCell.m
//  WeatherReport
//
//  Created by lanou on 16/3/1.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "RealisticCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation RealisticCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    
//    NSLog(@"____自身的frame为%@", NSStringFromCGRect(frame));
    self = [super initWithFrame:frame];
    if (self) {
        self.imageview = [[UIImageView alloc]initWithFrame:self.bounds];
//        NSLog(@"____自身的frame为%@", NSStringFromCGRect(self.imageview.frame));
        self.contentView.layer.cornerRadius = 25;
        [self.contentView addSubview:self.imageview];
        self.imageview.contentMode = UIViewContentModeScaleToFill;
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height / 4.0 * 3, self.bounds.size.width, self.bounds.size.height / 4.0)];
        [self.contentView addSubview:self.titleLabel];
    }
    
    return self;
}

- (void)setRealistModel:(RealistModel *)realistModel
{
    _realistModel = realistModel;
    NSURL *url = [[NSURL alloc]initWithString:realistModel.headImage];

    // 判断标题的长度, 去掉数据的#猴年托红包#字眼
    if ([realistModel.title length] > 7 && [realistModel.title hasPrefix:@"#"]) {
    _titleLabel.text = [realistModel.title stringByReplacingCharactersInRange:NSMakeRange(0, 7) withString:@""];
    }
    else{
        
        _titleLabel.text = realistModel.title;
    }
    _titleLabel.textColor = [UIColor whiteColor];

 
    [_imageview sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_icon@2x"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        _realistModel.commit = YES;
        
        // 图片加载完成可以执行方法
        
        //     访问图片的缓存地址
        SDWebImageManager *sdImage = [SDWebImageManager sharedManager];
        NSString *key = [sdImage cacheKeyForURL:[NSURL URLWithString:realistModel.headImage]];
        
        NSString *keyPath = [sdImage.imageCache defaultCachePathForKey:key];
        
        CGSize size = [UIImage imageWithContentsOfFile:keyPath].size;
    
        // 对除数是否为0进行判断, 是0不执行
        if (size.width != 0) {
            realistModel.scale = size.height / size.width;
            realistModel.width = size.width;
            realistModel.height = size.height;
           
        }
        
        
    }];
    
    
    
}




@end
