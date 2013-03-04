//
//  hdApiWrapper.h
//  hDubNative
//
//  Created by printfn on 6/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hdApiWrapper : NSObject

+ (void)checkLogin:(int)sid
							pass:(int)pass
					callback:(void (^) (BOOL, NSString *, NSString *))callback;

+ (void)getMessage:(int)sid
							pass:(int)pass
	 fromLoginScreen:(BOOL)login
					callback:(void (^) (BOOL, NSString *, NSString *))callback;

+ (void)indexerWithUser:(int)sid
									 pass:(int)pass
							 callback:(void (^) (BOOL, NSString *, NSString *))callback;

+ (void)downloadTimetableForUser:(int)sid
														pass:(int)pass
												callback:(void (^) (BOOL, NSString *, NSString *))callback;

+ (void)downloadHomeworkForUser:(int)sid
													 pass:(int)pass
											 callback:(void (^) (BOOL, NSString *, NSString *))callback;

+ (void)uploadHomeworkForUser:(int)sid
												 pass:(int)pass
										 homework:(NSString *)homework
										 callback:(void (^) (BOOL, NSString *, NSString *))callback;

+ (void)loginWithSid:(int)sid
								pass:(int)pass
						callback:(void (^) (BOOL, NSString *, NSString *))callback;

+ (void)syncHomeworkForUser:(int)sid
											 pass:(int)pass
										higheid:(int)eid
										 events:(NSString *)events
									 callback:(void (^) (BOOL, NSString *, NSString *))callback;

@end
