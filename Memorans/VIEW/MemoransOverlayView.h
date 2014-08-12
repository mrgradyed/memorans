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

@property(strong, nonatomic) NSString *overlayString;

@property(strong, nonatomic) UIColor *overlayColor;

@property(nonatomic) CGFloat fontSize;

#pragma mark - PUBLIC METHODS

- (void)resetView;

#pragma mark - INIT

- (instancetype)initWithString:(NSString *)string
                      andColor:(UIColor *)color
                   andFontSize:(CGFloat)fontSize;

@end
