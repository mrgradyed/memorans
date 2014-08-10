//
//  MemoransLevelView.m
//  Memorans
//
//  Created by emi on 31/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransLevelButton.h"
#import "Utilities.h"

@interface MemoransLevelButton ()

@property(nonatomic, strong) UIImageView *overlayLockView;

@end

@implementation MemoransLevelButton

- (UIView *)overlayLockView
{

    if (!_overlayLockView)
    {
        _overlayLockView = [[UIImageView alloc] initWithFrame:self.bounds];

        _overlayLockView.image = [UIImage imageNamed:@"lock"];
    }
    return _overlayLockView;
}

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
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 15;
    self.clipsToBounds = YES;
}

- (void)drawRect:(CGRect)rect
{

    UIImage *buttonImage = [UIImage imageNamed:self.imageID];

    [buttonImage drawInRect:self.bounds];

    if (self.enabled)
    {
        self.userInteractionEnabled = YES;

        [self.overlayLockView removeFromSuperview];
    }
    else
    {
        self.userInteractionEnabled = NO;

        [self addSubview:self.overlayLockView];
    }
}

@end
