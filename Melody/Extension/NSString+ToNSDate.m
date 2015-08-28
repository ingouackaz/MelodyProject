//
//  NSString+ToNSDate.m
//  UbinectV2
//
//  Created by Roger Ingouacka on 3/15/13.
//  Copyright (c) 2013 Roger Ingouacka. All rights reserved.
//

#import "NSString+ToNSDate.h"

@implementation NSString (toDate)

-(NSDate *)toNSDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *date = [dateFormat dateFromString:self];

    return date;
}

-(NSDate *)toNSDate2
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:self];
    return date;
}

-(NSDate *)toActuNSDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:self];
    return date;
}

-(NSDate *)producedFormatNSDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormat dateFromString:self];
    return date;
}


-(NSDate *)tolastUpdateFormatNSDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *date = [dateFormat dateFromString:self];
    return date;
}
@end
