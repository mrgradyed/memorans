//
//  MemoransTileView.h
//  Memorans
//
//  Created by emi on 03/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemoransTileView : UIView <NSCoding>

#pragma mark - PUBLIC PROPERTIES

@property(strong, nonatomic) NSString *imageID;
@property(strong, nonatomic) NSString *tileBackImage;

@property(nonatomic) BOOL shown;
@property(nonatomic) BOOL paired;
@property(nonatomic) BOOL chosen;

@property(nonatomic) CGPoint onBoardCenter;

#pragma mark - PUBLIC METHODS

+ (NSArray *)allowedTileViewBacks;

@end
