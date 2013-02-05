//
//  hdHTTPDelegate.h
//  hDubNative
//
//  Created by Jamie McClymont on 5/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hdHTTPDelegate : NSObject <NSURLConnectionDelegate> {
	NSMutableData *receivedData;
	int receivedLength;
}

- (void) downloadURL:(NSURL *)url withMethod:(NSString *)method;

@end
