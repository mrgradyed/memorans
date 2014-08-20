//
//  MemoransGradientView.m
//  Memorans
//
//  Created by emi on 18/08/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransGradientView.h"
#import "Utilities.h"

@implementation MemoransGradientView

#pragma mark - SETTERS AND GETTERS

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

- (void)setBackgroundText:(NSString *)backgroundText
{

    if ([_backgroundText isEqualToString:backgroundText])
    {
        return;
    }

    _backgroundText = backgroundText;

    [self setNeedsDisplay];
}

- (void)setBackgroundTextColor:(UIColor *)backgroundTextColor
{

    if ([_backgroundTextColor isEqual:backgroundTextColor])
    {
        return;
    }

    _backgroundTextColor = backgroundTextColor;

    [self setNeedsDisplay];
}

- (void)setBackgroundTextFontSize:(CGFloat)backgroundTextFontSize
{

    if (_backgroundTextFontSize == backgroundTextFontSize)
    {
        return;
    }

    _backgroundTextFontSize = backgroundTextFontSize;

    [self setNeedsDisplay];
}

#pragma mark - VIEW DRAWING

- (void)drawRect:(CGRect)rect
{

    if (self.startColor && self.endColor)
    {
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        CGContextSaveGState(currentContext);

        CGColorSpaceRef myColorSpace = CGColorSpaceCreateDeviceRGB();

        CGFloat scRed, scGreen, scBlue, scAlpha;
        CGFloat ecRed, ecGreen, ecBlue, ecAlpha;

        [self.startColor getRed:&scRed green:&scGreen blue:&scBlue alpha:&scAlpha];
        [self.endColor getRed:&ecRed green:&ecGreen blue:&ecBlue alpha:&ecAlpha];

        CGGradientRef backGradient;

        if (self.middleColor)
        {
            CGFloat mcRed, mcGreen, mcBlue, mcAlpha;

            [self.middleColor getRed:&mcRed green:&mcGreen blue:&mcBlue alpha:&mcAlpha];

            CGFloat colorComponents[12] = { scRed,  scGreen, scBlue, scAlpha, mcRed,  mcGreen,
                                            mcBlue, mcAlpha, ecRed,  ecGreen, ecBlue, ecAlpha };

            CGFloat colorLocations[3] = { 0.0f, 0.5f, 1.0f };

            backGradient = CGGradientCreateWithColorComponents(myColorSpace, colorComponents,
                                                               colorLocations, 3);
        }
        else
        {
            CGFloat colorComponents[8] = { scRed, scGreen, scBlue, scAlpha,
                                           ecRed, ecGreen, ecBlue, ecAlpha };

            CGFloat colorLocations[2] = { 0.0f, 1.0f };

            backGradient = CGGradientCreateWithColorComponents(myColorSpace, colorComponents,
                                                               colorLocations, 2);
        }

        CGPoint gradientStartPoint = CGPointMake(self.bounds.origin.x, self.bounds.origin.y);

        CGPoint gradientStopPoint = CGPointMake(self.bounds.size.width, self.bounds.size.height);

        CGContextDrawLinearGradient(currentContext, backGradient, gradientStartPoint,
                                    gradientStopPoint, 0);

        CGGradientRelease(backGradient);

        CGColorSpaceRelease(myColorSpace);

        CGContextRestoreGState(currentContext);
    }

    if (self.backgroundText)
    {
        NSAttributedString *attributedBackgroundText =
            [Utilities styledAttributedStringWithString:self.backgroundText
                                                 andAlignement:NSTextAlignmentCenter
                                                      andColor:self.backgroundTextColor
                                                       andSize:self.backgroundTextFontSize andStrokeColor:nil];

        CGSize stringSize = [attributedBackgroundText size];

        CGRect stringRect = CGRectMake((self.bounds.size.width - stringSize.width) / 2,
                                       (self.bounds.size.height - stringSize.height) / 2,
                                       stringSize.width, stringSize.height);

        [attributedBackgroundText drawInRect:stringRect];
    }
}

@end
