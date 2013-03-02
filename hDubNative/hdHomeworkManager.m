//
//  hdHomeworkManager.m
//  hDubNative
//
//  Created by printfn on 21/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdHomeworkManager.h"

@implementation hdHomeworkManager

- (id)init {
	return [self initWithHomeworkJson:[hdDataStore sharedStore].homeworkJson];
}

- (id)initWithHomeworkJson:(NSString *)json {
	self = [super init];
	if (self) {
		//homeworkJson = json;
		//parsedDict = [hdJsonWrapper getObj:json];
		//homeworkRootDictionary = [parsedDict objectForKey:@"hw"];
		//higheid = ((NSString *)[parsedDict objectForKey:@"higheid"]).integerValue;
		//[self indexHomework];
	}
	return self;
}

@end
