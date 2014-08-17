//
//  MemoransTile.h
//  Memorans
//
//  Created by emi on 01/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemoransTile : NSObject <NSCopying, NSCoding>

#pragma mark - PUBLIC PROPERTIES

@property(nonatomic) NSInteger tileValue;
@property(nonatomic) NSInteger tilePoints;

@property(strong, nonatomic) NSString *tileSetType;
@property(strong, nonatomic, readonly) NSString *tileID;

@property(nonatomic) BOOL selected;
@property(nonatomic) BOOL paired;

#pragma mark - PUBLIC METHODS

- (BOOL)isEqualToTile:(MemoransTile *)otherTile;

+ (NSArray *)allowedTileSets;

#pragma mark - GLOBAL VARS

extern const int gMaxTileValue;
extern const int gMinTileValue;

@end
