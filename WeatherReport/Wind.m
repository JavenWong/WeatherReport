//
//  Wind.m
//
//  Created by   on 16/2/26
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "Wind.h"


NSString *const kWindDir = @"dir";
NSString *const kWindDeg = @"deg";
NSString *const kWindSc = @"sc";
NSString *const kWindSpd = @"spd";


@interface Wind ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Wind

@synthesize dir = _dir;
@synthesize deg = _deg;
@synthesize sc = _sc;
@synthesize spd = _spd;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.dir = [self objectOrNilForKey:kWindDir fromDictionary:dict];
            self.deg = [self objectOrNilForKey:kWindDeg fromDictionary:dict];
            self.sc = [self objectOrNilForKey:kWindSc fromDictionary:dict];
            self.spd = [self objectOrNilForKey:kWindSpd fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.dir forKey:kWindDir];
    [mutableDict setValue:self.deg forKey:kWindDeg];
    [mutableDict setValue:self.sc forKey:kWindSc];
    [mutableDict setValue:self.spd forKey:kWindSpd];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.dir = [aDecoder decodeObjectForKey:kWindDir];
    self.deg = [aDecoder decodeObjectForKey:kWindDeg];
    self.sc = [aDecoder decodeObjectForKey:kWindSc];
    self.spd = [aDecoder decodeObjectForKey:kWindSpd];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_dir forKey:kWindDir];
    [aCoder encodeObject:_deg forKey:kWindDeg];
    [aCoder encodeObject:_sc forKey:kWindSc];
    [aCoder encodeObject:_spd forKey:kWindSpd];
}

- (id)copyWithZone:(NSZone *)zone
{
    Wind *copy = [[Wind alloc] init];
    
    if (copy) {

        copy.dir = [self.dir copyWithZone:zone];
        copy.deg = [self.deg copyWithZone:zone];
        copy.sc = [self.sc copyWithZone:zone];
        copy.spd = [self.spd copyWithZone:zone];
    }
    
    return copy;
}


@end
