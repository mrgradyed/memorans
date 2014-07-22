//
//  MemoransScoreOverlayView.m
//  Memorans
//
//  Created by emi on 21/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransScoreOverlayView.h"

@interface MemoransScoreOverlayView ()

@property(nonatomic, strong) NSAttributedString *overlayScoreAttString;
@property(nonatomic) NSInteger overlayScore;

@end

@implementation MemoransScoreOverlayView

- (void)setOverlayScore:(NSInteger)scoreOverlay
{

    if (_overlayScore == scoreOverlay)
    {
        return;
    }
    _overlayScore = scoreOverlay;

    [self setNeedsDisplay];
}

- (NSAttributedString *)overlayScoreAttString
{

    UIColor *scoreColor;

    if (self.overlayScore < 0)
    {
        scoreColor = [UIColor redColor];
    }
    else
    {
        scoreColor = [UIColor purpleColor];
    }

    CGRect screenBounds = [[UIScreen mainScreen] bounds];

    _overlayScoreAttString = [[NSAttributedString alloc]
        initWithString:[NSString stringWithFormat:@"%d", (int)self.overlayScore]
            attributes:@{
                          NSFontAttributeName :
                              [UIFont boldSystemFontOfSize:screenBounds.size.height / 2],
                          NSForegroundColorAttributeName : scoreColor,
                          NSTextEffectAttributeName : NSTextEffectLetterpressStyle,
                       }];

    return _overlayScoreAttString;
}

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

- (instancetype)initWithScore:(NSInteger)score
{
    self.overlayScore = score;

    CGRect screenBounds = [[UIScreen mainScreen] bounds];

    CGSize viewSize = [self.overlayScoreAttString size];

    CGRect viewFrame = CGRectMake(screenBounds.size.width, screenBounds.size.height, viewSize.width,
                                  viewSize.height);

    return self = [self initWithFrame:viewFrame];
}

#pragma mark - DRAWING

- (void)configureView
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
    self.userInteractionEnabled = NO;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect { [self.overlayScoreAttString drawInRect:self.bounds]; }

@end
