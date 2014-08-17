//
//  MemoransColorConverter.h
//  Memorans
//
//  Created by emi on 29/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MemoransOverlayView;

@interface Utilities : NSObject

#pragma mark - PUBLIC METHODS

+ (UIColor *)colorFromHEXString:(NSString *)hexString withAlpha:(CGFloat)alpha;

+ (void)animateOverlayView:(MemoransOverlayView *)overlayView withDuration:(NSTimeInterval)duration;

+ (NSDictionary *)stringAttributesWithAlignement:(NSTextAlignment)alignement
                                       withColor:(UIColor *)color
                                         andSize:(CGFloat)size;

+ (void)playSystemSoundEffectFromResource:(NSString *)fileName ofType:(NSString *)fileType;

+ (void)playPopSound;

+ (void)playIiiiSound;

+ (void)playUiiiSound;

+ (void)playUeeeSound;

@end
