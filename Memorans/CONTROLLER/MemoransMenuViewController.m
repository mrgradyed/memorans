//
//  MemoransMenuViewController.m
//  Memorans
//
//  Created by emi on 05/08/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

@import AVFoundation;

#import "MemoransMenuViewController.h"
#import "Utilities.h"

@interface MemoransMenuViewController () <AVAudioPlayerDelegate>

#pragma mark - OUTLETS

@property(weak, nonatomic) IBOutlet UIButton *playButton;
@property(weak, nonatomic) IBOutlet UIButton *musicButton;
@property(weak, nonatomic) IBOutlet UIButton *creditsButton;

@property(strong, nonatomic) AVAudioPlayer *musicPlayer;

@property(nonatomic) BOOL playingFirstTrack;
@property(nonatomic) BOOL musicOff;

@end

@implementation MemoransMenuViewController

#pragma mark - ACTIONS AND NAVIGATION

- (IBAction)playButtonTouched
{
    [Utilities playSoundEffectFromResource:@"pop" ofType:@"wav"];

    [self performSegueWithIdentifier:@"toLevelsController" sender:self];
}
- (IBAction)musicButtonTouched
{
    [Utilities playSoundEffectFromResource:@"pop" ofType:@"wav"];

    self.musicOff = !self.musicOff;

    NSAttributedString *musicButtonString = [[NSAttributedString alloc]
        initWithString:self.musicOff ? @"Music: Off" : @"Music: On"
            attributes:[Utilities stringAttributesWithAlignement:NSTextAlignmentCenter
                                                       withColor:nil
                                                         andSize:80]];

    [self.musicButton setAttributedTitle:musicButtonString forState:UIControlStateNormal];

    if (self.musicOff)
    {
        self.musicPlayer = nil;
        self.playingFirstTrack = NO;
    }
    else
    {
        [self startPlayingMusicFromResource:@"JauntyGumption" ofType:@"mp3"];
        self.playingFirstTrack = YES;
    }
}

- (IBAction)creditsButtonTouched
{
    [Utilities playSoundEffectFromResource:@"pop" ofType:@"wav"];

    [self performSegueWithIdentifier:@"toCreditsController" sender:self];
}

#pragma mark - VIEWS MANAGEMENT AND UPDATE

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = YES;

    self.view.multipleTouchEnabled = NO;

    UIImageView *backgroundImageView =
        [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SkewedWaves"]];

    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];

    NSAttributedString *playGameString = [[NSAttributedString alloc]
        initWithString:@"Play"
            attributes:[Utilities stringAttributesWithAlignement:NSTextAlignmentCenter
                                                       withColor:nil
                                                         andSize:80]];

    [self.playButton setAttributedTitle:playGameString forState:UIControlStateNormal];

    self.playButton.exclusiveTouch = YES;

    NSAttributedString *musicButtonString = [[NSAttributedString alloc]
        initWithString:@"Music: On"
            attributes:[Utilities stringAttributesWithAlignement:NSTextAlignmentCenter
                                                       withColor:nil
                                                         andSize:80]];

    [self.musicButton setAttributedTitle:musicButtonString forState:UIControlStateNormal];

    self.musicButton.exclusiveTouch = YES;

    NSAttributedString *creditsString = [[NSAttributedString alloc]
        initWithString:@"Credits"
            attributes:[Utilities stringAttributesWithAlignement:NSTextAlignmentCenter
                                                       withColor:nil
                                                         andSize:80]];

    [self.creditsButton setAttributedTitle:creditsString forState:UIControlStateNormal];

    self.creditsButton.exclusiveTouch = YES;

    [self startPlayingMusicFromResource:@"JauntyGumption" ofType:@"mp3"];
    self.playingFirstTrack = YES;
}

- (BOOL)prefersStatusBarHidden { return YES; }

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

#pragma mark - MUSIC

- (void)startPlayingMusicFromResource:(NSString *)fileName ofType:(NSString *)fileType
{
    dispatch_queue_t globalDefaultQueue =
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_async(globalDefaultQueue, ^(void) {

        NSBundle *appBundle = [NSBundle mainBundle];

        NSData *musicData =
            [NSData dataWithContentsOfFile:[appBundle pathForResource:fileName ofType:fileType]];

        NSError *error;

        self.musicPlayer = nil;

        self.musicPlayer = [[AVAudioPlayer alloc] initWithData:musicData error:&error];

        self.musicPlayer.delegate = self;
        self.musicPlayer.numberOfLoops = 0;
        self.musicPlayer.volume = 0.3;

        [self.musicPlayer prepareToPlay];
        [self.musicPlayer play];
    });
}

#pragma mark - AVAudioPlayerDelegate PROTOCOL

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    if ([player isEqual:self.musicPlayer] && flags == AVAudioSessionInterruptionOptionShouldResume)
    {
        dispatch_queue_t globalDefaultQueue =
            dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

        dispatch_async(globalDefaultQueue, ^(void) { [self.musicPlayer play]; });
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if ([player isEqual:self.musicPlayer] && flag)
    {
        if (self.playingFirstTrack)
        {
            [self startPlayingMusicFromResource:@"PixelPeekerPolka-slower" ofType:@"mp3"];
            self.playingFirstTrack = NO;
        }
        else
        {
            [self startPlayingMusicFromResource:@"JauntyGumption" ofType:@"mp3"];
            self.playingFirstTrack = YES;
        }
    }
}

@end
