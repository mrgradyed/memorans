//
//  MemoransTileView.h
//  Memorans
//
//  Created by emi on 03/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemoransTileView : UIView

#pragma mark - PROPERTIES

@property(nonatomic) NSString *imageID;

// This flag is set to YES if tile is current selected.
@property(nonatomic) BOOL shown;

// This flag is to check if the tile has been correctly paired with its "twin".
@property(nonatomic) BOOL paired;

@property (nonatomic) CGPoint onBoardCenter;


@end
