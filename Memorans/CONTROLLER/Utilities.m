//
//  MemoransColorConverter.m
//  Memorans
//
//  Created by emi on 29/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

@import AudioToolbox;
@import AVFoundation;

#import "Utilities.h"
#import "MemoransOverlayView.h"

@implementation Utilities

#pragma mark - UTILITY METHODS

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

+ (void)animateOverlayView:(MemoransOverlayView *)overlayView withDuration:(NSTimeInterval)duration
{
    [overlayView resetView];

    [overlayView.superview bringSubviewToFront:overlayView];

    [UIView animateWithDuration:0.2f
        animations:^{ overlayView.center = overlayView.superview.center; }
        completion:^(BOOL finished) {
            [UIView animateWithDuration:duration
                animations:^{ overlayView.alpha = 0; }
                completion:^(BOOL finished) { [overlayView removeFromSuperview]; }];
        }];
}

+ (NSDictionary *)stringAttributesWithAlignement:(NSTextAlignment)alignement
                                       withColor:(UIColor *)color
                                         andSize:(CGFloat)size
{
    UIColor *dcolor = color ? color : [Utilities colorFromHEXString:@"#C643FC" withAlpha:1];

    CGFloat dsize = size ? size : 32;

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];

    paragraphStyle.alignment = alignement;

    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

    return @
    {
        NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:dsize],
        NSForegroundColorAttributeName : dcolor,
        NSStrokeWidthAttributeName : @-2,
        NSStrokeColorAttributeName : [UIColor blackColor],
        NSParagraphStyleAttributeName : paragraphStyle,
    };
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

+ (void)playPopSound
{

    dispatch_async([Utilities sharedSoundEffectsSerialQueue], ^(void) {

        popSoundPlayer.currentTime = 0;

        [popSoundPlayer play];
    });
}

+ (void)playIiiiSound
{

    dispatch_async([Utilities sharedSoundEffectsSerialQueue], ^(void) {

        iiiiSoundPlayer.currentTime = 0;

        [iiiiSoundPlayer play];
    });
}

+ (void)playUiiiSound
{

    dispatch_async([Utilities sharedSoundEffectsSerialQueue], ^(void) {

        uiiiSoundPlayer.currentTime = 0;

        [uiiiSoundPlayer play];
    });
}

+ (void)playUeeeSound
{

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
