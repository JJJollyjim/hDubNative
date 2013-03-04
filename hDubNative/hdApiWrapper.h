//
//  hdApiWrapper.h
//  hDubNative
//
//  Created by printfn on 6/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hdApiWrapper : NSObject

+ (void)getMessage:(int)sid
							pass:(int)pass
	 fromLoginScreen:(BOOL)login
					callback:(void (^) (BOOL, NSString *, NSString *))callback;

+ (void)loginWithSid:(int)sid
								pass:(int)pass
						callback:(void (^) (BOOL, NSString *, NSString *))callback;

@end
