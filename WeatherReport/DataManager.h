//
//  DataManager.h
//  WeatherReport
//
//  Created by lanou on 16/2/29.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import <sqlite3.h>
@interface DataManager : NSObject

+ (instancetype)sharedManager;

- (void)openData;

- (void)closeData;

- (void)createTable;

- (void)addUser:(User *)user;

- (void)judgeByresult:(int)result action:(NSString *)action;

@end
