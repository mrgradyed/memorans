//
//  MemoransLevelView.m
//  Memorans
//
//  Created by emi on 31/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransLevelView.h"
#import "MemoransColorConverter.h"

@implementation MemoransLevelView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

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
    self.layer.borderColor = [MemoransColorConverter colorFromHEXString:@"#E4B7F0"].CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 15;
}

- (void)drawRect:(CGRect)rect
{

    [[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:15] addClip];

    if (self.enabled)
    {

        UIImage *buttonImage = [UIImage imageNamed:self.imageID];

        [buttonImage drawInRect:self.bounds];
    }
}

@end
