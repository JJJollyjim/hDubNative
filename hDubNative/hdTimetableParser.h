//
//  hdTimetableParser.h
//  hDubNative
//
//  Created by printfn on 6/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hdTimetableParser : NSObject

+ (NSString *)getSubjectForDay:(NSDate *)date period:(int)period rootObj:(NSDictionary *)obj;
+ (BOOL)schoolOnDay:(NSDate *)date rootObj:(NSDictionary *)obj;

@end
