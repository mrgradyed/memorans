//
//  MemoransSharedAudioController.m
//  Memorans
//
//  Created by emi on 26/08/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//


#import "MemoransSharedAudioController.h"

@interface MemoransSharedAudioController () <AVAudioPlayerDelegate>

#pragma mark - PROPERTIES

@property(strong, nonatomic) AVAudioPlayer *iiiiPlayer;
@property(strong, nonatomic) AVAudioPlayer *uiiiPlayer;
@property(strong, nonatomic) AVAudioPlayer *uuuePlayer;
@property(strong, nonatomic) AVAudioPlayer *popPlayer;

@property(strong, nonatomic) AVAudioPlayer *musicPlayer;

@property(strong, nonatomic) NSString *currentMusicFileName;
@property(strong, nonatomic) NSString *currentMusicFileType;

@end

@implementation MemoransSharedAudioController

#pragma mark - GETTERS AND SETTERS

- (AVAudioPlayer *)iiiiPlayer
{
    if (!_iiiiPlayer)
    {

        _iiiiPlayer = [MemoransSharedAudioController audioPlayerFromResource:@"iiii"
                                                                      ofType:@"caf"
                                                                withDelegate:nil
                                                                      volume:0.4f
                                                            andNumberOfLoops:0];
    }
    return _iiiiPlayer;
}

- (AVAudioPlayer *)uiiiPlayer
{

    if (!_uiiiPlayer)
    {
        _uiiiPlayer = [MemoransSharedAudioController audioPlayerFromResource:@"uiii"
                                                                      ofType:@"caf"
                                                                withDelegate:nil
                                                                      volume:0.4f
                                                            andNumberOfLoops:0];
    }

    return _uiiiPlayer;
}

- (AVAudioPlayer *)uuuePlayer
{
    if (!_uuuePlayer)
    {
        _uuuePlayer = [MemoransSharedAudioController audioPlayerFromResource:@"uuue"
                                                                      ofType:@"caf"
                                                                withDelegate:nil
                                                                      volume:0.4f
                                                            andNumberOfLoops:0];
    }
    return _uuuePlayer;
}

- (AVAudioPlayer *)popPlayer
{
    if (!_popPlayer)
    {
        _popPlayer = [MemoransSharedAudioController audioPlayerFromResource:@"pop"
                                                                     ofType:@"caf"
                                                               withDelegate:nil
                                                                     volume:0.4f
                                                           andNumberOfLoops:0];
    }
    return _popPlayer;
}

- (void)setSoundsOff:(BOOL)soundsOff
{
    _soundsOff = soundsOff;

    if (soundsOff)
    {
        [_iiiiPlayer stop];
        [_uiiiPlayer stop];
        [_uuuePlayer stop];
        [_popPlayer stop];

        _iiiiPlayer = nil;
        _uiiiPlayer = nil;
        _uuuePlayer = nil;
        _popPlayer = nil;
    }
}

- (void)setMusicOff:(BOOL)musicOff
{
    _musicOff = musicOff;

    if (musicOff)
    {
        [_musicPlayer stop];

        _musicPlayer = nil;
    }
    else
    {
        _musicPlayer =
            [MemoransSharedAudioController audioPlayerFromResource:self.currentMusicFileName
                                                            ofType:self.currentMusicFileType
                                                      withDelegate:self
                                                            volume:0.4
                                                  andNumberOfLoops:-1];

        [_musicPlayer play];
    }
}

#pragma mark - SOUNDS EFFECTS PLAY

- (void)playIiiiSound
{
    if (self.soundsOff)
    {
        return;
    }

    dispatch_async([MemoransSharedAudioController sharedSoundEffectsSerialQueue], ^(void) {

        [self.iiiiPlayer stop];

        self.iiiiPlayer.currentTime = 0;

        [self.iiiiPlayer play];
    });
}

- (void)playUiiiSound
{
    if (self.soundsOff)
    {
        return;
    }

    dispatch_async([MemoransSharedAudioController sharedSoundEffectsSerialQueue], ^(void) {

        [self.uiiiPlayer stop];

        self.uiiiPlayer.currentTime = 0;

        [self.uiiiPlayer play];
    });
}

- (void)playUeeeSound
{
    if (self.soundsOff)
    {
        return;
    }

    dispatch_async([MemoransSharedAudioController sharedSoundEffectsSerialQueue], ^(void) {

        [self.uuuePlayer stop];

        self.uuuePlayer.currentTime = 0;

        [self.uuuePlayer play];
    });
}

- (void)playPopSound
{
    if (self.soundsOff)
    {
        return;
    }

    dispatch_async([MemoransSharedAudioController sharedSoundEffectsSerialQueue], ^(void) {

        [self.popPlayer stop];

        self.popPlayer.currentTime = 0;

        [self.popPlayer play];
    });
}

#pragma mark - MUSIC PLAY

- (void)playMusicFromResource:(NSString *)fileName
                       ofType:(NSString *)fileType
                   withVolume:(float)volume
{
    if (self.musicOff)
    {
        return;
    }

    dispatch_queue_t globalDefaultQueue =
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_async(globalDefaultQueue, ^(void) {

        self.currentMusicFileName = fileName;
        self.currentMusicFileType = fileType;

        [self.musicPlayer stop];
        self.musicPlayer = nil;

        self.musicPlayer = [MemoransSharedAudioController audioPlayerFromResource:fileName
                                                                           ofType:fileType
                                                                     withDelegate:self
                                                                           volume:volume
                                                                 andNumberOfLoops:-1];

        [self.musicPlayer prepareToPlay];
        [self.musicPlayer play];
    });
}

#pragma mark - CLASS METHODS

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

+ (AVAudioPlayer *)audioPlayerFromResource:(NSString *)fileName
                                    ofType:(NSString *)fileType
                              withDelegate:(id<AVAudioPlayerDelegate>)delegate
                                    volume:(float)volume
                          andNumberOfLoops:(NSInteger)numberOfLoops
{

    if (!fileName || !fileType)
    {
        return nil;
    }

    NSBundle *appBundle = [NSBundle mainBundle];

    NSData *soundData =
        [NSData dataWithContentsOfFile:[appBundle pathForResource:fileName ofType:fileType]];

    NSError *error;

    AVAudioPlayer *player;

    player = [[AVAudioPlayer alloc] initWithData:soundData error:&error];

    if (delegate)
    {
        player.delegate = delegate;
    }

    player.numberOfLoops = numberOfLoops;
    player.volume = volume;

    return player;
}

+ (instancetype)sharedAudioController
{
    static MemoransSharedAudioController *sharedAudioController;

    static dispatch_once_t blockHasCompleted;

    dispatch_once(&blockHasCompleted, ^{ sharedAudioController = [[self alloc] initActually]; });

    return sharedAudioController;
}

#pragma mark - INIT

- (instancetype)init
{
    @throw [NSException
        exceptionWithName:@"SingletonException"
                   reason:
                       @"Please use: [MemoransSharedAudioController sharedAudioController] instead."
                 userInfo:nil];

    return nil;
}

- (instancetype)initActually
{
    self = [super init];

    if (self)
    {
        NSError *categoryError;

        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient
                                               error:&categoryError];
    }

    return self;
}

#pragma mark - AVAudioPlayerDelegate PROTOCOL

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    if ([player isEqual:self.musicPlayer] && flags == AVAudioSessionInterruptionOptionShouldResume)
    {
        dispatch_queue_t globalDefaultQueue =
            dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

        dispatch_async(globalDefaultQueue, ^(void) {

            [player prepareToPlay];
            [player play];
        });
    }
}

@end
