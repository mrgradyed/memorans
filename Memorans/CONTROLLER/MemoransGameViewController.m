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

@interface MemoransGameViewController ()

#pragma mark - OUTLETS

@property(weak, nonatomic) IBOutlet UIView *tileArea;
@property(weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property(weak, nonatomic) IBOutlet UIButton *restartGameButton;

#pragma mark - PROPERTIES

@property(nonatomic, strong) NSMutableArray *tileViews;
@property(nonatomic, strong) NSMutableArray *tileViewsLeft;
@property(nonatomic, strong) NSMutableArray *tappedTileViews;

@property(nonatomic, strong) MemoransOverlayView *overlayScoreView;

@property(nonatomic, strong) MemoransGameEngine *game;

@property(nonatomic, strong) NSString *gameTileSet;

@property(nonatomic) NSInteger numOfTilesOnBoard;

@property(nonatomic, strong) NSDictionary *stringAttributes;

@property(nonatomic) BOOL isWobbling;

@end

@implementation MemoransGameViewController

#pragma mark - SETTERS AND GETTERS

- (NSMutableArray *)tileViews
{
    if (!_tileViews)
    {
        _tileViews = [[NSMutableArray alloc] initWithCapacity:self.numOfTilesOnBoard];
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

- (MemoransOverlayView *)overlayScoreView
{
    if (!_overlayScoreView)
    {
        _overlayScoreView = [[MemoransOverlayView alloc] initWithFrame:CGRectZero];

        _overlayScoreView.overlayColor = [UIColor blueColor];

        _overlayScoreView.overlayString =
            [NSString stringWithFormat:@"%d", self.game.lastDeltaScore];

        [self.tileArea addSubview:_overlayScoreView];
    }

    return _overlayScoreView;
}


- (MemoransGameEngine *)game
{
    if (!_game)
    {
        _game = [[MemoransGameEngine alloc] initGameWithNum:self.numOfTilesOnBoard
                                                fromTileSet:self.gameTileSet];
    }
    return _game;
}

@synthesize gameTileSet = _gameTileSet;

- (void)setGameTileSet:(NSString *)gameTileSet
{
    if ([[MemoransTile allowedTileSets] containsObject:gameTileSet])
    {
        _gameTileSet = gameTileSet;
    }
}

- (NSString *)gameTileSet
{
    if (!_gameTileSet)
    {
        _gameTileSet = [[MemoransTile allowedTileSets] firstObject];
    }
    return _gameTileSet;
}

- (NSInteger)numOfTilesOnBoard
{
    if (!_numOfTilesOnBoard || _numOfTilesOnBoard % 2 != 0 || _numOfTilesOnBoard < 4)
    {
        _numOfTilesOnBoard = 40;
    }

    return _numOfTilesOnBoard;
}

- (NSDictionary *)stringAttributes
{
    if (!_stringAttributes)
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];

        paragraphStyle.alignment = NSTextAlignmentLeft;

        _stringAttributes = @
        {
            NSFontAttributeName : [UIFont fontWithName:@"Verdana" size:50],
            NSForegroundColorAttributeName : self.tileArea.backgroundColor,
            NSTextEffectAttributeName : NSTextEffectLetterpressStyle,
            NSParagraphStyleAttributeName : paragraphStyle,
        };
    }

    return _stringAttributes;
}

#pragma mark - ACTIONS

- (IBAction)startNewGameButtonPressed
{
    for (MemoransTileView *tileView in self.tileViews)
    {
        [tileView removeFromSuperview];
    }

    self.tileViews = nil;
    self.tileViewsLeft = nil;
    self.tappedTileViews = nil;
    self.overlayScoreView = nil;
    self.isWobbling = NO;
    self.game = nil;

    [self updateUIWithNewGame:YES];
}

#pragma mark - GESTURES HANDLING

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
        [self.overlayScoreView resetView];
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
                    self.overlayScoreView.overlayString =
                        [NSString stringWithFormat:@"%d", self.game.lastDeltaScore];

                    [self animateOverlayWithOverlayView:self.overlayScoreView];

                    [self addWobblingAnimationToView:self.tappedTileViews[0]];
                    [self addWobblingAnimationToView:self.tappedTileViews[1]];
                }
                else if (tappedTileView.paired)
                {

                    self.overlayScoreView.overlayString =
                        [NSString stringWithFormat:@"%d", self.game.lastDeltaScore];

                    [self animateOverlayWithOverlayView:self.overlayScoreView];

                    [UIView transitionWithView:self.tappedTileViews[0]
                                      duration:0.5f
                                       options:UIViewAnimationOptionTransitionCurlUp
                                    animations:^{}
                                    completion:nil];

                    [UIView transitionWithView:self.tappedTileViews[1]
                        duration:0.5f
                        options:UIViewAnimationOptionTransitionCurlUp
                        animations:^{}
                        completion:^(BOOL finished) {

                            [self.tappedTileViews removeAllObjects];

                            if ([self.tileViewsLeft count] == 2)
                            {
                                [self playTappedTileView:self.tileViewsLeft[0]];
                                [self playTappedTileView:self.tileViewsLeft[1]];
                            }
                        }];
                }
            }
        }];
}

#pragma mark - TILES SIZING AND PLACING

- (NSInteger)numOfTilesCols
{
    for (int r = 6; r >= 2; r--)
    {
        int c = ((int)self.numOfTilesOnBoard / r);

        if (self.numOfTilesOnBoard % r == 0 && r <= c)
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
        int c = ((int)self.numOfTilesOnBoard / r);

        if (self.numOfTilesOnBoard % r == 0 && r <= c)
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

- (void)animateOverlayWithOverlayView:(MemoransOverlayView *)overlayView
{
    [UIView animateWithDuration:0.2f
        animations:^{
            overlayView.center = CGPointMake(CGRectGetMidX(self.tileArea.bounds),
                                             CGRectGetMidY(self.tileArea.bounds));
        }
        completion:^(BOOL finished) {
            [UIView animateWithDuration:0.8f animations:^{ overlayView.alpha = 0; } completion:nil];
        }];
}

- (void)addWobblingAnimationToView:(UIView *)delegateView
{
    CABasicAnimation *wobbling = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];

    [wobbling setFromValue:[NSNumber numberWithFloat:0.05f]];

    [wobbling setToValue:[NSNumber numberWithFloat:-0.05f]];

    [wobbling setDuration:0.1f];

    [wobbling setAutoreverses:YES];

    [wobbling setRepeatCount:4];

    [wobbling setValue:@"wobbling" forKey:@"id"];

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

#pragma mark - USER INTERFACE MANAGEMENT AND UPDATE

- (void)updateUIWithNewGame:(BOOL)restartGame
{
    if (restartGame)
    {
        self.tileArea.layer.cornerRadius = 5;

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

    self.tileArea.backgroundColor =
        [UIColor colorWithRed:255 / 255.0f green:211 / 255.0f blue:224 / 255.0f alpha:1];

    NSAttributedString *restartGameString =
        [[NSAttributedString alloc] initWithString:@"↺" attributes:self.stringAttributes];

    [self.restartGameButton setAttributedTitle:restartGameString forState:UIControlStateNormal];

    [self updateUIWithNewGame:YES];
}

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

- (BOOL)prefersStatusBarHidden { return YES; }

@end
