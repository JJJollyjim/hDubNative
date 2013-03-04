//
//  hdHTTPWrapper.m
//  hDubNative
//
//  Created by printfn on 5/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdHTTPWrapper.h"

// successCallback:
//   - (void)successCallback:(NSString *)response
//
// errorCallback:
//   - (void)errorCallback:(NSString *)errorDescription

@implementation hdHTTPWrapper

- (void)getMessage:(int)sid
					password:(int)pass
	 fromLoginScreen:(BOOL)login
					 success:(void (^) (NSString *))success
						 error:(void (^) (NSString *))error {
	successCallback = success;
	errorCallback = error;
	
	[self downloadURL:[NSURL URLWithString:
										 [[NSString alloc] initWithFormat:@"http://api1.hdubapp.com/message.php"]]
				 withMethod:@"POST"
				 parameters:[[NSString alloc] initWithFormat:@"login=%@&sid=%i&pass=%04i&os=ios&version=2.0", login == YES ? @"true" : @"false", sid, pass]];
}

- (void)loginWithUser:(int)sid
						 password:(int)pass
							success:(void (^) (NSString *))success
								error:(void (^) (NSString *))error {
	successCallback = success;
	errorCallback = error;
	
	[self downloadURL:[NSURL URLWithString:
										 [[NSString alloc] initWithFormat:@"http://api1.hdubapp.com/login.php"]]
				 withMethod:@"POST"
				 parameters:[[NSString alloc] initWithFormat:@"sid=%i&pass=%04i&os=ios&version=2.0", sid, pass]];
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
	statusCode = httpResponse.statusCode;
	receivedData.length = 0;
	receivedLength = 0;
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[receivedData appendData:data];
	receivedLength += data.length;
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	receivedData = nil;
	errorCallback([error localizedDescription]);
}

- (void) connectionDidFinishLoading: (NSURLConnection *)connection {
	char *response = (char *)receivedData.mutableBytes;
	response[receivedLength] = '\0';
	NSString *responseString = [[NSString alloc] initWithCString:response encoding:NSUTF8StringEncoding];
	successCallback(responseString);
}

- (NSCachedURLResponse *) connection: (NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
	return nil;
}

- (void) downloadURL:(NSURL *)url withMethod:(NSString *)method parameters:(NSString *)parameters {
	// withMethod: "GET", "POST"
	
	// parameters: "key1=val1&key2=val2
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url
																												 cachePolicy: NSURLRequestUseProtocolCachePolicy
																										 timeoutInterval: 30];
	request.HTTPMethod = method;
	
	if ([method isEqual:@"POST"]) {
		NSString *post = parameters;
		NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
		NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
		[request addValue:postLength forHTTPHeaderField:@"Content-Length"];
		[request setHTTPBody:postData];
	}
	
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (connection) {
		receivedData = [NSMutableData data];
		receivedLength = 0;
	} else {
		errorCallback(@"Connection failed!");
	}
}

- (int)getLastStatusCode {
	return statusCode;
}

@end
