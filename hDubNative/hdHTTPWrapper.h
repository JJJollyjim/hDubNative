//
//  hdHTTPWrapper.h
//  hDubNative
//
//  Created by printfn on 5/02/13.
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

- (void)authenticateUser:(int)sid
								password:(int)pass
								 success:(void (^) (NSString *))success
									 error:(void (^) (NSString *))error;

- (void)getMessage:(int)sid
					password:(int)pass
	 fromLoginScreen:(BOOL)login
					 success:(void (^) (NSString *))success
						 error:(void (^) (NSString *))error;

- (void)indexerWithUserId:(int)sid
								 password:(int)pass
									success:(void (^) (NSString *))success
										error:(void (^) (NSString *))error;

- (void)getTimetableForUser:(int)sid
									 password:(int)pass
										success:(void (^) (NSString *))success
											error:(void (^) (NSString *))error;

- (void)downloadFullHomeworkForUser:(int)sid
													 password:(int)pass
														success:(void (^) (NSString *))success
															error:(void (^) (NSString *))error;

- (void)uploadFullHomeworkForUser:(int)sid
												 password:(int)pass
										 homeworkJson:(NSString *)hw
													success:(void (^) (NSString *))success
														error:(void (^) (NSString *))error;

- (void)syncForUser:(int)sid
					 password:(int)pass
						higheid:(int)higheid
						 events:(NSString *)events
						success:(void (^) (NSString *))success
							error:(void (^) (NSString *))error;

- (int)getLastStatusCode;

@end
