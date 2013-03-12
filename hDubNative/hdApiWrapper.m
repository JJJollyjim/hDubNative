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

+ (void)loginWithSid:(int)sid
								pass:(int)pass
						callback:(void (^) (BOOL, NSString *, NSString *))callback {
	hdHTTPWrapper *httpRequest = [[hdHTTPWrapper alloc] init];
	[httpRequest loginWithUser:sid
									password:pass
									 success:^void (NSString *response) {
										 [self handleErrorsInJson:response httpRequest:httpRequest callback:callback];
									 }
										 error:^void (NSString *errorMsg) {
											 callback(NO, @"An error has occured. Please check your internet connection or try again later.", @"No/invalid data received!");
										 }];
}

+ (void)handleErrorsInJson:(NSString *)json
							 httpRequest:(hdHTTPWrapper *)httpRequest
									callback:(void (^) (BOOL, NSString *, NSString *))callback {
	NSDictionary *jsonObj = [hdJsonWrapper getObj:json];
	if (jsonObj == nil || [jsonObj objectForKey:@"error"] != nil) {
		// Handle errors
		// auth, db, io, json, school, kamar
		NSString *error = [jsonObj objectForKey:@"error"];
		NSString *errorReport = [NSString stringWithFormat:@"json: {\"error_id\":\"%@\", \"error\":\"%@\"}\n  statusCode: %i", [jsonObj objectForKey:@"error_id"], error, [httpRequest getLastStatusCode]];
		NSString *userError = @"A server error has occured. Please try again later.";
		if ([error isEqualToString:@"auth"]) {
			userError = @"Invalid Student ID Number or Login Code!";
		} else if ([error isEqualToString:@"db"]||[error isEqualToString:@"io"]||[error isEqualToString:@"json"]) {
			userError = @"A server error has occured. Please try again later.";
		} else if ([error isEqualToString:@"school"]) {
			userError = @"A server error has occured while trying to communicate with your school. Please try again later.";
		} else if ([error isEqualToString:@"kamar"]) {
			userError = @"There was a problem communicating with your school. Please try again later.";
		}
		callback(NO, userError, errorReport);
	} else {
		callback(YES, json, nil);
	}
}

@end
