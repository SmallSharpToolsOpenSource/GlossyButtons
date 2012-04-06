//
//  GBGlossyButton.h
//  GlossyButtons
//
//  Created by Brennan Stehling on 4/6/12.
//  Copyright (c) 2012 SmallSharpTools LLC. All rights reserved.
//
//  Derived from GlossButton by Codepadawan
//  GitHub: https://github.com/Codepadawan/GlossButton
//  Blog: http://www.codepadawan.com/2011/06/iphone-glossy-buttons.html
//


#import <Foundation/Foundation.h>

#define kHighlightTop 0
#define kHighlightBottom 1

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);
void drawLinearGloss(CGContextRef context, CGRect rect, BOOL reverse);
void drawCurvedGloss(CGContextRef context, CGRect rect, CGFloat radius);
CGMutablePathRef createRoundedRectForRect(CGRect rect, CGFloat radius);

@interface GBGlossyButton : UIButton

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL toggled;
@property (nonatomic, assign) CGFloat hue;
@property (nonatomic, assign) CGFloat saturation;
@property (nonatomic, assign) CGFloat brightness;

- (void)setColor:(UIColor *)color;

- (void)setHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness;

@end
