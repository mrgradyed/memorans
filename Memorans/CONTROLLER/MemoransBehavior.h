//
//  MemoransBehavior.h
//  Memorans
//
//  Created by emi on 17/08/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemoransBehavior : UIDynamicBehavior

#pragma mark - PUBLIC METHODS

// This method adds an item to this custom behavior.

- (void)addItem:(id<UIDynamicItem>)item;

// This method removes an item from this custom behavior.

- (void)removeItem:(id<UIDynamicItem>)item;

#pragma mark - INIT

// An init method to initialise this custom behavior with an array of objects.

- (instancetype)initWithItems:(NSArray *)items;

@end
