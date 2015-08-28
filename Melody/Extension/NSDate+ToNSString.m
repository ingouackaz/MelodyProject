//
//  NSDate+ToNSString.m
//  UbinectV2
//
//  Created by Roger Ingouacka on 3/15/13.
//  Copyright (c) 2013 Roger Ingouacka. All rights reserved.
//

#import "NSDate+ToNSString.h"

@implementation NSDate (toString)

-(NSString *)toNSString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSString *strDate = [dateFormatter stringFromDate:self];
    return strDate;
}

-(NSString *)toNSString2
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:self];
    return strDate;
}

-(NSString *)toActuString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:self];
    return strDate;
}

-(NSString *)toGrilleTvDisplayFormatString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *frLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];
    [dateFormatter setLocale:frLocale];
    [dateFormatter setDateFormat:@"EEEE dd"];
    NSString *strDate = [dateFormatter stringFromDate:self];
    return strDate;
}

-(NSString *)toProducedFormatString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *frLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];
    [dateFormatter setLocale:frLocale];
    [dateFormatter setDateFormat:@"dd/MM/yy"];
    NSString *strDate = [dateFormatter stringFromDate:self];
    return strDate;
}


-(NSString *)toGrilleTvUrlFormatString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy_MM_dd"];
    NSString *strDate = [dateFormatter stringFromDate:self];
    return strDate;
}

-(NSString *)toLastUpdateFormatString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *strDate = [dateFormatter stringFromDate:self];
    return strDate;
}

-(NSInteger)getHourEurope
{
    // A changer à cause de la diff de fuseau horaire
    unsigned hourAndMinuteFlags = NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"UMT"]];
    NSDateComponents* travelDateTimeComponents = [calendar components:hourAndMinuteFlags fromDate:self];
    NSString* hours = [NSString stringWithFormat:@"%02li", (long)[travelDateTimeComponents hour]];
    
    return [hours integerValue];
}

-(NSInteger)getHourCanada
{
    unsigned hourAndMinuteFlags = NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents* travelDateTimeComponents = [calendar components:hourAndMinuteFlags fromDate:self];
    NSString* hours = [NSString stringWithFormat:@"%02li", (long)[travelDateTimeComponents hour]];
    
    return [hours integerValue];
}

-(NSDate*)addDay:(NSInteger )day
{
    
    NSDateComponents* comps = [[NSDateComponents alloc]init];
    comps.day = day;
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDate* tomorrow = [calendar dateByAddingComponents:comps toDate:self options:0];

    
    return tomorrow;
}

- (BOOL)isSameDayAsDate:(NSDate*)otherDate {
    
    // From progrmr's answer...
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:self];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:otherDate];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}
@end
