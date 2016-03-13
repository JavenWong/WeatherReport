//
//  User.h
//  WeatherReport
//
//  Created by lanou on 16/2/29.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic,strong)NSString *health;

@property (nonatomic,strong)NSString *assit;

@property (nonatomic,strong)NSString *air;

@property (nonatomic,strong)NSString *account;

@property (nonatomic,strong)NSString *setting;

- (instancetype)initWithHealth:(NSString *)health assit:(NSString *)assit air:(NSString *)air account:(NSString *)account setting:(NSString *)setting;

@end
