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

#pragma mark - VIEW DRAWING

- (void)drawRect:(CGRect)rect
{
    if (self.backgroundImage)
    {
        UIImage *faceImage = [UIImage imageNamed:self.backgroundImage];

        [faceImage drawInRect:self.bounds];
    }
}

@end
