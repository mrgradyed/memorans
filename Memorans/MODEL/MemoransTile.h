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

@property(nonatomic) NSString *tileSet;

@property(nonatomic, readonly) NSString *tileID;

@property(nonatomic) BOOL selected;

@property(nonatomic) BOOL paired;

#pragma mark - CLASS METHODS

extern const int maxTileValue;

extern const int minTileValue;

+ (NSArray *)allowedTileSets;

#pragma mark - INSTANCE METHODS

- (BOOL)isEqualToTile:(MemoransTile *)otherTile;

@end
