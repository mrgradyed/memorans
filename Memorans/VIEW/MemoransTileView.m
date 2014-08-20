//
//  MemoransTileView.m
//  Memorans
//
//  Created by emi on 03/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransTileView.h"
#import "Utilities.h"

@implementation MemoransTileView

#pragma mark - SETTERS AND GETTERS

- (void)setImageID:(NSString *)imageID
{
    if ([_imageID isEqualToString:imageID])
    {
        return;
    }

    _imageID = imageID;

    [self setNeedsDisplay];
}

- (void)setTileBackImage:(NSString *)tileBackImage
{
    if ([_tileBackImage isEqualToString:tileBackImage])
    {
        return;
    }

    _tileBackImage = tileBackImage;

    [self setNeedsDisplay];
}

- (void)setShown:(BOOL)shown
{
    if (_shown == shown)
    {
        return;
    }

    _shown = shown;

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

#pragma mark - VIEW DRAWING

- (void)drawRect:(CGRect)rect
{
    if (self.paired)
    {
        [[UIColor clearColor] setFill];

        self.layer.borderWidth = 0;
    }
    else
    {
        [[UIColor whiteColor] setFill];
    }

    UIRectFill(self.bounds);

    if (self.shown)
    {
        UIImage *faceImage = [UIImage imageNamed:self.imageID];

        CGFloat shortestTileSide = MIN(self.bounds.size.width, self.bounds.size.height);

        CGRect imageRect = CGRectMake((self.bounds.size.width - shortestTileSide) / 2,
                                      (self.bounds.size.height - shortestTileSide) / 2,
                                      shortestTileSide, shortestTileSide);

        [faceImage drawInRect:imageRect];
    }
    else
    {
        UIImage *backImage = [UIImage imageNamed:self.tileBackImage];

        [backImage drawInRect:self.bounds];
/*
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
 */
    }
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

- (void)configureView
{
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeRedraw;
    self.multipleTouchEnabled = NO;
    self.clipsToBounds = YES;

    self.layer.borderColor = [Utilities colorFromHEXString:@"#1F1F21" withAlpha:1].CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = MIN(self.bounds.size.width, self.bounds.size.height) / 15;
}

#pragma mark - NSCoding PROTOCOL

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self)
    {
        _imageID = [aDecoder decodeObjectForKey:@"imageID"];

        _tileBackImage = [aDecoder decodeObjectForKey:@"tileBackImage"];

        _shown = [aDecoder decodeBoolForKey:@"shown"];

        _paired = [aDecoder decodeBoolForKey:@"paired"];

        _chosen = [aDecoder decodeBoolForKey:@"chosen"];

        _onBoardCenter = [aDecoder decodeCGPointForKey:@"onBoardCenter"];

        [self configureView];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];

    [aCoder encodeObject:self.imageID forKey:@"imageID"];

    [aCoder encodeObject:self.tileBackImage forKey:@"tileBackImage"];

    [aCoder encodeBool:self.shown forKey:@"shown"];

    [aCoder encodeBool:self.paired forKey:@"paired"];

    [aCoder encodeBool:self.chosen forKey:@"chosen"];

    [aCoder encodeCGPoint:self.onBoardCenter forKey:@"onBoardCenter"];
}

#pragma mark - CLASS METHODS

+ (NSArray *)allowedTileViewBacks { return @[ @"tb1", @"tb2", @"tb3" ]; }

@end
