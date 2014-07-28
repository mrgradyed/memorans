//
//  MemoransTile.h
//  Memorans
//
//  Created by emi on 01/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemoransTile : NSObject <NSCopying>

#pragma mark - PROPERTIES

@property(nonatomic) NSInteger tileValue;

@property(nonatomic, strong) NSString *tileSet;
@property(nonatomic, strong, readonly) NSString *tileID;

@property(nonatomic) BOOL selected;
@property(nonatomic) BOOL paired;

#pragma mark - GLOBAL VARS

extern const int gMaxTileValue;
extern const int gMinTileValue;

#pragma mark - PUBLIC METHODS

- (BOOL)isEqualToTile:(MemoransTile *)otherTile;

+ (NSArray *)allowedTileSets;

@end
