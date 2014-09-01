//
//  MemoransColorConverter.h
//  Memorans
//
//  Created by emi on 29/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

@import AudioToolbox;
@import QuartzCore;

#import <Foundation/Foundation.h>

@class MemoransOverlayView;

@interface Utilities : NSObject

#pragma mark - PUBLIC METHODS

+ (UIColor *)colorFromHEXString:(NSString *)hexString withAlpha:(CGFloat)alpha;

+ (UIColor *)randomNiceColor;

+ (CAGradientLayer *)randomGradient;

+ (void)animateOverlayView:(MemoransOverlayView *)overlayView withDuration:(NSTimeInterval)duration;

+ (void)addWobblingAnimationToView:(UIView *)view
                   withRepeatCount:(float)repeatCount
                       andDelegate:(id)delegate;

+ (NSAttributedString *)styledAttributedStringWithString:(NSString *)string
                                           andAlignement:(NSTextAlignment)alignement
                                                andColor:(UIColor *)color
                                                 andSize:(CGFloat)size
                                          andStrokeColor:(UIColor *)strokeColor;

+ (void)configureButton:(UIButton *)button
        withTitleString:(NSString *)titleString
            andFontSize:(CGFloat)size;

+ (void)playSystemSoundEffectFromResource:(NSString *)fileName ofType:(NSString *)fileType;

@end
