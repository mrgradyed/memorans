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

// A collection of buttons representing the levels.

@property(strong, nonatomic) IBOutletCollection(UIButton) NSArray *levelButtonViews;

// A button for going back to the main menu screeen.

@property(weak, nonatomic) IBOutlet UIButton *backToMenuButton;

#pragma mark - PROPERTIES

// A gradient layer for the background.

@property(strong, nonatomic) CAGradientLayer *gradientLayer;

@end

@implementation MemoransLevelsViewController

#pragma mark - SETTERS AND GETTERS

- (CAGradientLayer *)gradientLayer
{
    if (!_gradientLayer)
    {
        // Get a random gradient for the background.

        _gradientLayer = [Utilities randomGradient];

        // Gradient must cover the whole controller's view.

        _gradientLayer.frame = self.view.bounds;
    }

    return _gradientLayer;
}

#pragma mark - ACTIONS AND NAVIGATION

- (IBAction)backToMenuButtonTouched
{
    // An audio feedback.

    [[MemoransSharedAudioController sharedAudioController] playPopSound];

    // Go back to the main menu screen.

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)levelButtonTouched:(UIButton *)sender
{
    if ([sender isKindOfClass:[MemoransLevelButton class]])
    {
        // An audio feedback.

        [[MemoransSharedAudioController sharedAudioController] playPopSound];

        // Go to the game screen.

        [self performSegueWithIdentifier:@"toGameController" sender:sender];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toGameController"])
    {
        // Prepare for going to the main screen.

        MemoransGameViewController *gameController = segue.destinationViewController;

        // Get the level button that has been touched.

        MemoransLevelButton *levelButton = (MemoransLevelButton *)sender;

        // Get the corresponding level number.

        NSInteger levelNumber = [self.levelButtonViews indexOfObject:levelButton];

        // Set the level to play in the game screen controller.

        gameController.currentLevelNumber = levelNumber;
    }
}

#pragma mark - VIEWS MANAGEMENT AND UPDATE

- (void)viewDidLoad
{
    [super viewDidLoad];

    // This controller’s view was loaded into memory!

    self.view.multipleTouchEnabled = NO;

    // Configure the "back to menu" button.

    [Utilities configureButton:self.backToMenuButton withTitleString:@"⬅︎" andFontSize:50];

    int loopCount = 0;

    NSString *levelButtonImage;

    for (MemoransLevelButton *levelButton in self.levelButtonViews)
    {
        // Get the level button image's id.

        levelButtonImage = [NSString stringWithFormat:@"Level%d", loopCount + 1];

        // Set the level button's image.

        [levelButton setImage:[UIImage imageNamed:levelButtonImage] forState:UIControlStateNormal];

        loopCount++;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    // This controller’s view is about to go on screen!

    [super viewWillAppear:animated];

    // Get a dynamic gradient and push it to the very background.

    [self.view.layer insertSublayer:self.gradientLayer atIndex:0];

    MemoransGameLevel *level;

    int loopCount = 0;
    int highestCompletedLevel = 0;

    for (MemoransLevelButton *levelButton in self.levelButtonViews)
    {
        // Get the corresponding level object in the engine.

        level =
            (MemoransGameLevel *)[MemoransSharedLevelsPack sharedLevelsPack].levelsPack[loopCount];

        if (loopCount == 0)
        {
            // The first level is already set to be unlocked and completed, so the second one is
            // unlocked (but not completed). We do this because a fresh game installation must have
            // the first 2 levels already unlocked and playable.
            // If a level is marked as "completed" the next one is unlocked and playable.

            level.completed = YES;
        }

        // Sync UI with the level object status.
        // If a level is completed, the level button is enabled.

        levelButton.enabled = level.completed;

        if (level.completed)
        {
            // The user may have completed other levels by playing, get the highest completed level.

            highestCompletedLevel = loopCount;
        }

        loopCount++;
    }

    if (highestCompletedLevel + 1 < [self.levelButtonViews count])
    {
        // We have to unlock the level next to the highest completed.

        ((MemoransLevelButton *)self.levelButtonViews[highestCompletedLevel + 1]).enabled = YES;
    }

    // Create an overlay view to notify user that on this screen he/she has to choose a level.

    MemoransOverlayView *overlayView = [[MemoransOverlayView alloc]
        initWithString:[[MemoransSharedLocalizationController sharedLocalizationController]
                           localizedStringForKey:@"Pick\na Level"]
              andColor:nil
           andFontSize:150];

    // Add the overlay view to the controller's view.

    [self.view addSubview:overlayView];

    // Animate the overlay view.

    [Utilities animateOverlayView:overlayView withDuration:1.5f];

    // Play level choice menu screen's music.

    [[MemoransSharedAudioController sharedAudioController] playMusicFromResource:@"MoveForward"
                                                                          ofType:@"mp3"
                                                                      withVolume:0.3f];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // This controller’s view has gone OFF screen!

    [super viewDidDisappear:animated];

    // Remove and release the gradient. We'll get a new random one the next time
    // this controller's view will go on screen.

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
