//
//  MemoransScoreOverlayView.h
//  Memorans
//
//  Created by emi on 21/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemoransOverlayView : UIView

#pragma mark - PUBLIC PROPERTIES

@property(nonatomic, strong) NSString *overlayString;

@property(nonatomic, strong) UIColor *overlayColor;

#pragma mark - PUBLIC METHODS

- (void)resetView;

@end
