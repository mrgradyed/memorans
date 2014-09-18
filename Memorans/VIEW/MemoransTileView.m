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
        // We are already displaying that front image, don't waste time, exit.

        return;
    }

    _imageID = imageID;

    // We need to redraw with the new front image.

    [self setNeedsDisplay];
}

- (void)setTileBackImage:(NSString *)tileBackImage
{
    if ([_tileBackImage isEqualToString:tileBackImage])
    {
        // We are already displaying that back image, don't waste time, exit.

        return;
    }

    _tileBackImage = tileBackImage;

    // We need to redraw with the new back image.

    [self setNeedsDisplay];
}

- (void)setShown:(BOOL)shown
{
    if (_shown == shown)
    {
        return;
    }

    _shown = shown;

    // We need to redraw the tile view face up.

    [self setNeedsDisplay];
}

- (void)setPaired:(BOOL)paired
{
    if (_paired == paired)
    {
        return;
    }

    _paired = paired;

    // We need to redraw the tile as paired.

    [self setNeedsDisplay];
}

#pragma mark - VIEW DRAWING

- (void)drawRect:(CGRect)rect
{
    // This is a direct UIView subclass, we do not need to call super.

    if (self.paired)
    {
        // The tile is paired, make it transparent, and remove its border.

        [[UIColor clearColor] setFill];

        self.layer.borderWidth = 0;
    }
    else if (self.shown)
    {
        // The tile is face up, make it white.

        [[UIColor whiteColor] setFill];
    }
    else
    {
        // The tile is face down, make it black.

        [[Utilities colorFromHEXString:@"#2B2B2B" withAlpha:1] setFill];
    }

    // Fill the tile with the set color.

    UIRectFill(self.bounds);

    if (self.shown)
    {
        // The tile is face up. Let's draw the front image.

        // Get the image specified in the imageID property.

        UIImage *faceImage = [UIImage imageNamed:self.imageID];

        // Different levels have different number of tiles.
        // In order to accomodate different numbers of tiles in the same space, the tile's size and
        // aspect ratio change.

        // Get the tile view's shortest side.

        CGFloat shortestTileSide = MIN(self.bounds.size.width, self.bounds.size.height);

        // A rect in which we'll draw the tile's front image. To preserve image's aspect
        // ratio (tiles front images are square) we create a square rect with shortest tile view's
        // side
        // as sizes and we center it in the tile view's bounds.

        CGRect imageRect = CGRectMake((self.bounds.size.width - shortestTileSide) / 2,
                                      (self.bounds.size.height - shortestTileSide) / 2,
                                      shortestTileSide, shortestTileSide);

        // Draw the front image in the rect above.

        [faceImage drawInRect:imageRect];
    }
    else
    {
        // The tile is face down. Let's draw the back image.

        // Get the image specified in the tileBackImage property.

        UIImage *backImage = [UIImage imageNamed:self.tileBackImage];

        // Get the tile view's shortest side.

        CGFloat shortestTileSide = MIN(self.bounds.size.width, self.bounds.size.height);

        // A rect in which we'll draw the tile's front image. To preserve image's aspect
        // ratio (tiles front images are square) we create a square rect with shortest tile view's
        // side as sizes and we center it HORIZONTALLY in the tile view's bounds. We don't center it
        // vertically because the image is a "ribbon" which we want to always fall from top of the
        // tile view.

        CGRect imageRect = CGRectMake((self.bounds.size.width - shortestTileSide) / 2, 0,
                                      shortestTileSide, shortestTileSide);

        // Draw the front image in the rect above.

        [backImage drawInRect:imageRect];
    }
}

#pragma mark - INIT

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self)
    {
        // Configure the tile view.

        [self configureView];
    }
    return self;
}

- (void)configureView
{
    // We want the background to be transparent.

    self.backgroundColor = [UIColor clearColor];

    // Redisplay the view when the bounds change.

    self.contentMode = UIViewContentModeRedraw;

    // We want just tapping available.

    self.multipleTouchEnabled = NO;

    // Subviews won't escape the tile view's ROUNDED boundaries.

    self.clipsToBounds = YES;

    // 1px black border around the tile view.

    self.layer.borderColor = [Utilities colorFromHEXString:@"#2B2B2B" withAlpha:1].CGColor;
    self.layer.borderWidth = 1;

    // Tile views are quite rounded, the "roundness" is proportional to the shortest tile view's
    // dimension.

    self.layer.cornerRadius = MIN(self.bounds.size.width, self.bounds.size.height) / 15;
}

#pragma mark - NSCoding PROTOCOL

// From Apple docs: The NSCoding protocol declares the two methods that a class
// must implement so that instances of that class can be encoded and decoded. This capability
// provides the basis for archiving.

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    // The tile views are not unarchived from a storyboard, but we need the archiving functionality
    // to save their status on disk, in order to be able to save and resume partially played games.

    // The superclass (UIView) implements the NSCoding protocol, so we should call super.

    self = [super initWithCoder:aDecoder];

    if (self)
    {
        // Reload the tile view's status.

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
    // The tile views are not unarchived from a storyboard, but we need the archiving functionality
    // to save their status on disk, in order to be able to save and resume partially played games.

    // UIView implements the NSCoding protocol, so we should call super.

    [super encodeWithCoder:aCoder];

    // Save the tile view's status.

    [aCoder encodeObject:self.imageID forKey:@"imageID"];

    [aCoder encodeObject:self.tileBackImage forKey:@"tileBackImage"];

    [aCoder encodeBool:self.shown forKey:@"shown"];

    [aCoder encodeBool:self.paired forKey:@"paired"];

    [aCoder encodeBool:self.chosen forKey:@"chosen"];

    [aCoder encodeCGPoint:self.onBoardCenter forKey:@"onBoardCenter"];
}

@end
