//
//  MemoransBackgroundView.m
//  Memorans
//
//  Created by emi on 18/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransBackgroundView.h"
#import "Utilities.h"

@implementation MemoransBackgroundView

#pragma mark - DRAWING AND APPEARANCE

- (void)drawRect:(CGRect)rect
{
    if (self.backgroundImage)
    {
        UIImage *faceImage = [UIImage imageNamed:self.backgroundImage];

        [faceImage drawInRect:self.bounds];
    }

    if (self.backgroundText)
    {
        NSAttributedString *backgroundText = [[NSAttributedString alloc]
            initWithString:self.backgroundText
                attributes:[Utilities
                               stringAttributesWithAlignement:NSTextAlignmentCenter
                                                    withColor:[Utilities
                                                                  colorFromHEXString:@"#FFCC00"
                                                                           withAlpha:1]
                                                      andSize:60]];

        [backgroundText
            drawInRect:CGRectMake(self.bounds.origin.x + 100, self.bounds.origin.y + 100,
                                  self.bounds.size.width - 200, self.bounds.size.height - 200)];
    }
}

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

- (void)configureView
{
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeRedraw;
    self.multipleTouchEnabled = NO;
    self.clipsToBounds = YES;
}

@end
