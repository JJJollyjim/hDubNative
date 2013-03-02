//
//  hdHomeworkTask.m
//  hDubNative
//
//  Created by printfn on 22/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdHomeworkTask.h"

@implementation hdHomeworkTask

+ (NSString *)generateUUID {
	CFUUIDRef uuid = CFUUIDCreate(NULL);
	NSString *uuidStr = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
	CFRelease(uuid);
	return uuidStr;
}

- (void)setDateWithJsonDateStr:(NSString *)str {
	NSDateFormatter *f = [[NSDateFormatter alloc] init];
	f.dateFormat = @"yyyy-MM-dd";
	f.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
	f.timeZone = [NSTimeZone timeZoneWithName:@"NZST"];
	NSDate *midnight = [f dateFromString:str];
	self.date = [midnight dateByAddingTimeInterval:43200];
}

@end
