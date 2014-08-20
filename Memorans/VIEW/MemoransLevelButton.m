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

#pragma mark - PROPERTIES

@property(strong, nonatomic) UIImageView *overlayLockView;

@end

@implementation MemoransLevelButton

#pragma mark - SETTERS AND GETTERS

- (UIView *)overlayLockView
{
    if (!_overlayLockView)
    {
        _overlayLockView = [[UIImageView alloc] initWithFrame:self.bounds];

        _overlayLockView.image = [UIImage imageNamed:@"lock"];
    }

    return _overlayLockView;
}

#pragma mark - VIEW DRAWING

- (void)drawRect:(CGRect)rect
{
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

#pragma mark - INIT

- (instancetype)initWithCoder:(NSCoder *)aDecoder
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
    self.clipsToBounds = YES;

    self.layer.borderColor = [Utilities colorFromHEXString:@"#2B2B2B" withAlpha:1].CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 15;
}

@end
