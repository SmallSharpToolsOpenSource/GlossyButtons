//
//  GBGlossyButton.m
//  GlossyButtons
//
//  Created by Brennan Stehling on 4/6/12.
//  Copyright (c) 2012 SmallSharpTools LLC. All rights reserved.
//
//  Derived from GlossButton by Codepadawan
//  GitHub: https://github.com/Codepadawan/GlossButton
//  Blog: http://www.codepadawan.com/2011/06/iphone-glossy-buttons.html
//

#import "GBGlossyButton.h"

#import <QuartzCore/QuartzCore.h>

#pragma mark - C Helper Functions
#pragma mark -

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = [NSArray arrayWithObjects:(id)startColor, (id)endColor, nil];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
}

void drawLinearGloss(CGContextRef context, CGRect rect, BOOL reverse) {
    
	CGColorRef highlightStart = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.35].CGColor;
	CGColorRef highlightEnd = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1].CGColor;
    
    if (reverse) {
		
		CGRect half = CGRectMake(rect.origin.x, rect.origin.y+rect.size.height/2, rect.size.width, rect.size.height/2);    
		drawLinearGradient(context, half, highlightEnd, highlightStart);
	}
	else {
		CGRect half = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height/2);    
		drawLinearGradient(context, half, highlightStart, highlightEnd);
	}
    
}

void drawCurvedGloss(CGContextRef context, CGRect rect, CGFloat radius) {
	
	CGColorRef glossStart = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.6].CGColor;
	CGColorRef glossEnd = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1].CGColor;
    
	//CGFloat radius = 60.0f; //radius of gloss
	
	CGMutablePathRef glossPath = CGPathCreateMutable();
	
	CGContextSaveGState(context);
    CGPathMoveToPoint(glossPath, NULL, CGRectGetMidX(rect), CGRectGetMinY(rect)-radius+rect.size.height/2);
	CGPathAddArc(glossPath, NULL, CGRectGetMidX(rect), CGRectGetMinY(rect)-radius+rect.size.height/2, radius, 0.75f*M_PI, 0.25f*M_PI, YES);	
	CGPathCloseSubpath(glossPath);
	CGContextAddPath(context, glossPath);
	CGContextClip(context);
	
	CGMutablePathRef buttonPath=createRoundedRectForRect(rect, 6.0f);
	
	CGContextAddPath(context, buttonPath);
	CGContextClip(context);
	
	CGRect half = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height/2);    
    
	drawLinearGradient(context, half, glossStart, glossEnd);
	CGContextRestoreGState(context);
    
	CGPathRelease(buttonPath);
	CGPathRelease(glossPath);
}

CGMutablePathRef createRoundedRectForRect(CGRect rect, CGFloat radius) {
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMaxY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMaxY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMinY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMinY(rect), radius);
    CGPathCloseSubpath(path);
    
    return path;        
}

#pragma mark -

#define kButtonRadius 6.0

#pragma mark -

@implementation GBGlossyButton

#pragma mark - Properties
#pragma mark -

@synthesize selected = _selected;
@synthesize toggled=_toggled;
@synthesize hue = _hue;
@synthesize saturation = _saturation;
@synthesize brightness = _brightness;

#pragma mark - Memory Management
#pragma mark -

- (void)dealloc {
    [super dealloc];
}

#pragma mark - Lifecyle
#pragma mark -

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.opaque = NO;
        [self setColor:self.backgroundColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setColor:(UIColor *)color {
    [color getHue:&_hue saturation:&_saturation brightness:&_brightness alpha:nil];
    
    [self setNeedsDisplay];
}

- (void)setHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness {
	_hue=hue;
	_saturation=saturation;
	_brightness=brightness;
    
    [self setNeedsDisplay];
}

#pragma mark - Button View Lifecyle
#pragma mark -

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    CGFloat actualBrightness = _brightness;
    if (self.selected) {
        actualBrightness -= 0.10;
    }   
    
    CGColorRef blackColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor;
    CGColorRef highlightStart = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7].CGColor;
    CGColorRef highlightStop = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0].CGColor;
    
	CGColorRef outerTop = [UIColor colorWithHue:_hue saturation:_saturation brightness:1.0*actualBrightness alpha:1.0].CGColor;
    CGColorRef outerBottom = [UIColor colorWithHue:_hue saturation:_saturation brightness:0.80*actualBrightness alpha:1.0].CGColor;
	
    CGFloat outerMargin = 7.5f;
    CGRect outerRect = CGRectInset(self.bounds, outerMargin, outerMargin);            
    CGMutablePathRef outerPath = createRoundedRectForRect(outerRect, 6.0);
	
    // Draw gradient for outer path
	CGContextSaveGState(context);
	CGContextAddPath(context, outerPath);
	CGContextClip(context);
	drawLinearGradient(context, outerRect, outerTop, outerBottom);
    
	CGContextRestoreGState(context);
    
	if (!self.selected) {
        
		CGRect highlightRect = CGRectInset(outerRect, 1.0f, 1.0f);
		CGMutablePathRef highlightPath = createRoundedRectForRect(highlightRect, 6.0);
        
		CGContextSaveGState(context);
		CGContextAddPath(context, outerPath);
		CGContextAddPath(context, highlightPath);
		CGContextEOClip(context);
        
		drawLinearGradient(context, CGRectMake(outerRect.origin.x, outerRect.origin.y, outerRect.size.width, outerRect.size.height/3), highlightStart, highlightStop);
		CGContextRestoreGState(context);
		
		drawCurvedGloss(context, outerRect, 180);
		CFRelease(highlightPath);
        
	}
	else {
		//reverse non-curved gradient when pressed
		CGContextSaveGState(context);
		CGContextAddPath(context, outerPath);
		CGContextClip(context);
		drawLinearGloss(context, outerRect, TRUE);		
		CGContextRestoreGState(context);
		
	}
	if (!self.toggled) {
		//bottom highlight
		CGRect highlightRect2 = CGRectInset(self.bounds, 6.5f, 6.5f);
		CGMutablePathRef highlightPath2 = createRoundedRectForRect(highlightRect2, 6.0);
		
		CGContextSaveGState(context);
		CGContextSetLineWidth(context, 0.5);
		CGContextAddPath(context, highlightPath2);
		CGContextAddPath(context, outerPath);
		CGContextEOClip(context);
		drawLinearGradient(context, CGRectMake(self.bounds.origin.x, self.bounds.size.height-self.bounds.size.height/3, self.bounds.size.width, self.bounds.size.height/3), highlightStop, highlightStart);
        
		CGContextRestoreGState(context);
		CFRelease(highlightPath2);
	}
    else {
		//toggle marker
		CGRect toggleRect= CGRectInset(self.bounds, 5.0f, 5.0f);
		CGMutablePathRef togglePath= createRoundedRectForRect(toggleRect, 8.0);
        
		CGContextSaveGState(context);
		CGContextSetLineWidth(context, 3.5);
		CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
		CGContextAddPath(context, togglePath);
		CGContextStrokePath(context);
		CGContextRestoreGState(context);
		CFRelease(togglePath);
	}
    // Stroke outer path
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, blackColor);
    CGContextAddPath(context, outerPath);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    CFRelease(outerPath);
}

- (void)setToggled:(BOOL)toggled {
    if (_toggled == toggled) return;
    _toggled = toggled;
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected {
    if (_selected == selected) return;
    _selected = selected;
    [self setNeedsDisplay];
}

#pragma mark - UIResponder
#pragma mark -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.selected = YES;
    
    [self sendActionsForControlEvents:UIControlEventTouchDown];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.selected = NO;
    
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.selected = NO;
}

@end
