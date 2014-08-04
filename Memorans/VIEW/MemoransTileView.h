//
//  MemoransTileView.h
//  Memorans
//
//  Created by emi on 03/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemoransTileView : UIView

#pragma mark - PUBLIC PROPERTIES

@property(nonatomic, strong) NSString *imageID;
@property(nonatomic, strong) NSString *tileBackImage;

@property(nonatomic) BOOL shown;
@property(nonatomic) BOOL paired;

@property(nonatomic) CGPoint onBoardCenter;

#pragma mark - PUBLIC METHODS

+ (NSArray *)allowedTileViewBacks;

@end
