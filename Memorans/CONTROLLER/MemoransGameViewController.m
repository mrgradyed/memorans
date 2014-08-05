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
@property(weak, nonatomic) IBOutlet UIButton *backToMenuButton;

#pragma mark - PROPERTIES

@property(nonatomic, strong) NSMutableArray *tileViews;
@property(nonatomic, strong) NSMutableArray *tileViewsLeft;
@property(nonatomic, strong) NSMutableArray *tappedTileViews;

@property(nonatomic, strong) NSArray *endMessages;

@property(nonatomic, strong) MemoransOverlayView *bonusScoreOverlayView;
@property(nonatomic, strong) MemoransOverlayView *malusScoreOverlayView;
@property(nonatomic, strong) MemoransOverlayView *endMessageOverlayView;
@property(nonatomic, strong) MemoransOverlayView *startMessageOverlayView;

@property(nonatomic, strong) MemoransGameEngine *game;

@property(nonatomic) BOOL isWobbling;

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

- (MemoransOverlayView *)bonusScoreOverlayView
{
    if (!_bonusScoreOverlayView)
    {
        _bonusScoreOverlayView = [[MemoransOverlayView alloc] initWithFrame:CGRectZero];

        _bonusScoreOverlayView.overlayColor = [Utilities colorFromHEXString:@"#C643FC" withAlpha:1];

        _bonusScoreOverlayView.fontSize = 250;

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
        _malusScoreOverlayView = [[MemoransOverlayView alloc] initWithFrame:CGRectZero];

        _malusScoreOverlayView.overlayColor = [Utilities colorFromHEXString:@"#FF1300" withAlpha:1];

        _malusScoreOverlayView.fontSize = 250;

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
        _endMessageOverlayView = [[MemoransOverlayView alloc] initWithFrame:CGRectZero];

        _endMessageOverlayView.overlayColor = [Utilities colorFromHEXString:@"#007AFF" withAlpha:1];

        _endMessageOverlayView.fontSize = 150;

        [self.tileArea addSubview:_endMessageOverlayView];
    }

    return _endMessageOverlayView;
}

- (MemoransOverlayView *)startMessageOverlayView
{
    if (!_startMessageOverlayView)
    {
        _startMessageOverlayView = [[MemoransOverlayView alloc] initWithFrame:CGRectZero];

        _startMessageOverlayView.overlayColor =
            [Utilities colorFromHEXString:@"#007AFF" withAlpha:1];

        _startMessageOverlayView.fontSize = 150;

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
    if (currentLevelNumber >= 0 && currentLevelNumber < [[self levelsPack] count])
    {
        _currentLevelNumber = currentLevelNumber;
    }
}

#pragma mark - ACTIONS

- (IBAction)restartGameButtonPressed { [self restartGame]; }
- (IBAction)nextLevelButtonPressed
{
    self.currentLevelNumber++;
    [self restartGame];
}
- (IBAction)backToMenuPressed { [self.navigationController popViewControllerAnimated:YES]; }

- (void)restartGame
{
    [self.tileViews makeObjectsPerformSelector:@selector(removeFromSuperview)];

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

#pragma mark - GESTURES HANDLING AND GAMEPLAY

- (void)tileTapped:(UITapGestureRecognizer *)tileTapRec
{
    MemoransTileView *tappedTileView = (MemoransTileView *)tileTapRec.view;

    if (tappedTileView.paired || tappedTileView.shown || [self.tappedTileViews count] == 2)
    {
        return;
    }

    [self playTappedTileView:tappedTileView];
}

- (void)playTappedTileView:(MemoransTileView *)tappedTileView
{
    [UIView transitionWithView:tappedTileView
        duration:0.5f
        options:UIViewAnimationOptionTransitionFlipFromRight
        animations:^{
            tappedTileView.shown = YES;
            [self.tappedTileViews addObject:tappedTileView];
        }
        completion:^(BOOL completed) {

            if ([self.tappedTileViews indexOfObject:tappedTileView] == 1)
            {
                [self.game playTileAtIndex:[self.tileViews indexOfObject:self.tappedTileViews[0]]];
                [self.game playTileAtIndex:[self.tileViews indexOfObject:self.tappedTileViews[1]]];

                [self updateUIWithNewGame:NO];

                if (!tappedTileView.paired)
                {
                    [Utilities animateOverlayView:self.malusScoreOverlayView withDuration:0.8f];

                    [self addWobblingAnimationToView:self.tappedTileViews[0] withRepeatCount:5];
                    [self addWobblingAnimationToView:self.tappedTileViews[1] withRepeatCount:5];
                }
                else if (tappedTileView.paired)
                {

                    [Utilities animateOverlayView:self.bonusScoreOverlayView withDuration:0.8f];

                    [UIView transitionWithView:self.tappedTileViews[0]
                                      duration:0.5f
                                       options:UIViewAnimationOptionTransitionCurlUp
                                    animations:^{
                                        ((MemoransTileView *)self.tappedTileViews[0])
                                            .layer.borderWidth = 0;
                                    }
                                    completion:nil];

                    [UIView transitionWithView:self.tappedTileViews[1]
                        duration:0.5f
                        options:UIViewAnimationOptionTransitionCurlUp
                        animations:^{
                            ((MemoransTileView *)self.tappedTileViews[1]).layer.borderWidth = 0;
                        }
                        completion:^(BOOL finished) {

                            [self.tappedTileViews removeAllObjects];

                            [self playLastTwoTilesAutomatically];

                            [self gameDone];
                        }];
                }
            }
        }];
}

- (void)playLastTwoTilesAutomatically
{
    if ([self.tileViewsLeft count] == 2)
    {
        [self playTappedTileView:self.tileViewsLeft[0]];
        [self playTappedTileView:self.tileViewsLeft[1]];
    }
}

- (NSMutableArray *)levelsPack { return [MemoransSharedLevelsPack sharedLevelsPack].levelsPack; }

- (MemoransGameLevel *)currentLevel
{
    return (MemoransGameLevel *)[self levelsPack][self.currentLevelNumber];
}

- (MemoransGameLevel *)nextLevel
{
    if ((self.currentLevelNumber + 1) > [[self levelsPack] count] - 1)
    {
        return nil;
    }

    return (MemoransGameLevel *)[self levelsPack][self.currentLevelNumber + 1];
}

- (void)gameDone
{
    if ([self.tileViewsLeft count] == 0)
    {
        [self nextLevel].unlocked = YES;

        [self addWobblingAnimationToView:self.nextLevelButton withRepeatCount:40];

        self.endMessageOverlayView.overlayString = [NSString
            stringWithFormat:@"%@",
                             self.endMessages[self.game.gameScore % [self.endMessages count]]];

        [Utilities animateOverlayView:self.endMessageOverlayView withDuration:3];

        [self updateUIWithNewGame:NO];
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

#pragma mark - ANIMATIONS

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

#pragma mark - CAAnimation DELEGATE METHODS

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
                    [self.tappedTileViews removeAllObjects];
                }
            }];
    }
}

#pragma mark - UI MANAGEMENT AND UPDATE

- (void)createPlaceAndAnimateTileViews
{
    MemoransTileView *tileView;

    CGRect tileOnBoardFrame;

    UITapGestureRecognizer *tileTapRecog;

    NSInteger allowedTileViewBacksCount = [[MemoransTileView allowedTileViewBacks] count];

    NSString *tileBackID = [MemoransTileView allowedTileViewBacks][self.currentLevelNumber %
                                                                   allowedTileViewBacksCount];

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

            tileView.tileBackImage = tileBackID;

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

- (void)updateUIWithNewGame:(BOOL)newGame
{
    if (newGame)
    {
        [self createPlaceAndAnimateTileViews];

        self.startMessageOverlayView.overlayString =
            [NSString stringWithFormat:@"Level %d\n%@", (int)self.currentLevelNumber + 1,
                                       [self currentLevel].tileSetType];

        [Utilities animateOverlayView:self.startMessageOverlayView withDuration:3];
    }

    if ([self.tileViewsLeft count] != 0)
    {

        MemoransTile *gameTile;
        NSInteger tileIndex;

        for (MemoransTileView *tileView in self.tileViews)
        {
            tileIndex = [self.tileViews indexOfObject:tileView];
            if (tileIndex == NSNotFound)
            {
                return;
            }

            gameTile = [self.game tileInGameAtIndex:tileIndex];
            tileView.imageID = gameTile.tileID;
            tileView.paired = gameTile.paired;

            if (tileView.paired)
            {
                [self.tileViewsLeft removeObject:tileView];
            }
        }
    }

    self.nextLevelButton.hidden = ![self nextLevel].unlocked;

    self.scoreLabel.attributedText = self.scoreAttributedString;
}

- (NSMutableAttributedString *)scoreAttributedString
{
    return [[NSMutableAttributedString alloc]
        initWithString:[NSString stringWithFormat:@"✪ %d", (int)self.game.gameScore]
            attributes:[Utilities stringAttributesCentered:NO withColor:nil andSize:60]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tileArea.backgroundColor = [UIColor clearColor];

    if ([self.view isKindOfClass:[MemoransBackgroundView class]])
    {
        ((MemoransBackgroundView *)self.view).backgroundImage = @"SkewedWaves";
    };

    NSAttributedString *restartGameString = [[NSAttributedString alloc]
        initWithString:@"↺"
            attributes:[Utilities stringAttributesCentered:NO withColor:nil andSize:60]];

    [self.restartGameButton setAttributedTitle:restartGameString forState:UIControlStateNormal];

    NSAttributedString *nextLevelString = [[NSAttributedString alloc]
        initWithString:@"➤"
            attributes:[Utilities stringAttributesCentered:NO withColor:nil andSize:60]];

    [self.nextLevelButton setAttributedTitle:nextLevelString forState:UIControlStateNormal];

    NSAttributedString *backString = [[NSAttributedString alloc]
        initWithString:@"◼︎"
            attributes:[Utilities stringAttributesCentered:NO withColor:nil andSize:60]];

    [self.backToMenuButton setAttributedTitle:backString forState:UIControlStateNormal];

    [self.view bringSubviewToFront:self.tileArea];

    [self updateUIWithNewGame:YES];
}

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

- (BOOL)prefersStatusBarHidden { return YES; }

@end
