//
//  User.m
//  WeatherReport
//
//  Created by lanou on 16/2/29.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithHealth:(NSString *)health assit:(NSString *)assit air:(NSString *)air account:(NSString *)account setting:(NSString *)setting{
    self = [super init];
    if (self) {
        self.health = health;
        self.assit = assit;
        self.air = air;
        self.account = account;
        self.setting = setting;
    }
    return self;
}

@end
