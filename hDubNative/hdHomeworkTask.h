//
//  hdHomeworkTask.h
//  hDubNative
//
//  Created by printfn on 16/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hdHomeworkTask : NSObject <NSCopying>

@property (nonatomic) NSString *hwid;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *details;
@property (nonatomic) NSDate *date;
@property (nonatomic) int period;
@property (nonatomic) NSString *subject;
@property (nonatomic) NSString *teacher;
@property (nonatomic) NSString *room;

+ (NSString *)generateUUID;
- (void)setDateWithJsonDateStr:(NSString *)str;

@end
