//
//  Wind.h
//
//  Created by   on 16/2/26
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Wind : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *dir;
@property (nonatomic, strong) NSString *deg;
@property (nonatomic, strong) NSString *sc;
@property (nonatomic, strong) NSString *spd;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
