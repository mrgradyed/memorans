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

// The actual text displayed by the overlay view.

@property(strong, nonatomic) NSString *overlayString;

// The overlay text colour.

@property(strong, nonatomic) UIColor *overlayColor;

// The overlay text font size.

@property(nonatomic) CGFloat fontSize;

#pragma mark - INIT

// A handy initialiser to get a totally configured overlay view.

- (instancetype)initWithString:(NSString *)string
                      andColor:(UIColor *)color
                   andFontSize:(CGFloat)fontSize;

@end
