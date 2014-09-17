//
//  MemoransLevelsMenuControllerViewController.m
//  Memorans
//
//  Created by emi on 31/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransLevelsViewController.h"
#import "MemoransGameViewController.h"
#import "MemoransLevelButton.h"
#import "MemoransSharedLevelsPack.h"
#import "MemoransGameLevel.h"
#import "MemoransOverlayView.h"
#import "MemoransSharedAudioController.h"
#import "MemoransSharedLocalizationController.h"
#import "Utilities.h"

@interface MemoransLevelsViewController ()

#pragma mark - OUTLETS

@property(strong, nonatomic) IBOutletCollection(UIButton) NSArray *levelButtonViews;

@property(weak, nonatomic) IBOutlet UIButton *backToMenuButton;

#pragma mark - PROPERTIES

@property(strong, nonatomic) CAGradientLayer *gradientLayer;

@property(strong, nonatomic) AVAudioPlayer *musicPlayer;

@end

@implementation MemoransLevelsViewController

#pragma mark - SETTERS AND GETTERS

- (CAGradientLayer *)gradientLayer
{
    if (!_gradientLayer)
    {
        _gradientLayer = [Utilities randomGradient];

        _gradientLayer.frame = self.view.bounds;
    }

    return _gradientLayer;
}

#pragma mark - ACTIONS AND NAVIGATION

- (IBAction)backToMenuButtonTouched
{
    [[MemoransSharedAudioController sharedAudioController] playPopSound];

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)levelButtonTouched:(UIButton *)sender
{
    if ([sender isKindOfClass:[MemoransLevelButton class]])
    {
        [[MemoransSharedAudioController sharedAudioController] playPopSound];

        [self performSegueWithIdentifier:@"toGameController" sender:sender];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toGameController"])
    {
        MemoransGameViewController *gameController = segue.destinationViewController;

        MemoransLevelButton *levelButton = (MemoransLevelButton *)sender;

        NSInteger levelNumber = [self.levelButtonViews indexOfObject:levelButton];

        gameController.currentLevelNumber = levelNumber;
    }
}

#pragma mark - VIEWS MANAGEMENT AND UPDATE

- (void)viewDidLoad
{
    [super viewDidLoad];

    // This controller’s view was loaded into memory!

    self.view.multipleTouchEnabled = NO;

    [Utilities configureButton:self.backToMenuButton withTitleString:@"⬅︎" andFontSize:50];

    int loopCount = 0;

    NSString *levelButtonImage;

    for (MemoransLevelButton *levelButton in self.levelButtonViews)
    {
        levelButtonImage = [NSString stringWithFormat:@"Level%d", loopCount + 1];

        [levelButton setImage:[UIImage imageNamed:levelButtonImage] forState:UIControlStateNormal];

        levelButton.exclusiveTouch = YES;

        loopCount++;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    // This controller’s view is about to go on screen!

    [super viewWillAppear:animated];

    [self.view.layer insertSublayer:self.gradientLayer atIndex:0];

    MemoransGameLevel *level;

    int loopCount = 0;
    int highestCompletedLevel = 0;

    for (MemoransLevelButton *levelButton in self.levelButtonViews)
    {
        level =
            (MemoransGameLevel *)[MemoransSharedLevelsPack sharedLevelsPack].levelsPack[loopCount];

        if (loopCount == 0)
        {
            level.completed = YES;
        }

        levelButton.enabled = level.completed;

        if (level.completed)
        {
            highestCompletedLevel = loopCount;
        }

        loopCount++;
    }

    if (highestCompletedLevel + 1 < [self.levelButtonViews count])
    {
        ((MemoransLevelButton *)self.levelButtonViews[highestCompletedLevel + 1]).enabled = YES;
    }

    MemoransOverlayView *overlayView = [[MemoransOverlayView alloc]
        initWithString:[[MemoransSharedLocalizationController sharedLocalizationController]
                           localizedStringForKey:@"Pick\na Level"]
              andColor:nil
           andFontSize:150];

    [self.view addSubview:overlayView];

    [Utilities animateOverlayView:overlayView withDuration:1.5f];

    [[MemoransSharedAudioController sharedAudioController] playMusicFromResource:@"MoveForward"
                                                                          ofType:@"mp3"
                                                                      withVolume:0.3f];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // This controller’s view has gone OFF screen!

    [super viewDidDisappear:animated];

    [self.gradientLayer removeFromSuperlayer];

    self.gradientLayer = nil;
}

- (BOOL)prefersStatusBarHidden
{
    // Yes, we prefer the status bar hidden.

    return YES;
}

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

@end
