//
//  MemoransBackgroundView.m
//  Memorans
//
//  Created by emi on 18/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransBackgroundView.h"

@implementation MemoransBackgroundView

#pragma mark - INIT
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

#pragma mark - DRAWING

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // A gradient for the background.

    // Saving current context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentContext);

    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();

    CGFloat colorsComponents[8] = { 198 / 255.0f, 68 / 255.0f, 252 / 255.0f, 1,
                                    88 / 255.0f,  86 / 255.0f, 214 / 255.0f, 1 };

    CGFloat colorsLocations[2] = { 0, 1 };

    CGGradientRef backgroundGradient =
        CGGradientCreateWithColorComponents(rgbColorSpace, colorsComponents, colorsLocations, 2);

    CGPoint startPoint = CGPointMake(self.bounds.origin.x, self.bounds.origin.y);
    CGPoint stopPoint = CGPointMake(self.bounds.size.width, self.bounds.size.height);

    CGContextDrawLinearGradient(currentContext, backgroundGradient, startPoint, stopPoint, 0);

    CGGradientRelease(backgroundGradient);
    CGColorSpaceRelease(rgbColorSpace);

    // Restore context.
    CGContextRestoreGState(currentContext);
}

@end
