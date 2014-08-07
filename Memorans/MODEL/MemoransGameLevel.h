//
//  MemoransGameLevel.h
//  Memorans
//
//  Created by emi on 03/08/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemoransGameLevel : NSObject <NSCoding>

#pragma mark - PUBLIC PROPERTIES

@property(nonatomic, strong) NSString *tileSetType;

@property(nonatomic) NSInteger tilesInLevel;

@property(nonatomic) BOOL unlocked;

#pragma mark - PUBLIC METHODS

+ (NSArray *)allowedTilesCountsInLevels;

@end
