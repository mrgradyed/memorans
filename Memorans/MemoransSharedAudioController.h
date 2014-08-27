//
//  MemoransSharedAudioController.h
//  Memorans
//
//  Created by emi on 26/08/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

@import AVFoundation;

#import <Foundation/Foundation.h>

@interface MemoransSharedAudioController : NSObject

#pragma mark - PUBLIC PROPERTIES

@property(nonatomic) BOOL soundsOff;
@property(nonatomic) BOOL musicOff;

#pragma mark - PUBLIC METHODS

+ (instancetype)sharedAudioController;

- (void)playIiiiSound;
- (void)playUiiiSound;
- (void)playUeeeSound;
- (void)playPopSound;

- (void)playMusicFromResource:(NSString *)fileName
                       ofType:(NSString *)fileType
                   withVolume:(float)volume;

@end
