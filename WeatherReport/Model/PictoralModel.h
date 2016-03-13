//
//  PictoralModel.h
//  WeatherReport
//
//  Created by lanou on 16/3/5.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PictoralModel : NSObject

@property (nonatomic, strong) NSString *title; // 文章标题

@property (nonatomic, strong) NSString *thumbnail_pic; // 文章图片(640)

@property (nonatomic, strong) NSString *thumbnail_mpic; // 文章图片(320)

@property (nonatomic, strong) NSString *date; // 文章日期

@property (nonatomic, strong) NSString *weburl; // 文章网址

@property (nonatomic, strong) NSString *full_url; // 文章详情网址

@property (nonatomic, strong) NSString *auther_name; // 作者名字

@end
