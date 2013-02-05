//
//  hdHTTPDelegate.m
//  hDubNative
//
//  Created by Jamie McClymont on 5/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdHTTPDelegate.h"

@implementation hdHTTPDelegate

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	//Only called if redirect
	receivedData.length = 0;
	receivedLength = 0;
	NSLog(@"URL = %@", response.URL);
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[receivedData appendData:data];
	receivedLength += data.length;
	NSLog(@"Received %i bytes of data.", data.length);
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	receivedData = nil;
	NSLog(@"HTTP ERROR! %@", [error localizedDescription]);
}

- (void) connectionDidFinishLoading: (NSURLConnection *)connection {
	NSLog(@"Download finished!");
	char *response = (char *)receivedData.mutableBytes;
	response[receivedLength] = '\0';
	NSLog(@"%@", [[NSString alloc] initWithCString:response encoding:NSUTF8StringEncoding]);
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
	
	NSString *post = parameters;
	NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
	NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
	[request addValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];
	
	NSLog(@"Starting download!");
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if(connection) {
		receivedData = [NSMutableData data];
		receivedLength = 0;
		NSLog(@"Download started!");
	} else {
		NSLog(@"Connection failed!");
		//Connection failed
	}
}

@end
