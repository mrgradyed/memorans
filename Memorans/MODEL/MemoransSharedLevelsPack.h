//
//  MemoransSharedLevelsPack.h
//  Memorans
//
//  Created by emi on 03/08/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MemoransGameLevel;

@interface MemoransSharedLevelsPack : NSObject

#pragma mark - PUBLIC PROPERTIES

@property(nonatomic, strong) NSMutableArray *levelsPack;

#pragma mark - PUBLIC METHODS

+ (instancetype)sharedLevelsPack;

- (BOOL)archiveLevelsStatus;

- (BOOL)removeLevelsStatusOnDisk;

- (void)setPartiallyPlayedLevel:(MemoransGameLevel *)level;

- (void)setHasSaveOnLevel:(MemoransGameLevel *)level;

@end
