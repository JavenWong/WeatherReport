//
//  ArticleContentItem.h
//  WeatherReport
//
//  Created by lanou on 16/3/9.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleContentItem : NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *content_format;
@property (nonatomic, strong) NSString *disclaimer;
@property (nonatomic, strong) NSArray *media;

@end
