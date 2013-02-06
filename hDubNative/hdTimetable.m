//
//  hdTimetable.m
//  hDubNative
//
//  Created by Jamie McClymont on 5/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdTimetable.h"
#import "hdHTTPWrapper.h"
#import "hdJsonWrapper.h"

@implementation hdTimetable

- (id)initWithStudentId:(int)sid
						andPassword:(int)pass
								success:(void (^) (NSString *))success
									error:(void (^) (NSString *))error {
	self = [super init];
	
	_success = success;
	_error = error;
	
	void (^timetableSuccess)() = ^{
		// SUCCESS!!!!!
		NSLog(@"SUCCESS!!!!!!!!");
	};
	
	[self checkLogin:sid pass:pass callback:^(BOOL success, NSString *error) {
		if (!success) {
			_error(error);
		} else {
			[self indexerWithUser:sid pass:pass callback:^(BOOL success, NSString *error) {
				if (!success) {
					if (error == nil) {
						_error(@"A server error has occured. Please try again later.");
					}
					if ([error isEqual:@"Err1"]) {
						timetableSuccess();
					} else if ([error isEqual:@"Err2"] || [error isEqual:@"Err3"] || [error isEqual:@"Err4"] || [error isEqual:@"Err5"] || [error isEqual:@"Err6"] || [error isEqual:@"Err10"] || [error isEqual:@"Err11"] || [error isEqual:@"Err12"]) {
						_error(@"A database error has occured. Please try again later.");
					} else if ([error isEqual:@"Err7"] || [error isEqual:@"Err9"] || [error isEqual:@"Err15"]) {
						_error(@"An authentication error has occured. Please try again later.");
					} else if ([error isEqual:@"Err8"]) {
						_error(@"A server error has occured. Please try again later.");
					} else {
						_error(@"A server error has occured. Please try again later.");
					}
				} else {
					timetableSuccess();
				}
			}];
		}
	}];
	
	return self;
}

- (void)checkLogin:(int)sid
							pass:(int)pass
					callback:(void (^) (BOOL, NSString *))callback {
	hdHTTPWrapper *httpRequest = [[hdHTTPWrapper alloc] init];
	[httpRequest authenticateUser:sid
											 password:pass
												success:^void (NSString *response) {
													NSLog(@"Response: %@", response);
													if ([response isEqual:@"yay"]) {
														callback(YES, nil);
													} else {
														if ([response isEqual:@"nay"]) {
															callback(NO, @"Invalid Student ID Number or Login Code!");
														} else {
															callback(NO, @"An error occured logging you in. Please try again later.");
														}
													}
												}
													error:^void (NSString *errorMsg) {
														callback(NO, @"An error has occured during authentication. Please check your internet connection.");
													}];
}

- (void)indexerWithUser:(int)sid
									 pass:(int)pass
							 callback:(void (^) (BOOL, NSString *))callback {
	hdHTTPWrapper *httpRequest = [[hdHTTPWrapper alloc] init];
	[httpRequest indexerWithUserId:sid
												password:pass
												 success:^void (NSString *response) {
													 NSLog(@"Response: %@", response);
													 NSDictionary *jsonObj = [hdJsonWrapper getObj:response];
													 if ([jsonObj valueForKey:@"success"] != nil) {
														 callback(YES, nil);
													 } else {
														 NSString *errorStr = (NSString *)[jsonObj valueForKey:@"error"];
														 callback(NO, [NSString stringWithFormat:@"Error: %@", errorStr]);
													 }
												 }
													 error:^void (NSString *errorMsg) {
														 callback(NO, @"An error has occured during authentication. Please check your internet connection.");
													 }];
}

@end
