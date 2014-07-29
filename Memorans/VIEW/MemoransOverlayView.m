//
//  MemoransScoreOverlayView.m
//  Memorans
//
//  Created by emi on 21/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransOverlayView.h"

@interface MemoransOverlayView ()

#pragma mark - PROPERTIES

@property(nonatomic, strong) NSAttributedString *overlayAttributedString;

@property(nonatomic) BOOL textNeedsRefresh;

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

    self.textNeedsRefresh = YES;

    CGSize newSize = [self.overlayAttributedString size];

    CGRect newBounds = self.bounds;

    newBounds.size = newSize;

    self.bounds = newBounds;

    [self setNeedsDisplay];
}

- (void)setOverlayColor:(UIColor *)overlayColor
{
    if ([_overlayColor isEqual:overlayColor])
    {
        return;
    }
    _overlayColor = overlayColor;

    self.textNeedsRefresh = YES;

    [self setNeedsDisplay];
}

- (NSAttributedString *)overlayAttributedString
{
    if (!_overlayAttributedString || self.textNeedsRefresh)
    {
        self.textNeedsRefresh = NO;

        NSString *overString = self.overlayString ? self.overlayString : @"!?";

        UIColor *overColor = self.overlayColor ? self.overlayColor : [UIColor greenColor];

        CGRect screenBounds = [[UIScreen mainScreen] bounds];

        _overlayAttributedString = [[NSAttributedString alloc]
            initWithString:overString
                attributes:@{
                              NSFontAttributeName :
                                  [UIFont boldSystemFontOfSize:screenBounds.size.height / 3],
                              NSForegroundColorAttributeName : overColor,
                              NSTextEffectAttributeName : NSTextEffectLetterpressStyle,
                           }];
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

- (void)configureView
{
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeRedraw;
    self.userInteractionEnabled = NO;
    self.alpha = 1;

    self.center = self.outOfScreenCenter;
}

- (void)resetView { [self configureView]; }

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
