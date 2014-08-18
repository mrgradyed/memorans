//
//  MemoransGradientView.m
//  Memorans
//
//  Created by emi on 18/08/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransGradientView.h"

@implementation MemoransGradientView

- (void)setStartColor:(UIColor *)startColor
{

    if ([_startColor isEqual:startColor])
    {
        return;
    }

    _startColor = startColor;

    [self setNeedsDisplay];
}

- (void)setEndColor:(UIColor *)endColor
{

    if ([_endColor isEqual:endColor])
    {
        return;
    }

    _endColor = endColor;

    [self setNeedsDisplay];
}

- (void)setMiddleColor:(UIColor *)middleColor
{

    if ([_middleColor isEqual:middleColor])
    {

        return;
    }
    _middleColor = middleColor;

    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentContext);

    CGColorSpaceRef myColorSpace = CGColorSpaceCreateDeviceRGB();

    CGFloat scRed, scGreen, scBlue, scAlpha;
    CGFloat mcRed, mcGreen, mcBlue, mcAlpha;
    CGFloat ecRed, ecGreen, ecBlue, ecAlpha;

    [self.startColor getRed:&scRed green:&scGreen blue:&scBlue alpha:&scAlpha];
    [self.middleColor getRed:&mcRed green:&mcGreen blue:&mcBlue alpha:&mcAlpha];
    [self.endColor getRed:&ecRed green:&ecGreen blue:&ecBlue alpha:&ecAlpha];

    CGFloat colorComponents[12] = { scRed,  scGreen, scBlue, scAlpha, mcRed,  mcGreen,
                                   mcBlue, mcAlpha, ecRed,  ecGreen, ecBlue, ecAlpha };

    CGFloat colorLocations[3] = { 0.0f, 0.5f, 1.0f };

    CGGradientRef myGradient =
        CGGradientCreateWithColorComponents(myColorSpace, colorComponents, colorLocations, 3);

    CGPoint gradientStartPoint = CGPointMake(self.bounds.origin.x, self.bounds.origin.y);

    CGPoint gradientStopPoint = CGPointMake(self.bounds.size.width, self.bounds.size.height);

    CGContextDrawLinearGradient(currentContext, myGradient, gradientStartPoint, gradientStopPoint,
                                0);

    CGGradientRelease(myGradient);
    CGColorSpaceRelease(myColorSpace);

    CGContextRestoreGState(currentContext);
}

@end
