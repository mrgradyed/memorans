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

@property(nonatomic) BOOL shown;

@property(nonatomic) BOOL paired;

@property(nonatomic) CGPoint onBoardCenter;

@end
