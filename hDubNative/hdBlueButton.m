//
//  hdBlueButton.m
//  hDubNative
//
//  Created by printfn on 13/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdBlueButton.h"

@implementation hdBlueButton

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self initStuff];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self initStuff];
	}
	return self;
}

- (void)initStuff {
	UIImage *buttonImage = [[UIImage imageNamed:@"blueButton.png"]
													resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
	UIImage *buttonImageHighlight = [[UIImage imageNamed:@"blueButtonHighlight.png"]
																	 resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
	// Set the background for any states you plan to use
	[self setBackgroundImage:buttonImage forState:UIControlStateNormal];
	[self setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
	
	[self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
	[self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
	[self setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
	
	[self setBackgroundColor:[UIColor clearColor]];
}


@end
