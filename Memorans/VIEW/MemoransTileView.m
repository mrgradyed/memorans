//
//  MemoransTileView.m
//  Memorans
//
//  Created by emi on 03/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransTileView.h"
#import "Utilities.h"

@interface MemoransTileView ()

@property(nonatomic) CGFloat defaultCornerRadius;

@end

@implementation MemoransTileView

#pragma mark - SETTERS AND GETTERS

- (CGFloat)defaultCornerRadius
{

    if (!_defaultCornerRadius)
    {
        _defaultCornerRadius = MIN(self.bounds.size.width, self.bounds.size.height) / 15;
    }
    return _defaultCornerRadius;
}

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

#pragma mark - DRAWING AND APPEARANCE

- (void)drawRect:(CGRect)rect
{
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
        UIImage *faceImage = [UIImage imageNamed:self.imageID];

        CGFloat imageSize = MIN(self.bounds.size.width, self.bounds.size.height);

        CGRect imageRect =
            CGRectMake((self.bounds.size.width - imageSize) / 2,
                       (self.bounds.size.height - imageSize) / 2, imageSize, imageSize);

        [faceImage drawInRect:imageRect];
    }
    else
    {
        UIImage *backImage = [UIImage imageNamed:self.tileBackImage];

        [backImage drawInRect:self.bounds];

        // JUST FOR TESTING, TO BE REMOVED - START -

        UIFont *backFont =
            [[UIFont preferredFontForTextStyle:UIFontTextStyleCaption1] fontWithSize:18];

        NSMutableParagraphStyle *parStyle = [[NSMutableParagraphStyle alloc] init];

        [parStyle setAlignment:NSTextAlignmentCenter];

        NSAttributedString *tileBackString =
            [[NSAttributedString alloc] initWithString:self.imageID
                                            attributes:@{
                                                          NSFontAttributeName : backFont,
                                                          NSParagraphStyleAttributeName : parStyle
                                                       }];

        [tileBackString drawInRect:self.bounds];

        // JUST FOR TESTING, TO BE REMOVED - END -
    }
}

- (void)configureView
{
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeRedraw;
    self.multipleTouchEnabled = NO;
    self.layer.borderColor = [Utilities colorFromHEXString:@"#E4B7F0" withAlpha:1].CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = self.defaultCornerRadius;
    self.clipsToBounds = YES;

}

#pragma mark - INIT

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self configureView];
    }
    return self;
}

#pragma mark - GLOBAL VARS AND CLASS METHODS

+ (NSArray *)allowedTileViewBacks { return @[ @"tb1", @"tb2", @"tb3" ]; }

@end
