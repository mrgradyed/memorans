//
//  MemoransColorConverter.m
//  Memorans
//
//  Created by emi on 29/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "Utilities.h"
#import "MemoransOverlayView.h"

@implementation Utilities

#pragma mark - COLORS

+ (UIColor *)colorFromHEXString:(NSString *)hexString withAlpha:(CGFloat)alpha
{
    if ([hexString hasPrefix:@"#"])
    {
        hexString = [hexString substringFromIndex:1];
    }

    if ([hexString length] != 6)
    {
        return nil;
    }

    NSString *red = [hexString substringWithRange:NSMakeRange(0, 2)];
    NSString *green = [hexString substringWithRange:NSMakeRange(2, 2)];
    NSString *blue = [hexString substringWithRange:NSMakeRange(4, 2)];

    NSScanner *scanner = [NSScanner scannerWithString:red];

    unsigned redInt;

    if (![scanner scanHexInt:&redInt])
    {
        return nil;
    }

    scanner = [NSScanner scannerWithString:green];

    unsigned greenInt;

    if (![scanner scanHexInt:&greenInt])
    {
        return nil;
    }

    scanner = [NSScanner scannerWithString:blue];

    unsigned blueInt;

    if (![scanner scanHexInt:&blueInt])
    {
        return nil;
    }

    return [UIColor colorWithRed:redInt / 255.0f
                           green:greenInt / 255.0f
                            blue:blueInt / 255.0f
                           alpha:alpha];
}

+ (UIColor *)randomNiceColor
{
    CGFloat hue = (arc4random() % 360) / 359.0f;
    CGFloat saturation = (float)arc4random() / UINT32_MAX;
    CGFloat brightness = (float)arc4random() / UINT32_MAX;

    saturation = saturation < 0.5 ? 0.5 : saturation;
    brightness = brightness < 0.9 ? 0.9 : brightness;

    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

+ (CAGradientLayer *)randomGradient
{
    UIColor *startColor = [Utilities randomNiceColor];
    UIColor *middleColor = [Utilities randomNiceColor];
    UIColor *endColor = [Utilities randomNiceColor];

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];

    gradientLayer.colors =
        @[ (id)startColor.CGColor, (id)middleColor.CGColor, (id)endColor.CGColor ];

    gradientLayer.locations = @[ @(0.0f), @(0.5f), @(1.0f) ];

    gradientLayer.startPoint = CGPointMake(0.0f, 0.0f);
    gradientLayer.endPoint = CGPointMake(1.0f, 1.0f);

    return gradientLayer;
}

#pragma mark - OVERLAYS ANIMATION

+ (void)animateOverlayView:(MemoransOverlayView *)overlayView withDuration:(NSTimeInterval)duration
{
    for (UIView *subview in overlayView.superview.subviews)
    {
        if ([subview isKindOfClass:[MemoransOverlayView class]] && subview != overlayView)
        {
            [subview removeFromSuperview];
        }
    }

    [overlayView.superview bringSubviewToFront:overlayView];

    CGPoint newCenter = CGPointMake(overlayView.superview.center.x, overlayView.superview.center.y);

    [UIView animateWithDuration:0.3f
        animations:^{ overlayView.center = newCenter; }
        completion:^(BOOL finished) {

            [UIView animateWithDuration:0.3f
                delay:duration
                options:0
                animations:^{ overlayView.alpha = 0; }
                completion:^(BOOL finished) { [overlayView removeFromSuperview]; }];
        }];
}

#pragma mark - ATTRIBUTED STRINGS

+ (NSAttributedString *)styledAttributedStringWithString:(NSString *)string
                                           andAlignement:(NSTextAlignment)alignement
                                                andColor:(UIColor *)color
                                                 andSize:(CGFloat)size
                                          andStrokeColor:(UIColor *)strokeColor
{
    UIColor *dcolor = color ? color : [Utilities colorFromHEXString:@"#108cff" withAlpha:1];

    UIColor *dStrokeColor =
        strokeColor ? strokeColor : [UIColor whiteColor];

    CGFloat dsize = size ? size : 32;

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];

    paragraphStyle.alignment = alignement;

    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

    return [[NSAttributedString alloc]
        initWithString:string
            attributes:@
            {
                NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:dsize],
                NSForegroundColorAttributeName : dcolor,
                NSStrokeWidthAttributeName : @-3,
                NSStrokeColorAttributeName : dStrokeColor,
                NSParagraphStyleAttributeName : paragraphStyle,
            }];
}

#pragma mark - SYSTEM SOUNDS

+ (void)playSystemSoundEffectFromResource:(NSString *)fileName ofType:(NSString *)fileType
{
    if (!([@[ @"caf", @"aif", @"wav" ] containsObject:fileType]))
    {
        return;
    }

    dispatch_queue_t globalDefaultQueue =
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_async(globalDefaultQueue, ^(void) {

        NSString *soundEffectPath =
            [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];

        CFURLRef soundEffectUrl = CFBridgingRetain([NSURL fileURLWithPath:soundEffectPath]);

        SystemSoundID soundEffect;

        AudioServicesCreateSystemSoundID(soundEffectUrl, &soundEffect);

        CFRelease(soundEffectUrl);

        AudioServicesAddSystemSoundCompletion(soundEffect, NULL, NULL, disposeSoundEffect, NULL);

        AudioServicesPlaySystemSound(soundEffect);
    });
}

void disposeSoundEffect(soundEffect, inClientData)
{
    dispatch_queue_t globalDefaultQueue =
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_async(globalDefaultQueue, ^(void) { AudioServicesDisposeSystemSoundID(soundEffect); });
}

#pragma mark - SOUNDS EFFECTS VIA AVAudioPlayer

+ (dispatch_queue_t)sharedSoundEffectsSerialQueue
{
    static dispatch_queue_t soundEffectsSerialQueue;

    static dispatch_once_t blockHasCompleted;

    dispatch_once(&blockHasCompleted, ^{

        soundEffectsSerialQueue =
            dispatch_queue_create("SOUND_EFFECTS_SERIAL_QUEUE", DISPATCH_QUEUE_SERIAL);
    });

    return soundEffectsSerialQueue;
}

BOOL gSoundsOff = NO;

+ (void)playPopSound
{
    if (gSoundsOff)
    {
        return;
    }

    dispatch_async([Utilities sharedSoundEffectsSerialQueue], ^(void) {

        popSoundPlayer.currentTime = 0;

        [popSoundPlayer play];
    });
}

+ (void)playIiiiSound
{
    if (gSoundsOff)
    {
        return;
    }

    dispatch_async([Utilities sharedSoundEffectsSerialQueue], ^(void) {

        iiiiSoundPlayer.currentTime = 0;

        [iiiiSoundPlayer play];
    });
}

+ (void)playUiiiSound
{
    if (gSoundsOff)
    {
        return;
    }

    dispatch_async([Utilities sharedSoundEffectsSerialQueue], ^(void) {

        uiiiSoundPlayer.currentTime = 0;

        [uiiiSoundPlayer play];
    });
}

+ (void)playUeeeSound
{
    if (gSoundsOff)
    {
        return;
    }

    dispatch_async([Utilities sharedSoundEffectsSerialQueue], ^(void) {

        [uuueSoundPlayer stop];

        uuueSoundPlayer.currentTime = 0;

        [uuueSoundPlayer play];
    });
}

+ (AVAudioPlayer *)audioPlayerFromResource:(NSString *)fileName ofType:(NSString *)fileType
{
    NSBundle *appBundle = [NSBundle mainBundle];

    NSData *soundData =
        [NSData dataWithContentsOfFile:[appBundle pathForResource:fileName ofType:fileType]];

    NSError *error;

    AVAudioPlayer *player;

    player = [[AVAudioPlayer alloc] initWithData:soundData error:&error];

    player.numberOfLoops = 0;
    player.volume = 0.8;

    return player;
}

#pragma mark - CLASS INIT

static AVAudioPlayer *popSoundPlayer;
static AVAudioPlayer *iiiiSoundPlayer;
static AVAudioPlayer *uiiiSoundPlayer;
static AVAudioPlayer *uuueSoundPlayer;

+ (void)initialize
{
    if (self == [Utilities self])
    {
        popSoundPlayer = [Utilities audioPlayerFromResource:@"pop" ofType:@"caf"];
        iiiiSoundPlayer = [Utilities audioPlayerFromResource:@"iiii" ofType:@"caf"];
        uiiiSoundPlayer = [Utilities audioPlayerFromResource:@"uiii" ofType:@"caf"];
        uuueSoundPlayer = [Utilities audioPlayerFromResource:@"uuue" ofType:@"caf"];
    }
}

@end
