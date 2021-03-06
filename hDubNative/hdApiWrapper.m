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

/*
 
 {
 "new_events": {
 "1": {
 "type":"del",
 "hwid":"091273"
 }
 },
 "new_high_eid":"191"
 }
 
 */

+ (void)syncWithUser:(int)sid
            password:(int)pass
             higheid:(int)higheid
              events:(NSString *)events
            callback:(void (^) (BOOL, NSString *, NSString *))callback {
	hdHTTPWrapper *httpRequest = [[hdHTTPWrapper alloc] init];
	[httpRequest syncWithUser:sid
                     password:pass
                      higheid:higheid
                       events:events
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
		NSString *errorReport = [NSString stringWithFormat:@"json: %@\n  statusCode: %i", json, [httpRequest getLastStatusCode]];
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
