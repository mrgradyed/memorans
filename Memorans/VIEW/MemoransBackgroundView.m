//
//  MemoransBackgroundView.m
//  Memorans
//
//  Created by emi on 18/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransBackgroundView.h"

@implementation MemoransBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Gradient

    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentContext);

    CGColorSpaceRef myColorSpace = CGColorSpaceCreateDeviceRGB();

    CGFloat colorComponents[8] = { 26 / 255.0f, 214 / 255.0f, 253 / 255.0f, 1.0f,
                                   29 / 255.0f, 98 / 255.0f,  240 / 255.0f, 1.0f };

    CGFloat colorLocations[2] = { 0.0f, 1.0f };

    CGGradientRef myGradient =
        CGGradientCreateWithColorComponents(myColorSpace, colorComponents, colorLocations, 2);

    CGPoint gradientStartPoint =
        CGPointMake(self.bounds.origin.x + self.bounds.size.width / 2, self.bounds.origin.y);

    CGPoint gradientStopPoint = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height);

    CGContextDrawLinearGradient(currentContext, myGradient, gradientStartPoint, gradientStopPoint,
                                0);

    CGGradientRelease(myGradient);
    CGColorSpaceRelease(myColorSpace);

    CGContextRestoreGState(currentContext);
}

@end
