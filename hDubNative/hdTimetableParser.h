//
//  hdTimetableParser.h
//  hDubNative
//
//  Created by Jamie McClymont on 6/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hdTimetableParser : NSObject

+ (void)initializeDateFormatter;

+ (NSString *)getSubjectForDay:(NSDate *)date period:(int)period rootObj:(NSDictionary *)obj;
+ (NSString *)getSubjectForDay:(NSDate *)date period:(int)period;
+ (NSString *)getRoomForDay:(NSDate *)date period:(int)period rootObj:(NSDictionary *)obj;
+ (NSString *)getRoomForDay:(NSDate *)date period:(int)period;
+ (NSString *)getTeacherForDay:(NSDate *)date period:(int)period rootObj:(NSDictionary *)obj;
+ (NSString *)getTeacherForDay:(NSDate *)date period:(int)period;

+ (BOOL)schoolOnDay:(NSDate *)date rootObj:(NSDictionary *)obj;

@end
