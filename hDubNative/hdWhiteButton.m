//
//  hdWhiteButton.m
//  hDubNative
//
//  Created by printfn on 13/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdWhiteButton.h"

@implementation hdWhiteButton

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
	UIImage *buttonImage = [[[UIImage alloc] initWithContentsOfFile:@"whiteButton.png"]
													resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
	UIImage *buttonImageHighlight = [[[UIImage alloc] initWithContentsOfFile:@"whiteButtonHighlight.png"]
																	 resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
	// Set the background for any states you plan to use
	[self setBackgroundImage:buttonImage forState:UIControlStateNormal];
	[self setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
	
	[self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
	[self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
	[self setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
	
	[self setBackgroundColor:[UIColor clearColor]];
}


@end
