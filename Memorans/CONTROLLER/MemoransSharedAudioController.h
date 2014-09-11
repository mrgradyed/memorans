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

// Music and sounds switch options.

@property(nonatomic) BOOL soundsOff;
@property(nonatomic) BOOL musicOff;

#pragma mark - PUBLIC METHODS

// This method creates an instance of this class once and only once
// for the entire lifetime of the application.
// Do NOT use the init method to create an instance, it will just return an exception.

+ (instancetype)sharedAudioController;

// This methods play sound effects on a serial dedicated queue.

- (void)playIiiiSound;
- (void)playUiiiSound;
- (void)playUeeeSound;
- (void)playPopSound;

// This method starts playing the specified music on the default priority global queue.

- (void)playMusicFromResource:(NSString *)fileName
                       ofType:(NSString *)fileType
                   withVolume:(float)volume;

@end
