//
//  MemoransTileView.m
//  Memorans
//
//  Created by emi on 03/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransTileView.h"


@implementation MemoransTileView

#pragma - SETTERS AND GETTERS


- (void)setImageID:(NSString *)tileViewContent
{
    if ([_imageID isEqualToString:tileViewContent])
    {
        return;
    }

    _imageID = tileViewContent;
    [self setNeedsDisplay];
}

- (void)setShown:(BOOL)selected
{
    if (_shown == selected)
    {
        return;
    }

    _shown = selected;
    [self setNeedsDisplay];
}

- (void)setPaired:(BOOL)paired
{
    if (_paired == paired)
    {
        return;
    }

    _paired = paired;
    [self setNeedsDisplay];
}

#pragma - INITIALISER

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self configureView];
    }
    return self;
}

#pragma - INSTANCE METHODS

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (self.shown)
    {
        [UIView transitionWithView:self
            duration:1.0
            options:UIViewAnimationOptionTransitionFlipFromLeft
            animations:^{ self.shown = NO; }
            completion:^(BOOL completed) {}];
    }
}

- (void)configureView
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
    self.multipleTouchEnabled = NO;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath *roundedRect =
        [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                   cornerRadius:self.bounds.size.height / 15];

    [roundedRect addClip];

    if (!self.paired)
    {
        [[UIColor whiteColor] setFill];
    }
    else
    {
        [[UIColor greenColor] setFill];
    }

    UIRectFill(self.bounds);

    if (self.shown)
    {
        UIImage *faceImage = [UIImage imageNamed:[self imageID]];
        [faceImage drawInRect:self.bounds];
    }
    else
    {
        UIFont *backFont =
            [[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1] fontWithSize:98];

        NSMutableParagraphStyle *parStyle = [[NSMutableParagraphStyle alloc] init];

        [parStyle setAlignment:NSTextAlignmentCenter];

        NSAttributedString *tileBackString =
            [[NSAttributedString alloc] initWithString:@"M"
                                            attributes:@{
                                                          NSFontAttributeName : backFont,
                                                          NSParagraphStyleAttributeName : parStyle
                                                       }];

        [tileBackString drawInRect:self.bounds];
    }
}

@end
