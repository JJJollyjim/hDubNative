//
//  hdTimetable.h
//  hDubNative
//
//  Created by Jamie McClymont on 5/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hdTimetable : NSObject {
	int _sid, _pass;
	void (^_success) (NSString *);
	void (^_error) (NSString *);
}

- (id)initWithStudentId:(int)sid
						andPassword:(int)pass
								success:(void (^) (NSString *))success
									error:(void (^) (NSString *))error;

@end
