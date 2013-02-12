//
//  hdApiWrapper.h
//  hDubNative
//
//  Created by Jamie McClymont on 6/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hdApiWrapper : NSObject

+ (void)checkLogin:(int)sid
							pass:(int)pass
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

+ (void)syncHomeworkForUser:(int)sid
											 pass:(int)pass
									 callback:(void (^) (BOOL, NSString *, NSString *))callback;

@end
