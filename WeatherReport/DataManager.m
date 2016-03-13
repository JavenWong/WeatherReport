//
//  DataManager.m
//  WeatherReport
//
//  Created by lanou on 16/2/29.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "DataManager.h"

@interface DataManager (){
    sqlite3 *dbPoint;
}

@end

@implementation DataManager

+ (instancetype)sharedManager{
    static DataManager *manager = nil;
    if (manager == nil) {
        manager = [[DataManager alloc]init];
    }
    return manager;
}

- (void)openData{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"user.db"];
    int result = sqlite3_open([path UTF8String],&dbPoint);
    [self judgeByresult:result action:@"打开数据库"];
    NSLog(@"%@",path);
}

- (void)judgeByresult:(int)result action:(NSString *)action{
    if (result == SQLITE_OK) {
        NSLog(@"%@成功",action);
    }else{
        NSLog(@"%@失败,result = %d",action,result);
    }
}

- (void)closeData{
    int result = sqlite3_close_v2(dbPoint);
    [self judgeByresult:result action:@"关闭数据库"];
}

- (void)createTable{
    [self openData];
    NSString *sqrSQL = @"create table user (health text,assit text,air text,account text,setting text)";
    char *errmsg;
    int result = sqlite3_exec(dbPoint, [sqrSQL UTF8String], NULL, NULL, &errmsg);
    [self judgeByresult:result action:@"创建表格"];
    sqlite3_free(errmsg);
    [self closeData];
}

@end
