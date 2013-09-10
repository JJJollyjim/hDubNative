//
//  hdHTTPWrapper.h
//  hDubNative
//
//  Created by Jamie McClymont on 5/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hdHTTPWrapper : NSObject <NSURLConnectionDelegate> {
	NSMutableData *receivedData;
	int receivedLength;
	int statusCode;
	void (^successCallback) (NSString *response);
	void (^errorCallback) (NSString *errorMsg);
}

- (void)loginWithUser:(int)sid
						 password:(int)pass
							success:(void (^) (NSString *))success
								error:(void (^) (NSString *))error;

- (void)syncWithUser:(int)sid
            password:(int)pass
             higheid:(int)higheid
              events:(NSString *)events
             success:(void (^) (NSString *))success
               error:(void (^) (NSString *))error;

- (int)getLastStatusCode;

@end
