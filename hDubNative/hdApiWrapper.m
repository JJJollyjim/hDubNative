//
//  hdApiWrapper.m
//  hDubNative
//
//  Created by printfn on 6/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdApiWrapper.h"
#import "hdHTTPWrapper.h"
#import "hdJsonWrapper.h"

@implementation hdApiWrapper

+ (void)checkLogin:(int)sid
							pass:(int)pass
					callback:(void (^) (BOOL, NSString *, NSString *))callback {
	hdHTTPWrapper *httpRequest = [[hdHTTPWrapper alloc] init];
	[httpRequest authenticateUser:sid
											 password:pass
												success:^void (NSString *response) {
													if ([response isEqual:@"yay"]) {
														callback(YES, nil, nil);
													} else {
														if ([response isEqual:@"nay"]) {
															callback(NO, @"Invalid Student ID Number or Login Code!", @"Authentication response: Nay");
														} else {
															callback(NO, @"An error occured logging you in. Please try again later.", [NSString stringWithFormat:@"No/invalid data received: %@\n  status code: %i", response, [httpRequest getLastStatusCode]]);
														}
													}
												}
													error:^void (NSString *errorMsg) {
														callback(NO, @"An error has occured during authentication. Please check your internet connection or try again later.", @"Network error.");
													}];
}

+ (void)getMessage:(int)sid
							pass:(int)pass
	 fromLoginScreen:(BOOL)login
					callback:(void (^) (BOOL, NSString *, NSString *))callback {
	hdHTTPWrapper *httpRequest = [[hdHTTPWrapper alloc] init];
	[httpRequest getMessage:sid
								 password:pass
					fromLoginScreen:login
									success:^void (NSString *response) {
										callback(YES, response, nil);
									}
										error:^void (NSString *errorMsg) {
											callback(NO, @"An error has occured during authentication. Please check your internet connection or try again later.", @"Network error.");
										}];
}


+ (void)indexerWithUser:(int)sid
									 pass:(int)pass
							 callback:(void (^) (BOOL, NSString *, NSString *))callback {
	hdHTTPWrapper *httpRequest = [[hdHTTPWrapper alloc] init];
	[httpRequest indexerWithUserId:sid
												password:pass
												 success:^void (NSString *response) {
													 NSDictionary *jsonObj = [hdJsonWrapper getObj:response];
													 if ([jsonObj valueForKey:@"success"] != nil) {
														 callback(YES, nil, nil);
													 } else {
														 NSString *errorStr = (NSString *)[jsonObj valueForKey:@"error"];
														 NSString *errorReport = [NSString stringWithFormat:@"errorStr: %@\n  statusCode: %i", errorStr, [httpRequest getLastStatusCode]];
														 if (errorStr == nil) {
															 callback(NO, @"A server error has occured. Please try again later.", errorReport);
														 }
														 if ([errorStr isEqual:@"Err1"]) {
															 callback(YES, nil, nil);
														 } else if ([errorStr isEqual:@"Err2"] || [errorStr isEqual:@"Err3"] || [errorStr isEqual:@"Err4"] || [errorStr isEqual:@"Err5"] || [errorStr isEqual:@"Err6"] || [errorStr isEqual:@"Err10"] || [errorStr isEqual:@"Err11"] || [errorStr isEqual:@"Err12"]) {
															 callback(NO, @"A database error has occured. Please try again later.", errorReport);
														 } else if ([errorStr isEqual:@"Err7"] || [errorStr isEqual:@"Err15"]) {
															 callback(NO, @"An authentication error has occured. Please try again later.", errorStr);
														 } else if ([errorStr isEqual:@"Err8"] || [errorStr isEqual:@"Err9"]) {
															 callback(NO, @"A server error has occured. Please try again later.", errorReport);
														 } else {
															 callback(NO, @"A server error has occured. Please try again later.", errorReport);
														 }
													 }
												 }
													 error:^void (NSString *errorMsg) {
														 callback(NO, @"An error has occured. Please check your internet connection or try again later.", @"No/invalid data received!");
													 }];
}

+ (void)downloadTimetableForUser:(int)sid
														pass:(int)pass
												callback:(void (^) (BOOL, NSString *, NSString *))callback {
	hdHTTPWrapper *httpRequest = [[hdHTTPWrapper alloc] init];
	[httpRequest getTimetableForUser:sid
													password:pass
													 success:^void (NSString *response) {
														 NSDictionary *jsonObj = [hdJsonWrapper getObj:response];
														 if (jsonObj != nil) {
															 // response = timetable json
															 callback(YES, response, nil);
														 } else {
															 NSString *errorStr = response;
															 NSString *errorReport = [NSString stringWithFormat:@"errorStr: %@\n  statusCode: %i", errorStr, [httpRequest getLastStatusCode]];
															 if (errorStr == nil) {
																 callback(NO, @"A server error has occured. Please try again later.", errorReport);
															 }
															 if ([errorStr isEqual:@"Err2"] || [errorStr isEqual:@"Err3"]
																	 || [errorStr isEqual:@"Err4"] || [errorStr isEqual:@"Err6"]) {
																 callback(NO, @"A database error has occured while downloading your timetable. Please try again later.", errorReport);
															 } else if ([errorStr isEqual:@"Err1"]) {
																 callback(NO, @"An authentication error has occured while downloading your timetable. Please try again later.", errorReport);
															 } else if ([errorStr isEqual:@"Err5"] || [errorStr isEqual:@"Err7"]) {
																 callback(NO, @"A data index error has occured. Please try again later.", errorReport);
															 } else {
																 callback(NO, @"A server error has occured. Please try again later.", errorReport);
															 }
														 }
													 }
														 error:^void (NSString *errorMsg) {
															 callback(NO, @"An error has occured. Please check your internet connection or try again later.", @"No/invalid data received!");
														 }];
}

+ (void)downloadHomeworkForUser:(int)sid
													 pass:(int)pass
											 callback:(void (^) (BOOL, NSString *, NSString *))callback {
	hdHTTPWrapper *httpRequest = [[hdHTTPWrapper alloc] init];
	[httpRequest downloadFullHomeworkForUser:sid
																	password:pass
																	 success:^void (NSString *response) {
																		 NSDictionary *jsonObj = [hdJsonWrapper getObj:response];
																		 if ([jsonObj valueForKey:@"error"] == nil) {
																			 callback(YES, response, nil);
																		 } else {
																			 NSString *errorStr = (NSString *)[jsonObj valueForKey:@"error"];
																			 NSString *errorReport = [NSString stringWithFormat:@"errorStr: %@\n  statusCode: %i", errorStr, [httpRequest getLastStatusCode]];
																			 if (errorStr == nil) {
																				 callback(NO, @"A server error has occured. Please try again later.", errorReport);
																			 }
																			 if ([errorStr isEqual:@"Err1"]) {
																				 callback(NO, @"An authentication error has occured. Please try again later.", errorReport);
																			 } else if ([errorStr isEqual:@"Err2"] || [errorStr isEqual:@"Err3"]
																									|| [errorStr isEqual:@"Err4"] || [errorStr isEqual:@"Err6"]) {
																				 callback(NO, @"A database error has occured. Please try again later.", errorReport);
																			 } else if ([errorStr isEqual:@"Err5"]) {
																				 callback(NO, @"A data index error has occured. Please try again later.", errorReport);
																			 } else {
																				 callback(NO, @"A server error has occured. Please try again later.", errorReport);
																			 }
																		 }
																	 }
																		 error:^void (NSString *errorMsg) {
																			 callback(NO, @"An error has occured. Please check your internet connection or try again later.", @"No/invalid data received!");
																		 }];
}



+ (void)uploadHomeworkForUser:(int)sid
												 pass:(int)pass
										 homework:(NSString *)homework
										 callback:(void (^) (BOOL, NSString *, NSString *))callback {
	hdHTTPWrapper *httpRequest = [[hdHTTPWrapper alloc] init];
	[httpRequest uploadFullHomeworkForUser:sid
																password:pass
														homeworkJson:homework
																 success:^void (NSString *response) {
																	 NSDictionary *jsonObj = [hdJsonWrapper getObj:response];
																	 if ([jsonObj valueForKey:@"success"] != nil) {
																		 callback(YES, response, nil);
																	 } else {
																		 NSString *errorStr = (NSString *)[jsonObj valueForKey:@"error"];
																		 NSString *errorReport = [NSString stringWithFormat:@"errorStr: %@\n  statusCode: %i", errorStr, [httpRequest getLastStatusCode]];
																		 if (errorStr == nil) {
																			 callback(NO, @"A server error has occured. Please try again later.", errorReport);
																		 }
																		 if ([errorStr isEqual:@"Err1"]) {
																			 callback(NO, @"An authentication error has occured. Please try again later.", errorReport);
																		 } else if ([errorStr isEqual:@"Err2"] || [errorStr isEqual:@"Err3"]
																								|| [errorStr isEqual:@"Err4"] || [errorStr isEqual:@"Err6"]) {
																			 callback(NO, @"A database error has occured. Please try again later.", errorReport);
																		 } else if ([errorStr isEqual:@"Err5"]) {
																			 callback(NO, @"A data index error has occured. Please try again later.", errorReport);
																		 } else {
																			 callback(NO, @"A server error has occured. Please try again later.", errorReport);
																		 }
																	 }
																 }
																	 error:^void (NSString *errorMsg) {
																		 callback(NO, @"An error has occured. Please check your internet connection or try again later.", @"No/invalid data received!");
																	 }];
}





+ (void)syncHomeworkForUser:(int)sid
											 pass:(int)pass
										higheid:(int)eid
										 events:(NSString *)events
									 callback:(void (^) (BOOL, NSString *, NSString *))callback {
	hdHTTPWrapper *httpRequest = [[hdHTTPWrapper alloc] init];
	[httpRequest syncForUser:sid
									password:pass
									 higheid:eid
										events:events
									 success:^void (NSString *response) {
										 NSDictionary *jsonObj = [hdJsonWrapper getObj:response];
										 if ([jsonObj valueForKey:@"success"] != nil) {
											 callback(YES, response, nil);
										 } else {
											 NSString *errorStr = (NSString *)[jsonObj valueForKey:@"error"];
											 NSString *errorReport = [NSString stringWithFormat:@"errorStr: %@\n  statusCode: %i", errorStr, [httpRequest getLastStatusCode]];
											 if (errorStr == nil) {
												 callback(NO, @"A server error has occured. Please try again later.", errorReport);
											 }
											 if ([errorStr isEqual:@"Err1"]) {
												 callback(NO, @"An authentication error has occured. Please try again later.", errorReport);
											 } else if ([errorStr isEqual:@"Err2"] || [errorStr isEqual:@"Err3"]
																	|| [errorStr isEqual:@"Err4"] || [errorStr isEqual:@"Err6"]
																	|| [errorStr isEqual:@"Err7"] || [errorStr isEqual:@"Err8"]
																	|| [errorStr isEqual:@"Err9"]) {
												 callback(NO, @"A database error has occured. Please try again later.", errorReport);
											 } else if ([errorStr isEqual:@"Err5"]) {
												 callback(NO, @"A data index error has occured. Please try again later.", errorReport);
											 } else {
												 callback(NO, @"A server error has occured. Please try again later.", errorReport);
											 }
										 }
									 }
										 error:^void (NSString *errorMsg) {
											 callback(NO, @"An error has occured. Please check your internet connection or try again later.", @"No/invalid data received!");
										 }];
}

@end
