//
//  hdApiWrapper.m
//  hDubNative
//
//  Created by Jamie McClymont on 6/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdApiWrapper.h"
#import "hdHTTPWrapper.h"
#import "hdJsonWrapper.h"

@implementation hdApiWrapper

+ (void)checkLogin:(int)sid
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


+ (void)indexerWithUser:(int)sid
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
														 if (errorStr == nil) {
															 callback(NO, @"A server error has occured. Please try again later.");
														 }
														 if ([errorStr isEqual:@"Err1"]) {
															 callback(YES, nil);
														 } else if ([errorStr isEqual:@"Err2"] || [errorStr isEqual:@"Err3"] || [errorStr isEqual:@"Err4"] || [errorStr isEqual:@"Err5"] || [errorStr isEqual:@"Err6"] || [errorStr isEqual:@"Err10"] || [errorStr isEqual:@"Err11"] || [errorStr isEqual:@"Err12"]) {
															 callback(NO, @"A database error has occured. Please try again later.");
														 } else if ([errorStr isEqual:@"Err7"] || [errorStr isEqual:@"Err9"] || [errorStr isEqual:@"Err15"]) {
															 callback(NO, @"An authentication error has occured. Please try again later.");
														 } else if ([errorStr isEqual:@"Err8"]) {
															 callback(NO, @"A server error has occured. Please try again later.");
														 } else {
															 callback(NO, @"A server error has occured. Please try again later.");
														 }
													 }
												 }
													 error:^void (NSString *errorMsg) {
														 callback(NO, @"An error has occured. Please check your internet connection.");
													 }];
}

+ (void)downloadTimetableForUser:(int)sid
														pass:(int)pass
												callback:(void (^) (BOOL, NSString *))callback {
	hdHTTPWrapper *httpRequest = [[hdHTTPWrapper alloc] init];
	[httpRequest getTimetableForUser:sid
													password:pass
													 success:^void (NSString *response) {
														 NSLog(@"Response: %@", response);
														 NSDictionary *jsonObj = [hdJsonWrapper getObj:response];
														 if (jsonObj != nil) {
															 // response = timetable json
															 callback(YES, response);
														 } else {
															 NSString *errorStr = response;
															 if (errorStr == nil) {
																 callback(NO, @"A server error has occured. Please try again later.");
															 }
															 if ([errorStr isEqual:@"Err2"] || [errorStr isEqual:@"Err3"]
																	 || [errorStr isEqual:@"Err4"] || [errorStr isEqual:@"Err6"]) {
																 callback(NO, @"A database error has occured while downloading your timetable. Please try again later.");
															 } else if ([errorStr isEqual:@"Err1"]) {
																 callback(NO, @"An authentication error has occured while downloading your timetable. Please try again later.");
															 } else if ([errorStr isEqual:@"Err5"] || [errorStr isEqual:@"Err7"]) {
																 callback(NO, @"A data index error has occured. Please try again later.");
															 } else {
																 callback(NO, @"A server error has occured. Please try again later.");
															 }
														 }
													 }
														 error:^void (NSString *errorMsg) {
															 callback(NO, @"An error has occured. Please check your internet connection.");
														 }];
}

+ (void)downloadHomeworkForUser:(int)sid
													 pass:(int)pass
											 callback:(void (^) (BOOL, NSString *))callback {
	hdHTTPWrapper *httpRequest = [[hdHTTPWrapper alloc] init];
	[httpRequest downloadFullHomeworkForUser:sid
																	password:pass
																	 success:^void (NSString *response) {
																		 NSLog(@"Response: %@", response);
																		 NSDictionary *jsonObj = [hdJsonWrapper getObj:response];
																		 if ([jsonObj valueForKey:@"error"] == nil) {
																			 callback(YES, response);
																		 } else {
																			 NSString *errorStr = (NSString *)[jsonObj valueForKey:@"error"];
																			 if (errorStr == nil) {
																				 callback(NO, @"A server error has occured. Please try again later.");
																			 }
																			 if ([errorStr isEqual:@"Err1"]) {
																				 callback(NO, @"An authentication error has occured. Please try again later.");
																			 } else if ([errorStr isEqual:@"Err2"] || [errorStr isEqual:@"Err3"]
																									|| [errorStr isEqual:@"Err4"] || [errorStr isEqual:@"Err6"]) {
																				 callback(NO, @"A database error has occured. Please try again later.");
																			 } else if ([errorStr isEqual:@"Err5"]) {
																				 callback(NO, @"A data index error has occured. Please try again later.");
																			 } else {
																				 callback(NO, @"A server error has occured. Please try again later.");
																			 }
																		 }
																	 }
																		 error:^void (NSString *errorMsg) {
																			 callback(NO, @"An error has occured. Please check your internet connection.");
																		 }];
}



+ (void)uploadHomeworkForUser:(int)sid
												 pass:(int)pass
										 homework:(NSString *)homework
										 callback:(void (^) (BOOL, NSString *))callback {
	hdHTTPWrapper *httpRequest = [[hdHTTPWrapper alloc] init];
	[httpRequest uploadFullHomeworkForUser:sid
																password:pass
														homeworkJson:homework
																 success:^void (NSString *response) {
																	 NSLog(@"Response: %@", response);
																	 NSDictionary *jsonObj = [hdJsonWrapper getObj:response];
																	 if ([jsonObj valueForKey:@"success"] != nil) {
																		 callback(YES, response);
																	 } else {
																		 NSString *errorStr = (NSString *)[jsonObj valueForKey:@"error"];
																		 if (errorStr == nil) {
																			 callback(NO, @"A server error has occured. Please try again later.");
																		 }
																		 if ([errorStr isEqual:@"Err1"]) {
																			 callback(NO, @"An authentication error has occured. Please try again later.");
																		 } else if ([errorStr isEqual:@"Err2"] || [errorStr isEqual:@"Err3"]
																								|| [errorStr isEqual:@"Err4"] || [errorStr isEqual:@"Err6"]) {
																			 callback(NO, @"A database error has occured. Please try again later.");
																		 } else if ([errorStr isEqual:@"Err5"]) {
																			 callback(NO, @"A data index error has occured. Please try again later.");
																		 } else {
																			 callback(NO, @"A server error has occured. Please try again later.");
																		 }
																	 }
																 }
																	 error:^void (NSString *errorMsg) {
																		 callback(NO, @"An error has occured. Please check your internet connection.");
																	 }];
}





+ (void)syncHomeworkForUser:(int)sid
											 pass:(int)pass
									 callback:(void (^) (BOOL, NSString *))callback {
	hdHTTPWrapper *httpRequest = [[hdHTTPWrapper alloc] init];
	[httpRequest syncForUser:sid
									password:pass
									 higheid:0
										events:nil
									 success:^void (NSString *response) {
										 NSLog(@"Response: %@", response);
										 NSDictionary *jsonObj = [hdJsonWrapper getObj:response];
										 if ([jsonObj valueForKey:@"success"] != nil) {
											 callback(YES, response);
										 } else {
											 NSString *errorStr = (NSString *)[jsonObj valueForKey:@"error"];
											 if (errorStr == nil) {
												 callback(NO, @"A server error has occured. Please try again later.");
											 }
											 if ([errorStr isEqual:@"Err1"]) {
												 callback(NO, @"An authentication error has occured. Please try again later.");
											 } else if ([errorStr isEqual:@"Err2"] || [errorStr isEqual:@"Err3"]
																	|| [errorStr isEqual:@"Err4"] || [errorStr isEqual:@"Err6"]
																	|| [errorStr isEqual:@"Err7"] || [errorStr isEqual:@"Err8"]
																	|| [errorStr isEqual:@"Err9"]) {
												 callback(NO, @"A database error has occured. Please try again later.");
											 } else if ([errorStr isEqual:@"Err5"]) {
												 callback(NO, @"A data index error has occured. Please try again later.");
											 } else {
												 callback(NO, @"A server error has occured. Please try again later.");
											 }
										 }
									 }
										 error:^void (NSString *errorMsg) {
											 callback(NO, @"An error has occured. Please check your internet connection.");
										 }];
}

@end
