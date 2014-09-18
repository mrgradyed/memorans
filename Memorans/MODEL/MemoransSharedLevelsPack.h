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

// The array of levels available in the game.

@property(strong, nonatomic) NSArray *levelsPack;

#pragma mark - PUBLIC METHODS

// This method creates an instance of this class once and only once
// for the entire lifetime of the application.
// Do NOT use the init method to create an instance, it will just return an exception.

+ (instancetype)sharedLevelsPack;

// Save the levels status by archiving.

- (BOOL)archiveLevelsStatus;

// Remove the level status from disk (for testing only).

- (BOOL)deleteSavedLevelsStatus;

@end
