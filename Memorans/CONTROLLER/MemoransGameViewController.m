//
//  MemoransGameViewController.m
//  Memorans
//
//  Created by emi on 03/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransGameViewController.h"
#import "MemoransTileView.h"
#import "MemoransTile.h"
#import "MemoransGameEngine.h"
#import "MemoransOverlayView.h"
#import "MemoransBackgroundView.h"
#import "MemoransGameLevel.h"
#import "MemoransSharedLevelsPack.h"
#import "Utilities.h"

@interface MemoransGameViewController ()

#pragma mark - OUTLETS

@property(weak, nonatomic) IBOutlet UIView *tileArea;
@property(weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property(weak, nonatomic) IBOutlet UIButton *restartGameButton;
@property(weak, nonatomic) IBOutlet UIButton *nextLevelButton;
@property(weak, nonatomic) IBOutlet UIButton *backToLevelsButton;

#pragma mark - PROPERTIES

@property(nonatomic, strong) NSMutableArray *tileViews;
@property(nonatomic, strong) NSMutableArray *tileViewsLeft;
@property(nonatomic, strong) NSMutableArray *tappedTileViews;

@property(nonatomic, strong) NSArray *endMessages;

@property(nonatomic, strong) MemoransOverlayView *bonusScoreOverlayView;
@property(nonatomic, strong) MemoransOverlayView *malusScoreOverlayView;
@property(nonatomic, strong) MemoransOverlayView *endMessageOverlayView;
@property(nonatomic, strong) MemoransOverlayView *startMessageOverlayView;

@property(nonatomic, strong) MemoransSharedLevelsPack *sharedLevelsPack;

@property(nonatomic, strong) MemoransGameEngine *game;

@property(nonatomic) BOOL isWobbling;
@property(nonatomic) BOOL isBadScore;

@end

@implementation MemoransGameViewController

#pragma mark - SETTERS AND GETTERS

- (NSMutableArray *)tileViews
{
    if (!_tileViews)
    {
        _tileViews = [[NSMutableArray alloc] initWithCapacity:[self currentLevel].tilesInLevel];
    }
    return _tileViews;
}

- (NSMutableArray *)tileViewsLeft
{
    if (!_tileViewsLeft)
    {
        _tileViewsLeft = [self.tileViews mutableCopy];
    }

    return _tileViewsLeft;
}

- (NSMutableArray *)tappedTileViews
{
    if (!_tappedTileViews)
    {
        _tappedTileViews = [[NSMutableArray alloc] initWithCapacity:2];
    }

    return _tappedTileViews;
}

- (NSArray *)endMessages
{
    if (!_endMessages)
    {
        _endMessages =
            @[ @"Well Done!", @"Great!", @"Excellent!", @"Superb!", @"Outstanding!", @"Awesome!" ];
    }
    return _endMessages;
}

- (MemoransSharedLevelsPack *)sharedLevelsPack
{
    if (!_sharedLevelsPack)
    {
        _sharedLevelsPack = [MemoransSharedLevelsPack sharedLevelsPack];
    }

    return _sharedLevelsPack;
}

- (MemoransOverlayView *)bonusScoreOverlayView
{
    if (!_bonusScoreOverlayView)
    {
        _bonusScoreOverlayView = [[MemoransOverlayView alloc]
            initWithString:nil
                  andColor:[Utilities colorFromHEXString:@"#C643FC" withAlpha:1]
               andFontSize:250];
    }

    if ([self.tileArea.subviews indexOfObject:_bonusScoreOverlayView] == NSNotFound)
    {
        [self.tileArea addSubview:_bonusScoreOverlayView];
    }

    _bonusScoreOverlayView.overlayString =
        [NSString stringWithFormat:@"+%d", (int)self.game.lastDeltaScore];

    return _bonusScoreOverlayView;
}

- (MemoransOverlayView *)malusScoreOverlayView
{
    if (!_malusScoreOverlayView)
    {
        _malusScoreOverlayView = [[MemoransOverlayView alloc]
            initWithString:nil
                  andColor:[Utilities colorFromHEXString:@"#FF1300" withAlpha:1]
               andFontSize:250];
    }

    if ([self.tileArea.subviews indexOfObject:_malusScoreOverlayView] == NSNotFound)
    {
        [self.tileArea addSubview:_malusScoreOverlayView];
    }

    _malusScoreOverlayView.overlayString =
        [NSString stringWithFormat:@"%d", (int)self.game.lastDeltaScore];

    return _malusScoreOverlayView;
}

- (MemoransOverlayView *)endMessageOverlayView
{
    if (!_endMessageOverlayView)
    {
        _endMessageOverlayView = [[MemoransOverlayView alloc]
            initWithString:nil
                  andColor:[Utilities colorFromHEXString:@"#007AFF" withAlpha:1]
               andFontSize:150];
    }

    if ([self.tileArea.subviews indexOfObject:_endMessageOverlayView] == NSNotFound)
    {
        [self.tileArea addSubview:_endMessageOverlayView];
    }

    return _endMessageOverlayView;
}

- (MemoransOverlayView *)startMessageOverlayView
{
    if (!_startMessageOverlayView)
    {
        _startMessageOverlayView = [[MemoransOverlayView alloc]
            initWithString:nil
                  andColor:[Utilities colorFromHEXString:@"#007AFF" withAlpha:1]
               andFontSize:150];
    }

    if ([self.tileArea.subviews indexOfObject:_startMessageOverlayView] == NSNotFound)
    {
        [self.tileArea addSubview:_startMessageOverlayView];
    }

    return _startMessageOverlayView;
}

- (MemoransGameEngine *)game
{
    if (!_game)
    {
        _game = [[MemoransGameEngine alloc] initGameWithTilesCount:[self currentLevel].tilesInLevel
                                                        andTileSet:[self currentLevel].tileSetType];
    }
    return _game;
}

- (void)setCurrentLevelNumber:(NSInteger)currentLevelNumber
{
    if (currentLevelNumber >= 0 && currentLevelNumber < [self.sharedLevelsPack.levelsPack count])
    {
        _currentLevelNumber = currentLevelNumber;
    }
}

#pragma mark - ACTIONS

- (IBAction)restartGameButtonTouched { [self restartGameWithNextLevel:NO]; }

- (IBAction)nextLevelButtonTouched { [self restartGameWithNextLevel:YES]; }

- (IBAction)backToMenuButtonTouched { [self.navigationController popViewControllerAnimated:YES]; }

#pragma mark - GESTURES HANDLING

- (void)tileTapped:(UITapGestureRecognizer *)tileTapRec
{
    MemoransTileView *tappedTileView = (MemoransTileView *)tileTapRec.view;

    if (tappedTileView.paired || tappedTileView.shown || [self.tappedTileViews count] == 2)
    {
        return;
    }

    [self flipAndPlayTappedTileView:tappedTileView];
}

- (void)flipAndPlayTappedTileView:(MemoransTileView *)tappedTileView
{
    [UIView transitionWithView:tappedTileView
        duration:0.3f
        options:UIViewAnimationOptionTransitionFlipFromRight
        animations:^{

            [self.tappedTileViews addObject:tappedTileView];

            tappedTileView.tapped = YES;
            tappedTileView.shown = YES;
        }
        completion:^(BOOL completed) { [self playTappedTileView:tappedTileView]; }];
}

#pragma mark - GAMEPLAY

- (void)playTappedTileView:(MemoransTileView *)tappedTileView
{
    if ([self.tappedTileViews indexOfObject:tappedTileView] != 1)
    {
        return;
    }

    [self playChosenTiles];

    if (!tappedTileView.paired)
    {
        [Utilities animateOverlayView:self.malusScoreOverlayView withDuration:0.8f];

        [self addWobblingAnimationToView:self.tappedTileViews[0] withRepeatCount:5];
        [self addWobblingAnimationToView:self.tappedTileViews[1] withRepeatCount:5];
    }
    else if (tappedTileView.paired)
    {
        [Utilities animateOverlayView:self.bonusScoreOverlayView withDuration:0.8f];

        for (MemoransTileView *tileView in self.tappedTileViews)
        {
            [UIView transitionWithView:tileView
                duration:0.5f
                options:UIViewAnimationOptionTransitionCurlUp
                animations:^{}
                completion:^(BOOL finished) {

                    if ([self.tappedTileViews indexOfObject:tileView] == 1)
                    {
                        [self finishAndSave];
                    }
                }];
        }
    }
}

- (void)playChosenTiles
{
    if ([self.tappedTileViews count] == 2)
    {
        NSInteger firstTappedViewIndex = [self.tileViews indexOfObject:self.tappedTileViews[0]];

        NSInteger secondTappedViewIndex = [self.tileViews indexOfObject:self.tappedTileViews[1]];

        if (firstTappedViewIndex == NSNotFound || secondTappedViewIndex == NSNotFound)
        {
            return;
        }

        [self.game playGameTileAtIndex:firstTappedViewIndex];

        [self.game playGameTileAtIndex:secondTappedViewIndex];

        [self updateUIWithNewGame:NO];
    }
}

- (void)finishAndSave
{
    if ([self.tappedTileViews count] == 2)
    {
        MemoransTileView *firstTappedTileView = ((MemoransTileView *)self.tappedTileViews[0]);
        MemoransTileView *secondTappedTileView = ((MemoransTileView *)self.tappedTileViews[1]);

        [self.tappedTileViews removeAllObjects];

        firstTappedTileView.tapped = NO;
        secondTappedTileView.tapped = NO;

        if (firstTappedTileView.paired && secondTappedTileView.paired)
        {
            [self.tileViewsLeft removeObject:firstTappedTileView];
            [self.tileViewsLeft removeObject:secondTappedTileView];
        }

        if ([self.tileViewsLeft count] != 0)
        {
            if ([self archiveGameControllerStatus])
            {
                [self currentLevel].hasSave = YES;
            }
        }
        else
        {
            [self levelFinished];
        }
    }
}

- (void)levelFinished
{
    if ([self.tileViewsLeft count] == 0)
    {
        if ([self currentLevel].hasSave)
        {
            [self deleteSavedGameControllerStatus];

            [self currentLevel].hasSave = NO;
        }

        if (!self.isBadScore)
        {
            [self nextLevel].unlocked = YES;

            [self addWobblingAnimationToView:self.nextLevelButton withRepeatCount:40];

            self.endMessageOverlayView.overlayString = [NSString
                stringWithFormat:@"%@",
                                 self.endMessages[self.game.gameScore % [self.endMessages count]]];

            [Utilities animateOverlayView:self.endMessageOverlayView withDuration:2];

            [self updateUIWithNewGame:NO];
        }
        else
        {
            [self restartGameWithNextLevel:NO];
        }
    }
}

- (void)restartGameWithNextLevel:(BOOL)next
{
    if (next)
    {
        self.currentLevelNumber++;
    }
    else
    {
        self.isBadScore = (self.game.gameScore < 0);

        if ([self currentLevel].hasSave)
        {
            [self deleteSavedGameControllerStatus];

            [self currentLevel].hasSave = NO;
        }
    }

    [self.tileArea.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    self.tileViews = nil;
    self.tileViewsLeft = nil;
    self.tappedTileViews = nil;

    self.isWobbling = NO;

    self.game = nil;

    [self.startMessageOverlayView resetView];
    [self.endMessageOverlayView resetView];
    [self.bonusScoreOverlayView resetView];
    [self.malusScoreOverlayView resetView];

    [self updateUIWithNewGame:YES];
}

- (void)resumeGame
{
    self.game = [NSKeyedUnarchiver
        unarchiveObjectWithFile:[self filePathForArchivingWithName:@"gameStatus.archive"]];

    self.tileViews = [NSKeyedUnarchiver
        unarchiveObjectWithFile:[self filePathForArchivingWithName:@"tileViewsStatus.archive"]];

    UITapGestureRecognizer *tileTapRecog;

    for (MemoransTileView *tileView in self.tileViews)
    {
        tileTapRecog =
            [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tileTapped:)];

        tileTapRecog.numberOfTapsRequired = 1;
        tileTapRecog.numberOfTouchesRequired = 1;

        [tileView addGestureRecognizer:tileTapRecog];

        [self.tileArea addSubview:tileView];

        if (tileView.tapped)
        {
            [self.tappedTileViews addObject:tileView];
        }

        if (tileView.paired)
        {
            [self.tileViewsLeft removeObject:tileView];
        }
    }
}

- (MemoransGameLevel *)currentLevel
{
    if (self.currentLevelNumber > [self.sharedLevelsPack.levelsPack count] - 1)
    {
        return nil;
    }

    return (MemoransGameLevel *)self.sharedLevelsPack.levelsPack[self.currentLevelNumber];
}

- (MemoransGameLevel *)nextLevel
{
    if (self.currentLevelNumber + 1 > [self.sharedLevelsPack.levelsPack count] - 1)
    {
        return nil;
    }

    return (MemoransGameLevel *)self.sharedLevelsPack.levelsPack[self.currentLevelNumber + 1];
}

#pragma mark - CAAnimation AND CAAnimation DELEGATE METHODS

- (void)addWobblingAnimationToView:(UIView *)view withRepeatCount:(float)repeatCount
{
    CABasicAnimation *wobbling = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];

    [wobbling setFromValue:[NSNumber numberWithFloat:0.08f]];

    [wobbling setToValue:[NSNumber numberWithFloat:-0.08f]];

    [wobbling setDuration:0.11f];

    [wobbling setAutoreverses:YES];

    [wobbling setRepeatCount:repeatCount];

    wobbling.delegate = self;

    [view.layer addAnimation:wobbling forKey:@"wobbling"];
}

- (void)animationDidStart:(CAAnimation *)anim { self.isWobbling = YES; }

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (!self.isWobbling)
    {
        return;
    }

    self.isWobbling = NO;

    for (MemoransTileView *tileView in self.tappedTileViews)
    {
        [UIView transitionWithView:tileView
            duration:0.3f
            options:UIViewAnimationOptionTransitionFlipFromLeft
            animations:^{ tileView.shown = NO; }
            completion:^(BOOL finished) {

                if ([self.tappedTileViews indexOfObject:tileView] == 1)
                {
                    [self finishAndSave];
                }
            }];
    }
}

#pragma mark - TILES SIZING AND PLACING

- (NSInteger)numOfTilesCols
{
    for (int r = 6; r >= 2; r--)
    {
        int c = ((int)[self currentLevel].tilesInLevel / r);

        if ([self currentLevel].tilesInLevel % r == 0 && r <= c)
        {
            return c;
        }
    }

    return 0;
}

- (NSInteger)numOfTilesRows
{
    for (int r = 6; r >= 2; r--)
    {
        int c = ((int)[self currentLevel].tilesInLevel / r);

        if ([self currentLevel].tilesInLevel % r == 0 && r <= c)
        {
            return r;
        }
    }

    return 0;
}

static const NSInteger gTileMargin = 5;

- (CGFloat)tileWidth
{
    NSInteger colWidth = self.tileArea.bounds.size.width / [self numOfTilesCols];

    return colWidth - gTileMargin * 2;
}

- (CGFloat)tileHeight
{
    NSInteger colHeight = self.tileArea.bounds.size.height / [self numOfTilesRows];

    return colHeight - gTileMargin * 2;
}

- (CGRect)frameForTileAtRow:(NSInteger)i Col:(NSInteger)j
{
    CGFloat colWidth = self.tileArea.bounds.size.width / self.numOfTilesCols;
    CGFloat colHeight = self.tileArea.bounds.size.height / self.numOfTilesRows;

    CGFloat frameOriginX = j * colWidth + gTileMargin;
    CGFloat frameOriginY = i * colHeight + gTileMargin;

    return CGRectMake(frameOriginX, frameOriginY, self.tileWidth, self.tileHeight);
}

#pragma mark - VIEWS MANAGEMENT AND UPDATE

- (void)updateUIWithNewGame:(BOOL)newGame
{
    if (newGame)
    {
        if ([self currentLevel].hasSave)
        {
            [self resumeGame];

            self.startMessageOverlayView.overlayString = @"Game\nResumed";
        }
        else
        {
            [self createAndAnimateTileViews];

            if (!self.isBadScore)
            {
                self.startMessageOverlayView.overlayString =
                    [NSString stringWithFormat:@"Level %d\n%@", (int)self.currentLevelNumber + 1,
                                               [self currentLevel].tileSetType];
            }
            else
            {
                self.startMessageOverlayView.overlayString = @"Bad Score!\nTry Again!";
            }
        }

        [Utilities animateOverlayView:self.startMessageOverlayView withDuration:2];

        self.view.userInteractionEnabled = YES;
    }

    if ([self.tileViews count] < 6)
    {
        [self restartGameWithNextLevel:NO];

        return;
    }

    if ([self.tileViewsLeft count] != 0)
    {
        MemoransTile *gameTile;
        NSInteger tileIndex;

        for (MemoransTileView *tileView in self.tileViews)
        {
            tileIndex = [self.tileViews indexOfObject:tileView];

            if (tileIndex != NSNotFound)
            {
                gameTile = [self.game gameTileAtIndex:tileIndex];

                tileView.imageID = gameTile.tileID;
                tileView.paired = gameTile.paired;
            }
        }
    }

    self.nextLevelButton.hidden = ![self nextLevel].unlocked;

    self.scoreLabel.attributedText = self.scoreAttributedString;
}

- (void)createAndAnimateTileViews
{
    MemoransTileView *tileView;

    CGRect tileOnBoardFrame;

    UITapGestureRecognizer *tileTapRecog;

    NSString *tileBackImage =
        [MemoransTileView allowedTileViewBacks][self.currentLevelNumber %
                                                [[MemoransTileView allowedTileViewBacks] count]];

    for (int i = 0; i < self.numOfTilesRows; i++)
    {
        for (int j = 0; j < self.numOfTilesCols; j++)
        {
            tileOnBoardFrame = [self frameForTileAtRow:i Col:j];

            tileView = [[MemoransTileView alloc] initWithFrame:tileOnBoardFrame];

            tileView.onBoardCenter = tileView.center;

            tileView.center = CGPointMake(
                tileOnBoardFrame.origin.x + tileOnBoardFrame.size.width / 2,
                (self.view.frame.origin.y - arc4random() % (int)self.view.frame.size.height) -
                    tileView.bounds.size.height);

            tileView.tileBackImage = tileBackImage;

            tileTapRecog =
                [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tileTapped:)];

            tileTapRecog.numberOfTapsRequired = 1;
            tileTapRecog.numberOfTouchesRequired = 1;

            [tileView addGestureRecognizer:tileTapRecog];

            [self.tileViews addObject:tileView];

            [self.tileArea addSubview:tileView];

            [UIView animateWithDuration:2.0f
                                  delay:0
                 usingSpringWithDamping:0.6f
                  initialSpringVelocity:0.4f
                                options:0
                             animations:^{ tileView.center = tileView.onBoardCenter; }
                             completion:nil];
        }
    }
}

- (NSMutableAttributedString *)scoreAttributedString
{
    return [[NSMutableAttributedString alloc]
        initWithString:[NSString stringWithFormat:@"✪ %d", (int)self.game.gameScore]
            attributes:[Utilities stringAttributesWithAlignement:NSTextAlignmentCenter
                                                       withColor:nil
                                                         andSize:60]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tileArea.backgroundColor = [UIColor clearColor];

    ((MemoransBackgroundView *)self.view).backgroundImage = @"SkewedWaves";

    NSAttributedString *restartGameString = [[NSAttributedString alloc]
        initWithString:@"↺"
            attributes:[Utilities stringAttributesWithAlignement:NSTextAlignmentLeft
                                                       withColor:nil
                                                         andSize:60]];

    [self.restartGameButton setAttributedTitle:restartGameString forState:UIControlStateNormal];

    self.restartGameButton.exclusiveTouch = YES;

    NSAttributedString *nextLevelString = [[NSAttributedString alloc]
        initWithString:@"➤"
            attributes:[Utilities stringAttributesWithAlignement:NSTextAlignmentRight
                                                       withColor:nil
                                                         andSize:60]];

    [self.nextLevelButton setAttributedTitle:nextLevelString forState:UIControlStateNormal];

    self.nextLevelButton.exclusiveTouch = YES;

    NSAttributedString *backToLevelsString = [[NSAttributedString alloc]
        initWithString:@"⬅︎"
            attributes:[Utilities stringAttributesWithAlignement:NSTextAlignmentLeft
                                                       withColor:nil
                                                         andSize:60]];

    [self.backToLevelsButton setAttributedTitle:backToLevelsString forState:UIControlStateNormal];

    self.backToLevelsButton.exclusiveTouch = YES;

    [self.view bringSubviewToFront:self.tileArea];

    [self updateUIWithNewGame:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"viewWillDisappear");

    [super viewWillDisappear:animated];

    [self.sharedLevelsPack archiveLevelsStatus];
}

- (BOOL)prefersStatusBarHidden { return YES; }

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

#pragma mark - ARCHIVING

- (NSString *)filePathForArchivingWithName:(NSString *)filename
{
    NSString *documentDirectory =
        NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];

    return [documentDirectory stringByAppendingPathComponent:filename];
}

- (BOOL)archiveGameControllerStatus
{
    BOOL gameArchiving = [NSKeyedArchiver
        archiveRootObject:self.game
                   toFile:[self filePathForArchivingWithName:@"gameStatus.archive"]];

    BOOL tileViewsArchiving = [NSKeyedArchiver
        archiveRootObject:self.tileViews
                   toFile:[self filePathForArchivingWithName:@"tileViewsStatus.archive"]];

    return (gameArchiving && tileViewsArchiving);
}

- (BOOL)deleteSavedGameControllerStatus
{

    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSError *gameError;

    BOOL gameArchiveRemoval =
        [fileManager removeItemAtPath:[self filePathForArchivingWithName:@"gameStatus.archive"]
                                error:&gameError];

    NSError *tileError;

    BOOL tileViewsArchiveRemoval =
        [fileManager removeItemAtPath:[self filePathForArchivingWithName:@"tileViewsStatus.archive"]
                                error:&tileError];

    return (gameArchiveRemoval && tileViewsArchiveRemoval);
}


@end
