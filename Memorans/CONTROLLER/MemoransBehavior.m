//
//  MemoransBehavior.m
//  Memorans
//
//  Created by emi on 17/08/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransBehavior.h"

@interface MemoransBehavior ()

#pragma mark - PROPERTIES

@property(strong, nonatomic) UIGravityBehavior *gravity;
@property(strong, nonatomic) UICollisionBehavior *collision;
@property(strong, nonatomic) UIDynamicItemBehavior *bouncing;

@end

@implementation MemoransBehavior

#pragma mark - SETTERS AND GETTERS

- (UIGravityBehavior *)gravity
{
    if (!_gravity)
    {
        _gravity = [[UIGravityBehavior alloc] init];
        _gravity.magnitude = 2.5f;
    }

    return _gravity;
}

- (UICollisionBehavior *)collision
{
    if (!_collision)
    {
        _collision = [[UICollisionBehavior alloc] init];
        _collision.translatesReferenceBoundsIntoBoundary = YES;
    }

    return _collision;
}

- (UIDynamicItemBehavior *)bouncing
{
    if (!_bouncing)
    {
        _bouncing = [[UIDynamicItemBehavior alloc] init];
        _bouncing.elasticity = 0.8f;
        _bouncing.allowsRotation = NO;
    }

    return _bouncing;
}

#pragma mark - ITEMS

- (void)addItem:(id<UIDynamicItem>)item
{
    [self.gravity addItem:item];
    [self.collision addItem:item];
    [self.bouncing addItem:item];
}

- (void)removeItem:(id<UIDynamicItem>)item
{
    [self.gravity removeItem:item];
    [self.collision removeItem:item];
    [self.bouncing removeItem:item];
}

#pragma mark - INIT

- (instancetype)init
{
    self = [super init];

    if (self)
    {
        [self addChildBehavior:self.gravity];
        [self addChildBehavior:self.collision];
        [self addChildBehavior:self.bouncing];
    }

    return self;
}

- (instancetype)initWithItems:(NSArray *)items
{
    self = [self init];

    if (self)
    {
        for (id<UIDynamicItem> item in items)
        {
            [self addItem:item];
        }
    }

    return self;
}



@end
