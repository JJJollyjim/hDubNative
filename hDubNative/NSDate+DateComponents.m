//
//  NSDate+DateComponents.m
//  hDubNative
//
//  Created by Jamie McClymont on 4/05/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "NSDate+DateComponents.h"

@implementation NSDate (DateComponents)

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    return [calendar dateFromComponents:components];
}

@end
