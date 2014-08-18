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

- (void)addItem:(id<UIDynamicItem>)item;

- (void)removeItem:(id<UIDynamicItem>)item;

#pragma mark - INIT

- (instancetype)initWithItems:(NSArray *)items;

@end
