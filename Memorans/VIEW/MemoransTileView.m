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

- (void)setImageID:(NSString *)imageID
{
    if ([_imageID isEqualToString:imageID])
    {
        return;
    }

    _imageID = imageID;
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

- (void)configureView
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
    self.multipleTouchEnabled = NO;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect =
        [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                   cornerRadius:self.bounds.size.height / 15];

    [roundedRect addClip];

    if (self.paired)
    {
        [[UIColor clearColor] setFill];
    }
    else
    {
        [[UIColor whiteColor] setFill];
    }

    UIRectFill(self.bounds);

    if (self.shown)
    {
        UIImage *faceImage = [UIImage imageNamed:[self imageID]];

        CGFloat imageSize = MIN(self.bounds.size.width, self.bounds.size.height);

        CGRect imageRect =
            CGRectMake((self.bounds.size.width - imageSize) / 2,
                       (self.bounds.size.height - imageSize) / 2, imageSize, imageSize);

        [faceImage drawInRect:imageRect];
    }
    else
    {
        UIFont *backFont =
            [[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1] fontWithSize:48];

        NSMutableParagraphStyle *parStyle = [[NSMutableParagraphStyle alloc] init];

        [parStyle setAlignment:NSTextAlignmentCenter];

        NSAttributedString *tileBackString =
            [[NSAttributedString alloc] initWithString:self.imageID
                                            attributes:@{
                                                          NSFontAttributeName : backFont,
                                                          NSParagraphStyleAttributeName : parStyle
                                                       }];

        [tileBackString drawInRect:self.bounds];
    }
}

@end
