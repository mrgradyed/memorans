//
//  MemoransBackgroundView.m
//  Memorans
//
//  Created by emi on 18/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransBackgroundView.h"

@implementation MemoransBackgroundView

#pragma mark - DRAWING AND APPEARANCE

- (void)drawRect:(CGRect)rect
{
    UIImage *faceImage = [UIImage imageNamed:self.backgroundImage];

    [faceImage drawInRect:self.bounds];
}

#pragma mark - INITIALISERS

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}


@end
