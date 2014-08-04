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
#import "Utilities.h"

@interface MemoransLevelsViewController ()

@property(strong, nonatomic) IBOutletCollection(UIButton) NSArray *levelButtonViews;

@end

@implementation MemoransLevelsViewController

#pragma mark - ACTIONS AND NAVIGATION

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

        ((MemoransBackgroundView *)self.view).backgroundImage =
            [MemoransBackgroundView allowedBackgrounds][1];
    }
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
            [NSString stringWithFormat:@"L%d%@", (int)level.tilesInLevel, level.tileSetType];

        levelButton.exclusiveTouch = YES;

        if (loopCount > 0)
        {
            levelButton.enabled = level.unlocked;

            // JUST FOR TESTING, TO BE REMOVED - START -

            levelButton.enabled = YES;

            // JUST FOR TESTING, TO BE REMOVED - END -
        }

        loopCount++;
    }
}

- (BOOL)prefersStatusBarHidden { return YES; }

@end
