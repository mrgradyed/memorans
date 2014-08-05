//
//  MemoransLevelsMenuControllerViewController.m
//  Memorans
//
//  Created by emi on 31/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransLevelsViewController.h"
#import "MemoransGameViewController.h"
#import "MemoransBackgroundView.h"
#import "MemoransLevelView.h"
#import "MemoransSharedLevelsPack.h"
#import "MemoransGameLevel.h"
#import "MemoransOverlayView.h"
#import "Utilities.h"

@interface MemoransLevelsViewController ()

#pragma mark - OUTLETS

@property(strong, nonatomic) IBOutletCollection(UIButton) NSArray *levelButtonViews;

@property(weak, nonatomic) IBOutlet UIButton *backToMenuButton;

#pragma mark - PROPERTIES

@property(strong, nonatomic) MemoransOverlayView *chooseLevelOverlay;

@end

@implementation MemoransLevelsViewController

#pragma mark - SETTERS AND GETTERS

- (MemoransOverlayView *)chooseLevelOverlay
{
    if (!_chooseLevelOverlay)
    {
        _chooseLevelOverlay = [[MemoransOverlayView alloc] initWithFrame:CGRectZero];

        _chooseLevelOverlay.overlayString = @"Pick a level!";

        _chooseLevelOverlay.overlayColor = [Utilities colorFromHEXString:@"FFCC00" withAlpha:1];

        _chooseLevelOverlay.fontSize = 150;

        [self.view addSubview:_chooseLevelOverlay];
    }

    return _chooseLevelOverlay;
}

#pragma mark - ACTIONS AND NAVIGATION

- (IBAction)backToMenuButtonTouched { [self.navigationController popViewControllerAnimated:YES]; }

- (IBAction)levelButtonTouched:(UIButton *)sender
{
    if ([sender isKindOfClass:[MemoransLevelView class]])
    {
        [self performSegueWithIdentifier:@"toGameController" sender:sender];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toGameController"] &&
        [segue.destinationViewController isKindOfClass:[MemoransGameViewController class]])
    {
        MemoransGameViewController *gameController = segue.destinationViewController;

        MemoransLevelView *levelButton = (MemoransLevelView *)sender;

        gameController.currentLevelNumber = [self.levelButtonViews indexOfObject:levelButton];
    }
}

#pragma mark - VIEWS MANAGEMENT AND UPDATE

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([self.view isKindOfClass:[MemoransBackgroundView class]])
    {
        self.view.multipleTouchEnabled = NO;

        ((MemoransBackgroundView *)self.view).backgroundImage = @"HorizontalWaves";
    }

    NSAttributedString *backToMenuString = [[NSAttributedString alloc]
        initWithString:@"⬅︎"
            attributes:[Utilities stringAttributesCentered:NO withColor:nil andSize:60]];

    [self.backToMenuButton setAttributedTitle:backToMenuString forState:UIControlStateNormal];

    self.backToMenuButton.exclusiveTouch = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    MemoransGameLevel *level;

    int loopCount = 0;

    for (MemoransLevelView *levelButton in self.levelButtonViews)
    {
        level =
            (MemoransGameLevel *)[MemoransSharedLevelsPack sharedLevelsPack].levelsPack[loopCount];

        levelButton.imageID =
            [NSString stringWithFormat:@"Level%d%@", (int)level.tilesInLevel, level.tileSetType];

        levelButton.exclusiveTouch = YES;

        if (loopCount > 1)
        {
            levelButton.enabled = level.unlocked;

            // JUST FOR TESTING, TO BE REMOVED - START -

            //  levelButton.enabled = YES;

            // JUST FOR TESTING, TO BE REMOVED - END -
        }

        loopCount++;
    }

    [Utilities animateOverlayView:self.chooseLevelOverlay withDuration:3];
}

- (BOOL)prefersStatusBarHidden { return YES; }

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

@end
