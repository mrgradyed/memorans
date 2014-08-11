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

@property(nonatomic, strong) NSArray *levelsPack;

#pragma mark - PUBLIC METHODS

+ (instancetype)sharedLevelsPack;

- (BOOL)archiveLevelsStatus;

- (BOOL)removeLevelsStatusOnDisk;

@end
