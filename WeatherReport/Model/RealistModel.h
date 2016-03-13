//
//  RealistModel.h
//  WeatherReport
//
//  Created by lanou on 16/3/1.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RealistModel : NSObject

@property (nonatomic, strong) NSString *bookUrl;  // 游记网址
@property (nonatomic, strong) NSString *headImage; // 图片网址

//@property (nonatomic, assign) double bookImgNum;
//@property (nonatomic, assign) double likeCount;

@property (nonatomic, strong) NSString *title; // 文章的标题
@property (nonatomic, strong) NSString *userName; // 作者名称
//@property (nonatomic, assign) double viewCount;

@property (nonatomic, strong) NSString *userHeadImg; // 作者图片网址
//@property (nonatomic, assign) double commentCount;
@property (nonatomic, strong) NSString *text; // 旅游的地点
//@property (nonatomic, assign) BOOL elite;
@property (nonatomic, assign) double routeDays; //  旅游天数
@property (nonatomic, strong) NSString *startTime; // 开始时间

@property (nonatomic, assign) double scale; // 宽高的比例

@property (nonatomic, assign) float width;

@property (nonatomic, assign) float height;

@property (nonatomic, assign) BOOL commit; // 记录图片加载状态




@end
