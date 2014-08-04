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

@property(nonatomic, strong) NSAttributedString *overlayAttributedString;

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

    self.overlayAttributedString = nil;

    [self resizeView];

    [self setNeedsDisplay];
}

- (void)setOverlayColor:(UIColor *)overlayColor
{
    if ([_overlayColor isEqual:overlayColor])
    {
        return;
    }
    _overlayColor = overlayColor;

    self.overlayAttributedString = nil;

    [self setNeedsDisplay];
}

- (void)setFontSize:(CGFloat)fontSize
{
    if (_fontSize == fontSize)
    {
        return;
    }

    _fontSize = fontSize;

    self.overlayAttributedString = nil;

    [self resizeView];

    [self setNeedsDisplay];
}

- (NSAttributedString *)overlayAttributedString
{
    if (!_overlayAttributedString)
    {
        NSString *overString = self.overlayString ? self.overlayString : @"!?";

        _overlayAttributedString = [[NSAttributedString alloc]
            initWithString:overString
                attributes:[Utilities stringAttributesWithColor:self.overlayColor
                                                        andSize:self.fontSize]];
    }

    return _overlayAttributedString;
}

- (CGPoint)outOfScreenCenter
{
    if (_outOfScreenCenter.x == CGPointZero.x)
    {
        CGRect screenBounds = [[UIScreen mainScreen] bounds];

        _outOfScreenCenter = CGPointMake(screenBounds.size.width + self.frame.size.width / 2,
                                         screenBounds.size.height + self.frame.size.height / 2);
    }
    return _outOfScreenCenter;
}

#pragma mark - DRAWING AND APPEARANCE

- (void)resizeView
{
    CGSize newSize = [self.overlayAttributedString size];

    CGRect newBounds = self.bounds;

    newBounds.size = newSize;

    self.bounds = newBounds;
}

- (void)resetView
{
    if (self.center.x != self.outOfScreenCenter.x)
    {
        [self.layer removeAllAnimations];
        self.center = self.outOfScreenCenter;
        self.alpha = 1;
    }
}

- (void)configureView
{
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeRedraw;
    self.userInteractionEnabled = NO;
}

- (void)drawRect:(CGRect)rect { [self.overlayAttributedString drawInRect:self.bounds]; }

#pragma mark - INITIALISERS

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self configureView];
    }
    return self;
}

@end