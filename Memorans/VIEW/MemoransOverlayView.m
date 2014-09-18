//
//  MemoransScoreOverlayView.m
//  Memorans
//
//  Created by emi on 21/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransOverlayView.h"
#import "Utilities.h"

@interface MemoransOverlayView ()

#pragma mark - PROPERTIES

@property(strong, nonatomic) NSAttributedString *overlayAttributedString;

@property(nonatomic) CGPoint outOfScreenCenter;

@end

@implementation MemoransOverlayView

#pragma mark - SETTERS AND GETTERS

- (void)setOverlayString:(NSString *)overlayString
{
    if ([_overlayString isEqualToString:overlayString])
    {
        return;
    }

    _overlayString = overlayString;

    _overlayAttributedString = nil;

    [self resizeView];
}

- (void)setOverlayColor:(UIColor *)overlayColor
{
    if ([_overlayColor isEqual:overlayColor])
    {
        return;
    }
    _overlayColor = overlayColor;

    _overlayAttributedString = nil;

    [self setNeedsDisplay];
}

- (void)setFontSize:(CGFloat)fontSize
{
    if (_fontSize == fontSize)
    {
        return;
    }

    _fontSize = fontSize;

    _overlayAttributedString = nil;

    [self resizeView];
}

- (NSAttributedString *)overlayAttributedString
{
    if (!_overlayAttributedString)
    {
        NSString *overString = self.overlayString ? self.overlayString : @"!?";

        _overlayAttributedString = [Utilities styledAttributedStringWithString:overString
                                                                 andAlignement:NSTextAlignmentCenter
                                                                      andColor:self.overlayColor
                                                                       andSize:self.fontSize
                                                                andStrokeColor:nil];
    }

    return _overlayAttributedString;
}

- (CGPoint)outOfScreenCenter
{
    if (_outOfScreenCenter.x == CGPointZero.x || _outOfScreenCenter.y == CGPointZero.y)
    {
        // Get the screen's bounds.

        CGRect screenBounds = [[UIScreen mainScreen] bounds];

        // Get the controller's view's dimensions.

        CGFloat shortSide = MIN(screenBounds.size.width, screenBounds.size.height);
        CGFloat longSide = MAX(screenBounds.size.width, screenBounds.size.height);

        _outOfScreenCenter = CGPointMake(longSide * 2, shortSide / 2);
    }

    return _outOfScreenCenter;
}

#pragma mark - VIEW DRAWING

- (void)resetView
{
    if (self.center.x != self.outOfScreenCenter.x || self.center.y != self.outOfScreenCenter.y)
    {
        [self.layer removeAllAnimations];

        self.center = self.outOfScreenCenter;
        self.alpha = 1;
    }
}

- (void)resizeView
{
    CGSize newSize = [self.overlayAttributedString size];

    CGRect newBounds = self.bounds;

    newBounds.size = newSize;

    self.bounds = newBounds;

    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect { [self.overlayAttributedString drawInRect:self.bounds]; }

#pragma mark - INIT

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self)
    {
        [self configureView];
    }

    return self;
}

- (void)configureView
{
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeRedraw;
    self.userInteractionEnabled = NO;

    [self resetView];
}

- (instancetype)initWithString:(NSString *)string
                      andColor:(UIColor *)color
                   andFontSize:(CGFloat)fontSize
{
    self = [self initWithFrame:CGRectZero];

    _overlayString = string;

    _overlayColor = color;

    _fontSize = fontSize;

    [self resizeView];

    return self;
}

@end
