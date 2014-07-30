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
#import "MemoransColorConverter.h"

@interface MemoransGameViewController ()

#pragma mark - OUTLETS

@property(weak, nonatomic) IBOutlet UIView *tileArea;
@property(weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property(weak, nonatomic) IBOutlet UIButton *restartGameButton;
@property(weak, nonatomic) IBOutlet UIButton *nextLevelButton;

#pragma mark - PROPERTIES

@property(nonatomic, strong) NSMutableArray *tileViews;
@property(nonatomic, strong) NSMutableArray *tileViewsLeft;
@property(nonatomic, strong) NSMutableArray *tappedTileViews;

@property(nonatomic, strong) NSArray *levels;

@property(nonatomic, strong) MemoransOverlayView *bonusScoreOverlayView;
@property(nonatomic, strong) MemoransOverlayView *malusScoreOverlayView;
@property(nonatomic, strong) MemoransOverlayView *messageOverlayView;

@property(nonatomic, strong) MemoransGameEngine *game;

@property(nonatomic, strong) NSString *gameTileSetType;

@property(nonatomic) NSInteger tilesOnBoardCount;
@property(nonatomic) NSInteger currentLevel;

@property(nonatomic, strong) NSDictionary *stringAttributes;

@property(nonatomic) BOOL isWobbling;
@property(nonatomic) BOOL levelCompleted;

@end

@implementation MemoransGameViewController

#pragma mark - SETTERS AND GETTERS

- (NSMutableArray *)tileViews
{
    if (!_tileViews)
    {
        _tileViews = [[NSMutableArray alloc] initWithCapacity:self.tilesOnBoardCount];
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

- (NSArray *)levels
{

    if (!_levels)
    {
        _levels = @[
            @6,
            @6,
            @8,
            @8,
            @12,
            @12,
            @16,
            @16,
            @18,
            @18,
            @20,
            @20,
            @24,
            @24,
            @28,
            @28,
            @30,
            @30,
            @32,
            @32,
            @36,
            @36,
            @40,
            @40
        ];
    }

    return _levels;
}

- (MemoransOverlayView *)bonusScoreOverlayView
{
    if (!_bonusScoreOverlayView)
    {
        _bonusScoreOverlayView = [[MemoransOverlayView alloc] initWithFrame:CGRectZero];

        _bonusScoreOverlayView.overlayColor =
            [MemoransColorConverter colorFromHEXString:@"#C643FC"];

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

        _malusScoreOverlayView.overlayColor =
            [MemoransColorConverter colorFromHEXString:@"#FF1300"];

        _malusScoreOverlayView.fontSize = 250;

        [self.tileArea addSubview:_malusScoreOverlayView];
    }

    _malusScoreOverlayView.overlayString =
        [NSString stringWithFormat:@"%d", (int)self.game.lastDeltaScore];

    return _malusScoreOverlayView;
}

- (MemoransOverlayView *)messageOverlayView
{
    if (!_messageOverlayView)
    {
        _messageOverlayView = [[MemoransOverlayView alloc] initWithFrame:CGRectZero];

        _messageOverlayView.overlayColor = [MemoransColorConverter colorFromHEXString:@"#007AFF"];

        _messageOverlayView.fontSize = 150;

        [self.tileArea addSubview:_messageOverlayView];
    }

    return _messageOverlayView;
}

- (MemoransGameEngine *)game
{
    if (!_game)
    {
        _game = [[MemoransGameEngine alloc] initGameWithTilesCount:self.tilesOnBoardCount
                                                        andTileSet:self.gameTileSetType];
    }
    return _game;
}

@synthesize gameTileSetType = _gameTileSetType;

- (void)setGameTileSetType:(NSString *)gameTileSet
{
    if ([[MemoransTile allowedTileSets] containsObject:gameTileSet])
    {
        _gameTileSetType = gameTileSet;
    }
}

- (NSString *)gameTileSetType
{
    if (!_gameTileSetType)
    {
        _gameTileSetType = [[MemoransTile allowedTileSets] firstObject];
    }
    return _gameTileSetType;
}

- (NSInteger)tilesOnBoardCount
{
    if (!_tilesOnBoardCount)
    {
        _tilesOnBoardCount = [self.levels[self.currentLevel - 1] integerValue];
    }
    return _tilesOnBoardCount;
}

@synthesize currentLevel = _currentLevel;

- (void)setCurrentLevel:(NSInteger)currentLevel
{
    if (currentLevel != _currentLevel && currentLevel > 0 && currentLevel <= [self.levels count])
    {
        _currentLevel = currentLevel;

        self.levelCompleted = NO;
        self.tilesOnBoardCount = 0;

        NSInteger gameTileSetTypeIndex = _currentLevel % [[MemoransTile allowedTileSets] count];
        self.gameTileSetType = [MemoransTile allowedTileSets][gameTileSetTypeIndex];
    }
}

- (NSInteger)currentLevel
{
    if (!_currentLevel)
    {
        _currentLevel = 1;

        NSInteger gameTileSetTypeIndex = _currentLevel % [[MemoransTile allowedTileSets] count];
        self.gameTileSetType = [MemoransTile allowedTileSets][gameTileSetTypeIndex];
    }

    return _currentLevel;
}

- (NSDictionary *)stringAttributes
{
    if (!_stringAttributes)
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];

        paragraphStyle.alignment = NSTextAlignmentLeft;

        _stringAttributes = @
        {
            NSFontAttributeName : [UIFont fontWithName:@"Verdana" size:60],
            NSForegroundColorAttributeName : [MemoransColorConverter colorFromHEXString:@"#C643FC"],
            NSTextEffectAttributeName : NSTextEffectLetterpressStyle,
            NSParagraphStyleAttributeName : paragraphStyle,
        };
    }

    return _stringAttributes;
}

#pragma mark - ACTIONS

- (IBAction)startNewGameButtonPressed { [self restartGame]; }
- (IBAction)nextLevelButtonPressed
{
    self.currentLevel++;
    [self restartGame];
}

- (void)restartGame
{
    for (MemoransTileView *tileView in self.tileViews)
    {
        [tileView removeFromSuperview];
    }

    self.tileViews = nil;
    self.tileViewsLeft = nil;
    self.tappedTileViews = nil;
    self.isWobbling = NO;
    self.game = nil;

    [self updateUIWithNewGame:YES];

    [self.tileArea bringSubviewToFront:self.bonusScoreOverlayView];
    [self.tileArea bringSubviewToFront:self.malusScoreOverlayView];
    [self.tileArea bringSubviewToFront:self.messageOverlayView];

    [self.bonusScoreOverlayView resetView];
    [self.malusScoreOverlayView resetView];
    [self.messageOverlayView resetView];
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
    if ([self.tappedTileViews count] != 2)
    {
        [self.bonusScoreOverlayView resetView];
        [self.malusScoreOverlayView resetView];
    }

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
                    [self animateOverlayView:self.malusScoreOverlayView withDuration:0.8f];

                    [self addWobblingAnimationToView:self.tappedTileViews[0] withRepeatCount:5];
                    [self addWobblingAnimationToView:self.tappedTileViews[1] withRepeatCount:5];
                }
                else if (tappedTileView.paired)
                {

                    [self animateOverlayView:self.bonusScoreOverlayView withDuration:0.8f];

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

- (void)gameDone
{
    if ([self.tileViewsLeft count] == 0)
    {
        if (self.game.gameScore > 0)
        {
            self.levelCompleted = YES;

            [self addWobblingAnimationToView:self.nextLevelButton withRepeatCount:50];

            self.messageOverlayView.overlayString = @"Well Done!";

            [self animateOverlayView:self.messageOverlayView withDuration:2.5f];

            [self updateUIWithNewGame:NO];
        }
        else
        {
            [self restartGame];

            self.messageOverlayView.overlayString = @"Try Again!";

            [self animateOverlayView:self.messageOverlayView withDuration:2.5f];
        }
    }
}

#pragma mark - TILES SIZING AND PLACING

- (NSInteger)numOfTilesCols
{
    for (int r = 6; r >= 2; r--)
    {
        int c = ((int)self.tilesOnBoardCount / r);

        if (self.tilesOnBoardCount % r == 0 && r <= c)
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
        int c = ((int)self.tilesOnBoardCount / r);

        if (self.tilesOnBoardCount % r == 0 && r <= c)
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

- (void)animateOverlayView:(MemoransOverlayView *)overlayView withDuration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:0.2f
        animations:^{
            overlayView.center = CGPointMake(CGRectGetMidX(self.tileArea.bounds),
                                             CGRectGetMidY(self.tileArea.bounds));
        }
        completion:^(BOOL finished) {
            [UIView animateWithDuration:duration
                             animations:^{ overlayView.alpha = 0; }
                             completion:nil];
        }];
}

- (void)addWobblingAnimationToView:(UIView *)delegateView withRepeatCount:(float)repeatCount
{
    CABasicAnimation *wobbling = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];

    [wobbling setFromValue:[NSNumber numberWithFloat:0.08f]];

    [wobbling setToValue:[NSNumber numberWithFloat:-0.08f]];

    [wobbling setDuration:0.1f];

    [wobbling setAutoreverses:YES];

    [wobbling setRepeatCount:repeatCount];

    wobbling.delegate = self;

    [delegateView.layer addAnimation:wobbling forKey:@"wobbling"];
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

- (void)updateUIWithNewGame:(BOOL)restartGame
{
    if (restartGame)
    {
        MemoransTileView *tileView;

        CGRect tileOnBoardFrame;

        UITapGestureRecognizer *tileTapRecog;

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

                tileTapRecog =
                    [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(tileTapped:)];

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

    self.nextLevelButton.hidden = !self.levelCompleted;

    self.scoreLabel.attributedText = self.scoreAttributedString;
}

- (NSMutableAttributedString *)scoreAttributedString
{
    return [[NSMutableAttributedString alloc]
        initWithString:[NSString stringWithFormat:@"✪ %d", (int)self.game.gameScore]
            attributes:self.stringAttributes];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tileArea.backgroundColor = [UIColor clearColor];

    NSAttributedString *restartGameString =
        [[NSAttributedString alloc] initWithString:@"↺" attributes:self.stringAttributes];

    [self.restartGameButton setAttributedTitle:restartGameString forState:UIControlStateNormal];

    NSAttributedString *nextLevelString =
        [[NSAttributedString alloc] initWithString:@"➔" attributes:self.stringAttributes];

    [self.nextLevelButton setAttributedTitle:nextLevelString forState:UIControlStateNormal];

    [self updateUIWithNewGame:YES];
}

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

- (BOOL)prefersStatusBarHidden { return YES; }

@end
