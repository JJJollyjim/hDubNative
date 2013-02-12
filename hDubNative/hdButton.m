//
//  hdButton.m
//  hDubNative
//
//  Created by Jamie McClymont on 10/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdButton.h"

@implementation hdButton

@synthesize backgroundLayer, highlightBackgroundLayer, innerGlow;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	// Call the parent implementation of initWithCoder
	self = [super initWithCoder:aDecoder];
	
	// Custom drawing methods
	if (self)
	{
		[self drawButton];
		[self drawInnerGlow];
		[self drawBackgroundLayer];
		//[self drawHighlightBackgroundLayer];
		highlightBackgroundLayer.hidden = YES;
	}
	
	return self;
}

- (void)drawButton
{
	// Get the root layer (any UIView subclass comes with one)
	CALayer *layer = self.layer;
	
	layer.cornerRadius = 4.5f;
	layer.borderWidth = 1;
	layer.borderColor = [UIColor colorWithRed:0.77f green:0.43f blue:0.00f alpha:1.00f].CGColor;
}

- (void)drawBackgroundLayer
{
	// Check if the property has been set already
	if (!self.backgroundLayer)
	{
		// Instantiate the gradient layer
		self.backgroundLayer = [CAGradientLayer layer];
		
		// Set the colors
		self.backgroundLayer.colors = (@[
																	 (id)[UIColor colorWithRed:0.281 green:0.608 blue:1.000 alpha:1.000].CGColor,
																	 (id)[UIColor colorWithRed:0.347 green:0.521 blue:0.910 alpha:1.000].CGColor
																	 ]);
		
		// Set the stops
		self.backgroundLayer.locations = (@[
																	@0.0f,
																	@1.0f
																	]);
		
		// Add the gradient to the layer hierarchy
		[self.layer insertSublayer:self.backgroundLayer atIndex:0];
	}
}

- (void)drawHighlightBackgroundLayer
{
	// Check if the property has been set already
	if (!self.backgroundLayer)
	{
		// Instantiate the gradient layer
		self.backgroundLayer = [CAGradientLayer layer];
		
		// Set the colors
		self.backgroundLayer.colors = (@[
																	 (id)[UIColor colorWithRed:0.000 green:0.247 blue:1.000 alpha:1.000].CGColor,
																	 (id)[UIColor blueColor].CGColor
																	 ]);
		
		// Set the stops
		self.backgroundLayer.locations = (@[
																			@0.0f,
																			@1.0f
																			]);
		
		// Add the gradient to the layer hierarchy
		[self.layer insertSublayer:self.backgroundLayer atIndex:0];
	}
}

- (void)drawInnerGlow
{
	if (!self.innerGlow)
	{
		// Instantiate the innerGlow layer
		self.innerGlow = [CALayer layer];
		
		self.innerGlow.cornerRadius= 4.5f;
		self.innerGlow.borderWidth = 1;
		self.innerGlow.borderColor = [[UIColor whiteColor] CGColor];
		self.innerGlow.opacity = 0.5;
		
		[self.layer insertSublayer:self.innerGlow atIndex:2];
	}
}

- (void)layoutSubviews
{
	// Set inner glow frame (1pt inset)
	self.innerGlow.frame = CGRectInset(self.bounds, 1, 1);
	
	// Set gradient frame (fill the whole button))
	self.backgroundLayer.frame = self.bounds;
	
	// Set inverted gradient frame
	self.highlightBackgroundLayer.frame = self.bounds;
	
	[super layoutSubviews];
}

- (void)setHighlighted:(BOOL)highlighted
{
	// Disable implicit animations
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	
	// Hide/show inverted gradient
	self.highlightBackgroundLayer.hidden = !highlighted;
	
	[CATransaction commit];
	
	[super setHighlighted:highlighted];
}

+ (hdButton *)buttonWithType:(UIButtonType)type
{
	return [super buttonWithType:UIButtonTypeCustom];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

@end
