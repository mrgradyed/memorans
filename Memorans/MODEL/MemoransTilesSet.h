//
//  MemoransTilesPile.h
//  Memorans
//
//  Created by emi on 02/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MemoransTile;

@interface MemoransTilesSet : NSObject <NSCoding>

#pragma mark - DESIGNATED INITIALISER

- (instancetype)initWithSetType:(NSString *)tileSetType;

#pragma mark - PUBLIC METHODS

- (MemoransTile *)extractRandomTileFromSet;

@end
