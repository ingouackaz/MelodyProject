//
//  NSDate+ToNSString.h
//  UbinectV2
//
//  Created by Roger Ingouacka on 3/15/13.
//  Copyright (c) 2013 Roger Ingouacka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (toString)

-(NSString *)toNSString;
-(NSString *)toNSString2;
-(NSInteger)getHourEurope;
-(NSInteger)getHourCanada;
-(NSString *)toGrilleTvUrlFormatString;
-(NSString *)toGrilleTvDisplayFormatString;
-(NSDate*)addDay:(NSInteger )day;
- (BOOL)isSameDayAsDate:(NSDate*)otherDate;
-(NSString *)toProducedFormatString;
-(NSString *)toLastUpdateFormatString;

@end
