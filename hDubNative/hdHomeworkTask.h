//
//  hdHomeworkTask.h
//  hDubNative
//
//  Created by printfn on 16/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hdHomeworkTask : NSObject

@property (nonatomic) NSString *hwid;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *details;
@property (nonatomic) NSDate *date;
@property (nonatomic) int period;

+ (NSString *)generateUUID;
- (void)setDateWithJsonDateStr:(NSString *)str;

@end
