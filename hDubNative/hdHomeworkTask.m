//
//  hdHomeworkTask.m
//  hDubNative
//
//  Created by printfn on 22/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdHomeworkTask.h"
#import "hdDateUtils.h"

@implementation hdHomeworkTask

@synthesize date, details, hwid, name, period;

- (id)init {
	if (self = [super init]) {
		self.date = [hdDateUtils dateToJsonDate:[hdDateUtils correctDate:[NSDate date]]];
		self.details = @"";
		self.hwid = [hdHomeworkTask generateUUID];
		self.name = @"";
		self.period = 0;
	}
	return self;
}

+ (NSString *)generateUUID {
	CFUUIDRef uuid = CFUUIDCreate(NULL);
	NSString *uuidStr = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
	CFRelease(uuid);
	return [uuidStr lowercaseString];
}

- (void)setDateWithJsonDateStr:(NSString *)str {
	self.date = str;
}

- (NSComparisonResult)compareInteger:(int)i1 andInteger:(int)i2 {
    if (i1 > i2)
        return NSOrderedDescending;
    else if (i1 < i2)
        return NSOrderedAscending;
    else
        return NSOrderedSame;
}

- (NSComparisonResult)compare:(hdHomeworkTask *)otherTask {
    NSComparisonResult result;
    if ((result = [self.date compare:otherTask.date]) != NSOrderedSame) {
        return result;
    }
    if ((result = [self compareInteger:period andInteger:otherTask.period]) != NSOrderedSame) {
        return result;
    }
    if ((result = [self.name compare:otherTask.name]) != NSOrderedSame) {
        return result;
    }
    return NSOrderedSame;
}

- (id)copyWithZone:(NSZone *)zone {
    hdHomeworkTask *copy = [[hdHomeworkTask alloc] init];
    copy.date = [self.date copyWithZone:zone];
    copy.details = [self.details copyWithZone:zone];
    copy.hwid = [self.hwid copyWithZone:zone];
    copy.name = [self.name copyWithZone:zone];
    copy.period = self.period;
    return copy;
}

@end
