//
//  MemoransGameViewController.m
//  Memorans
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.
//
//  Created by emi on 03/07/14.
//
//

#import "MemoransGameViewController.h"
#import "MemoransTileView.h"
#import "MemoransTile.h"
#import "MemoransGameEngine.h"
#import "MemoransOverlayView.h"
#import "MemoransGameLevel.h"
#import "MemoransSharedLevelsPack.h"
#import "MemoransSharedAudioController.h"
#import "MemoransSharedLocalizationController.h"
#import "Utilities.h"

@interface MemoransGameViewController ()

#pragma mark - OUTLETS

// The UIView delimiting the tiles.

@property(weak, nonatomic) IBOutlet UIView *tileArea;

// The label showing the current score.

@property(weak, nonatomic) IBOutlet UILabel *scoreLabel;

// The button for restarting the game in the current level.

@property(weak, nonatomic) IBOutlet UIButton *restartGameButton;

// The button for going to the next level (available if the current level is
// completed).

@property(weak, nonatomic) IBOutlet UIButton *nextLevelButton;

// The button that takes the user back to the level choice menu.

@property(weak, nonatomic) IBOutlet UIButton *backToLevelsButton;

#pragma mark - PROPERTIES

// The tile views currently used in the level.

@property(nonatomic, strong) NSMutableArray *tileViews;

// The NOT PAIRED tile views currently left in the level game.

@property(nonatomic, strong) NSMutableArray *tileViewsLeft;

// The 2 tile views currently chosen.

@property(nonatomic, strong) NSMutableArray *chosenTileViews;

// A pointer to the shared audio controller for easier access.

@property(strong, nonatomic) MemoransSharedAudioController *sharedAudioController;

// A pointer to the shared localization controller for easier access.

@property(strong, nonatomic) MemoransSharedLocalizationController *sharedLocalizationController;

// A gradient layer for the background.

@property(strong, nonatomic) CAGradientLayer *gradientLayer;

// A pointer to an instance of the game engine.

@property(nonatomic, strong) MemoransGameEngine *game;

// An integer to count the number of currently "wobbling" animated tiles.

@property(nonatomic) NSInteger wobblingTilesCount;

// A bool to decide whether to enable the next level or not.

@property(nonatomic) BOOL isBadScore;

// A bool to check if the current game has ended.

@property(nonatomic) BOOL isGameOver;

@end

@implementation MemoransGameViewController

#pragma mark - SETTERS AND GETTERS

- (NSMutableArray *)tileViews
{
    if (!_tileViews)
    {

        // Create an array sized according to the number of tiles in the current
        // level.

        _tileViews = [[NSMutableArray alloc] initWithCapacity:[self currentLevel].tilesInLevel];
    }
    return _tileViews;
}

- (NSMutableArray *)tileViewsLeft
{
    if (!_tileViewsLeft)
    {
        // When the game begins, the number of tile views left is the total number
        // of tiles.

        _tileViewsLeft = [self.tileViews mutableCopy];
    }

    return _tileViewsLeft;
}

- (NSMutableArray *)chosenTileViews
{
    if (!_chosenTileViews)
    {
        // The array for the chosen tiles will contain 2 elements at max.

        _chosenTileViews = [[NSMutableArray alloc] initWithCapacity:2];
    }

    return _chosenTileViews;
}

- (MemoransSharedAudioController *)sharedAudioController
{
    if (!_sharedAudioController)
    {
        // Get the audio controller singleton.

        _sharedAudioController = [MemoransSharedAudioController sharedAudioController];
    }

    return _sharedAudioController;
}

- (MemoransSharedLocalizationController *)sharedLocalizationController
{
    if (!_sharedLocalizationController)
    {
        // Get the localization controller singleton.

        _sharedLocalizationController =
            [MemoransSharedLocalizationController sharedLocalizationController];
    }
    return _sharedLocalizationController;
}

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

- (MemoransGameEngine *)game
{
    if (!_game)
    {
        // An instance of the game engine, initialised with the number of tiles and
        // tile type prescribed by the current level.

        _game = [[MemoransGameEngine alloc] initGameWithTilesCount:[self currentLevel].tilesInLevel
                                                        andTileSet:[self currentLevel].levelType];
    }
    return _game;
}

- (void)setCurrentLevelNumber:(NSInteger)currentLevelNumber
{
    if (currentLevelNumber >= 0 && currentLevelNumber < [[self levelsPack] count])
    {
        // If the number is a valid level, set it as the current one.

        _currentLevelNumber = currentLevelNumber;
    }
}

#pragma mark - ACTIONS

- (IBAction)restartGameButtonTouched
{
    // Play an audio feedback.

    [self.sharedAudioController playPopSound];

    // Restart this same level game.

    [self restartGameWithNextLevel:NO];
}

- (IBAction)nextLevelButtonTouched
{
    // Play an audio feedback.

    [self.sharedAudioController playPopSound];

    // The index of the last level in the levels array.

    NSInteger lastLevelIndex = [[MemoransSharedLevelsPack sharedLevelsPack].levelsPack count] - 1;

    // Is this the last level?

    if (self.currentLevelNumber == lastLevelIndex)
    {
        // This IS the last level: show the end screen.

        [self performSegueWithIdentifier:@"toEndController" sender:self];
    }
    else
    {
        // This is NOT the last level: start a new game in the next level.

        [self restartGameWithNextLevel:YES];
    }
}

- (IBAction)backToMenuButtonTouched
{
    // Play an audio feedback.

    [self.sharedAudioController playPopSound];

    // Go back to the previous level choice menu screen.

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - GESTURES HANDLING

- (void)tileTapped:(UITapGestureRecognizer *)tileTapRec
{
    // A tile view has been tapped!

    // Get the tapped tile view.

    MemoransTileView *tappedTileView = (MemoransTileView *)tileTapRec.view;

    if (tappedTileView.paired || tappedTileView.shown || [self.chosenTileViews count] == 2)
    {
        // The tapped tile is already face up, or it is already paired, or 2 tiles
        // have already been
        // chosen for playing, so ignore the tap.

        return;
    }

    // Else, flip the tile face up and play it.

    [self flipAndPlayTappedTileView:tappedTileView];
}

- (void)flipAndPlayTappedTileView:(MemoransTileView *)tappedTileView
{
    // Play an audio feedback.

    [self.sharedAudioController playUeeeSound];

    // Animate the tile flip transition.

    [UIView transitionWithView:tappedTileView
        duration:0.3f
        options:UIViewAnimationOptionTransitionFlipFromRight
        animations:^{

            // Add the tapped tile to the chosen tiles array.

            [self.chosenTileViews addObject:tappedTileView];

            // Set the tapped tile as chosen and as shown (face up).

            tappedTileView.chosen = YES;
            tappedTileView.shown = YES;
        }
        completion:^(BOOL finished) {

            // Play the game.

            [self playTappedTileView:tappedTileView];
        }];
}

#pragma mark - GAMEPLAY

- (void)playTappedTileView:(MemoransTileView *)tappedTileView
{
    if ([self.chosenTileViews indexOfObject:tappedTileView] != 1)
    {
        // We can play the memory game only if 2 tiles are chosen,
        // so we execute this method only when the second tile has been tapped.

        // If the tapped tile is NOT the second one, exit.

        return;
    }

    // We have 2 tiles, play them.

    [self playChosenTiles];

    // After playing the chosen tiles.

    if (!tappedTileView.paired)
    {
        // The chosen tiles are NOT PAIRED!
        // Tiles were different. User lost.

        // Display the malus overlay text with the lost points.

        [Utilities animateOverlayView:[self addMalusScoreOverlayView] withDuration:0.3f];

        // Make the unmatched tiles wobbling to notify the user of the bad choice.

        // Wobbling animation for the first chosen tile.

        [Utilities addWobblingAnimationToView:self.chosenTileViews[0]
                              withRepeatCount:4
                                  andDelegate:self];

        // Wobbling animation for the second chosen tile.

        [Utilities addWobblingAnimationToView:self.chosenTileViews[1]
                              withRepeatCount:4
                                  andDelegate:self];

        // Play a negative audio feedback.

        [self.sharedAudioController playIiiiSound];
    }
    else if (tappedTileView.paired)
    {
        // The chosen tiles are PAIRED!
        // Tiles were the same. User won.

        if (!self.game.isLucky && !self.game.isCombo)
        {
            // Display the bonus overlay text with the number of points gained.

            [Utilities animateOverlayView:[self addBonusScoreOverlayView] withDuration:0.3f];
        }

        if (self.game.isLucky && !self.game.isCombo)
        {
            // The user got the pair of tiles matched at the first try, display an
            // overlay text to
            // notify the user that he/she was very lucky ;)

            // Add an overlay view.

            MemoransOverlayView *luckyMessage = [self addMessageOverlayView];

            // Configure the overlay view.

            luckyMessage.overlayString =
                [self.sharedLocalizationController localizedStringForKey:@"What Luck!"];

            luckyMessage.fontSize = 140;

            // Animate the overlay message.

            [Utilities animateOverlayView:luckyMessage withDuration:0.5f];
        }

        if (self.game.isCombo)
        {
            // The user got a series of matches in a row without errors.
            // Display a message to notify the user that he/she is good at this game.

            // Add an overlay view.

            MemoransOverlayView *comboMessage = [self addMessageOverlayView];

            if (self.game.isCombo < 2)
            {
                // This is the first combo, create an overlay to notify that.

                comboMessage.overlayString =
                    [self.sharedLocalizationController localizedStringForKey:@"Combo!"];
            }
            else
            {
                // We have a series of combos, create an overlay text showing the combo
                // counter.

                comboMessage.overlayString =
                    [NSString stringWithFormat:@"%dX %@", (int)self.game.isCombo,
                                               [self.sharedLocalizationController
                                                   localizedStringForKey:@"Combo!"]];
            }

            comboMessage.fontSize = 140;

            // Animate the combo message.

            [Utilities animateOverlayView:comboMessage withDuration:0.5f];
        }

        // Play a positive audio feedback.

        [self.sharedAudioController playUiiiSound];

        // The tiles are paired, so animate the chosen tiles to notify this.

        for (MemoransTileView *tileView in self.chosenTileViews)
        {
            [UIView transitionWithView:tileView
                duration:0.5f
                options:UIViewAnimationOptionTransitionCurlUp
                animations:^{}
                completion:^(BOOL finished) {

                    if ([self.chosenTileViews indexOfObject:tileView] == 1)
                    {
                        // Here we have finished animating the second chosen paired
                        // tile.
                        // Clean up and save the game status.

                        [self finishAndSave];
                    }
                }];
        }
    }
}

- (void)playChosenTiles
{
    if ([self.chosenTileViews count] == 2)
    {
        // Execute this method only if there are 2 tiles currently chosen, that
        // means we are at the
        // end of a valid action.

        // Get the indexes of the 2 chosen tiles in the tile views array.

        NSInteger firstTappedViewIndex = [self.tileViews indexOfObject:self.chosenTileViews[0]];
        NSInteger secondTappedViewIndex = [self.tileViews indexOfObject:self.chosenTileViews[1]];

        if (firstTappedViewIndex == NSNotFound || secondTappedViewIndex == NSNotFound)
        {
            // No tile views are found at those indexes, exit.

            return;
        }

        // Actually play the 2 chosen tiles in the game engine.

        [self.game playGameTileAtIndex:firstTappedViewIndex];
        [self.game playGameTileAtIndex:secondTappedViewIndex];

        // Update the UI to match the new tiles status.

        [self updateUIWithNewGame:NO];
    }
}

- (void)finishAndSave
{
    if ([self.chosenTileViews count] == 2)
    {
        // Execute this method only if there are 2 tiles currently chosen, that
        // means we are at the
        // end of a valid action.

        // Get the 2 chosen views.

        MemoransTileView *firstTappedTileView = ((MemoransTileView *)self.chosenTileViews[0]);
        MemoransTileView *secondTappedTileView = ((MemoransTileView *)self.chosenTileViews[1]);

        // Empty the chosen tiles array, preparing it for the next action.

        [self.chosenTileViews removeAllObjects];

        // The 2 chosen views have been played, so reset the chosen flag.
        // So that if not paired they will be choosable again.

        firstTappedTileView.chosen = NO;
        secondTappedTileView.chosen = NO;

        if (firstTappedTileView.paired && secondTappedTileView.paired)
        {
            // The 2 chosen tiles were paired, so remove them from the unpaired tile
            // views.

            [self.tileViewsLeft removeObject:firstTappedTileView];
            [self.tileViewsLeft removeObject:secondTappedTileView];
        }

        if ([self.tileViewsLeft count] != 0)
        {
            // There are more tiles left to match.
            // Save the game status.

            if ([self archiveGameControllerStatus])
            {
                // If the saving was completed succesfully, then this level has a game
                // save.

                [self currentLevel].hasSave = YES;
            }
        }
        else
        {
            // No more tiles to match are left! Game is over!
            // Prepare to go to the next level or replay the current one.

            [self completeLevel];
        }
    }
}

- (void)completeLevel
{
    if ([self.tileViewsLeft count] == 0)
    {
        // No more tiles to match are left! Game is over!

        if ([self currentLevel].hasSave)
        {
            // This game is not partially played anymore so remove its save.

            [self deleteSavedGameControllerStatus];

            [self currentLevel].hasSave = NO;
        }

        // Game is over!

        self.isGameOver = YES;

        if (!self.isBadScore)
        {
            // This level was completed succesfully (positive score).

            [self currentLevel].completed = YES;

            // Add a wobbling animation to the next level button to notify that the
            // user can go to
            // the next level.

            [Utilities addWobblingAnimationToView:self.nextLevelButton
                                  withRepeatCount:50
                                      andDelegate:nil];

            // This is an array of victorious messages to display.

            NSArray *endMessages = @[
                [self.sharedLocalizationController localizedStringForKey:@"Well Done!"],
                [self.sharedLocalizationController localizedStringForKey:@"Great!"],
                [self.sharedLocalizationController localizedStringForKey:@"Excellent!"],
                [self.sharedLocalizationController localizedStringForKey:@"Superb!"],
                [self.sharedLocalizationController localizedStringForKey:@"Outstanding!"],
                [self.sharedLocalizationController localizedStringForKey:@"Awesome!"]
            ];

            // Add an overlay text.

            MemoransOverlayView *endMessageOverlayView = [self addMessageOverlayView];

            // Display the overlay text with one victorious message.
            // Choose the message using the score.

            endMessageOverlayView.overlayString = [NSString
                stringWithFormat:@"%@", endMessages[self.game.gameScore % [endMessages count]]];

            // Animate the overlay text.

            [Utilities animateOverlayView:endMessageOverlayView withDuration:1.5f];

            // Update the UI according to the new game status.

            [self updateUIWithNewGame:NO];
        }
        else
        {
            // This level was completed but the user got a negative score.
            // Restart a new game in this same level.

            [self restartGameWithNextLevel:NO];
        }
    }
}

- (void)restartGameWithNextLevel:(BOOL)next
{
    if (next)
    {
        // Start a new game in the next level.

        // Increase level number.

        self.currentLevelNumber++;

        // New level: no previous bad score.

        self.isBadScore = NO;
    }
    else
    {
        if ([self currentLevel].hasSave)
        {
            // New game in the same level.

            // Delete previous game save for this level.

            [self deleteSavedGameControllerStatus];

            [self currentLevel].hasSave = NO;
        }
    }

    // Remove all the tile views.

    [self.tileArea.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    // Empty tile views related arrays.

    self.tileViews = nil;
    self.tileViewsLeft = nil;
    self.chosenTileViews = nil;

    // Release the previous game engine instance.

    self.game = nil;

    // New game: no tiles are wobbling.

    self.wobblingTilesCount = 0;

    // Update UI taking into account that it's a NEW game.

    [self updateUIWithNewGame:YES];
}

- (void)resumeGame
{
    // This method reload the last partially played game.

    // Get the game engine instance from the save file.

    _game = [NSKeyedUnarchiver
        unarchiveObjectWithFile:[self filePathForArchivingWithName:@"gameStatus.archive"]];

    // Get the tile views array from the save file.

    _tileViews = [NSKeyedUnarchiver
        unarchiveObjectWithFile:[self filePathForArchivingWithName:@"tileViewsStatus.archive"]];

    UITapGestureRecognizer *tileTapRecog;

    for (MemoransTileView *tileView in self.tileViews)
    {
        // Create a tap recognizer.

        tileTapRecog =
            [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tileTapped:)];

        // Single finger tap to choose a tile.

        tileTapRecog.numberOfTapsRequired = 1;
        tileTapRecog.numberOfTouchesRequired = 1;

        // Add the tap recognizer to the resumed tile view.

        [tileView addGestureRecognizer:tileTapRecog];

        // Add the resumed tile view to the tile area.

        [self.tileArea addSubview:tileView];

        if (tileView.chosen)
        {
            // The resumed view was chosen, so add it to the chosen views array.

            [self.chosenTileViews addObject:tileView];
        }

        if (tileView.paired)
        {
            // The resumed tile view was paired, so remove it from the unpaired tile
            // views array.

            [self.tileViewsLeft removeObject:tileView];
        }
    }
}

- (NSArray *)levelsPack
{
    // Return the levels array property of the singleton object.

    return [MemoransSharedLevelsPack sharedLevelsPack].levelsPack;
}

- (MemoransGameLevel *)currentLevel
{

    if (self.currentLevelNumber > [[self levelsPack] count] - 1)
    {
        // The current level number is out of range, return nil.

        return nil;
    }

    // Return the level object that matches the current level number.

    return (MemoransGameLevel *)[self levelsPack][self.currentLevelNumber];
}

- (MemoransGameLevel *)nextLevel
{
    if (self.currentLevelNumber + 1 > [[self levelsPack] count] - 1)
    {
        // The next level number is out of range, return nil.

        return nil;
    }

    // Return the next level object in the array of levels.

    return (MemoransGameLevel *)[self levelsPack][self.currentLevelNumber + 1];
}

#pragma mark - CAAnimation DELEGATE METHODS

- (void)animationDidStart:(CAAnimation *)anim
{
    // A wobbling animation has started on a view.
    // Increase the count of views currently wobbling.

    self.wobblingTilesCount++;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (!self.wobblingTilesCount)
    {
        // This method has been called but no views are currently wobbling, exit.

        return;
    }

    // A view has stopped wobbling, decrease the count of views currently
    // wobbling.

    self.wobblingTilesCount--;

    if (!self.wobblingTilesCount)
    {
        // No views are wobbling!

        for (MemoransTileView *tileView in self.chosenTileViews)
        {
            // Wobbling animation is to visually notify the user that the chosen tiles
            // didn't match.
            // If tiles have finished wobbling, put them back face down, animating.

            [UIView transitionWithView:tileView
                duration:0.3f
                options:UIViewAnimationOptionTransitionFlipFromLeft
                animations:^{

                    // Tiles are not shown anymore. Put them face down.

                    tileView.shown = NO;
                }
                completion:^(BOOL finished) {

                    if ([self.chosenTileViews indexOfObject:tileView] == 1)
                    {
                        // Here we have finished flipping back the second chosen tile.
                        // Clean up and save the game status.

                        [self finishAndSave];
                    }
                }];
        }
    }
}

#pragma mark - TILES SIZING AND PLACING

- (NSInteger)numOfTilesCols
{
    // This method returns the number of columns available for placing the tiles,
    // according to the number of tiles. This helps dynamically place the tiles in
    // a good layout, no
    // matter the number.

    for (int r = 6; r >= 2; r--)
    {
        // Trying 6, 5, 4, 3, 2 rows tiles layout.

        // Using the current number of rows, get the possible number of cols.

        int c = ((int)[self currentLevel].tilesInLevel / r);

        if ([self currentLevel].tilesInLevel % r == 0 && r <= c)
        {
            // The game has a landscape layout only, so we want the number of rows
            // (matrix height)
            // to be less than the number of cols (matrix width), and that the number
            // of tiles fit
            // perfectly in the matrix layout (that is when the number of tiles is
            // divisible
            // by the number of rows).

            // The above conditions are satisfied (for the highest possible number of
            // rows), so
            // return the number of columns.

            return c;
        }
    }

    return 0;
}

- (NSInteger)numOfTilesRows
{
    // This method returns the number of rows available for placing the tiles,
    // according to the number of tiles. This helps dynamically place the tiles in
    // a good layout, no
    // matter the number.

    for (int r = 6; r >= 2; r--)
    {
        // Trying 6, 5, 4, 3, 2 rows tiles layout.

        // Using the current number of rows, get the possible number of cols.

        int c = ((int)[self currentLevel].tilesInLevel / r);

        if ([self currentLevel].tilesInLevel % r == 0 && r <= c)
        {
            // The game has a landscape layout only, so we want the number of rows
            // (matrix height)
            // to be less than the number of cols (matrix width), and that the number
            // of tiles fit
            // perfectly in the matrix layout (that is when the number of tiles is
            // divisible
            // by the number of rows).

            // The above conditions are satisfied (for the highest possible number of
            // rows), so
            // return the number of rows.

            return r;
        }
    }

    return 0;
}

// The default margin between the tiles.

static const NSInteger gTileMargin = 5;

- (CGFloat)tileWidth
{
    // The tile width is equal to the matrix cell width minus 2 times the default
    // margin.

    // Get the matrix cell width.

    NSInteger cellWidth = self.tileArea.bounds.size.width / [self numOfTilesCols];

    // Return the tile width.

    return cellWidth - gTileMargin * 2;
}

- (CGFloat)tileHeight
{
    // The tile height is equal to the matrix cell height minus 2 times the
    // default margin.

    // Get the matrix cell height.

    NSInteger cellHeight = self.tileArea.bounds.size.height / [self numOfTilesRows];

    // Return the tile height.

    return cellHeight - gTileMargin * 2;
}

- (CGRect)frameForTileAtRow:(NSInteger)i Col:(NSInteger)j
{
    // This method returns a frame for a tile at the given matrix coordinates
    // (i-th row, j-th col).

    // Get cell width and height.

    CGFloat cellWidth = self.tileArea.bounds.size.width / self.numOfTilesCols;
    CGFloat cellHeight = self.tileArea.bounds.size.height / self.numOfTilesRows;

    // Frame origin X is equal to j times the cellWidth, plus the default left
    // margin.

    CGFloat frameOriginX = j * cellWidth + gTileMargin;

    // Frame origin Y is equal to j times the cellHeight, plus the default top
    // margin.

    CGFloat frameOriginY = i * cellHeight + gTileMargin;

    // Return the i,j frame to draw a tile in.

    return CGRectMake(frameOriginX, frameOriginY, self.tileWidth, self.tileHeight);
}

#pragma mark - VIEWS MANAGEMENT AND UPDATE

- (void)updateUIWithNewGame:(BOOL)newGame
{
    if (newGame)
    {
        // Update the UI for a new game!

        // Add an overlay message to display at the game start.

        MemoransOverlayView *startMessageOverlayView = [self addMessageOverlayView];

        if ([self currentLevel].hasSave)
        {
            // The current level has game saved.

            // Resume the partially played game instead of creating a fresh one.

            [self resumeGame];

            // The overlay message has to notify it's a resumed game.

            startMessageOverlayView.overlayString =
                [self.sharedLocalizationController localizedStringForKey:@"Game\nResumed"];
        }
        else
        {
            // No saved game are present for this level.
            // Create a fresh new game in the current level.

            // Create the tile views and drop them animating.

            [self createAndAnimateTileViews];

            if (self.isBadScore && self.isGameOver)
            {
                // New game after a previously game that has just been fully played
                // with a negative score. Let's notify this with an overlay message.

                // The start overlay message will notify that the user got a bad score
                // in the
                // previously fully-played game.
                // This is an automatic restart after the user lost a game.

                startMessageOverlayView.overlayString = [self.sharedLocalizationController
                    localizedStringForKey:@"Bad Score\nTry Again"];

                startMessageOverlayView.overlayColor =
                    [Utilities colorFromHEXString:@"#FF1300" withAlpha:1];
            }
            else
            {
                // No previous bad score is present as this is the first game in this
                // level or the
                // user hit the restart button after played the game succesfully or
                // partially.

                // The overlay message will simply display the level number and type.

                NSString *levelString =
                    [self.sharedLocalizationController localizedStringForKey:@"Level"];

                startMessageOverlayView.overlayString = [NSString
                    stringWithFormat:@"%@ %d\n%@", levelString, (int)self.currentLevelNumber + 1,
                                     [self currentLevel].levelType];
            }
        }

        // Get a dynamic gradient and push it to the very background.

        [self.view.layer insertSublayer:self.gradientLayer atIndex:0];

        // If the next button is still wobbling, stop it.

        [self.nextLevelButton.layer removeAllAnimations];

        // Animate and display the overlay start message.

        [Utilities animateOverlayView:startMessageOverlayView withDuration:1.8f];

        // A new game is naturally not yet over.

        self.isGameOver = NO;

        // Play a different music according to level type.

        if ([[self currentLevel].levelType isEqualToString:@"Happy"])
        {
            // This is an Happy level.

            [self.sharedAudioController playMusicFromResource:@"TheBuilder"
                                                       ofType:@"mp3"
                                                   withVolume:0.8f];
        }
        else
        {
            // This is an Angry level.

            [self.sharedAudioController playMusicFromResource:@"SchemingWeaselfaster"
                                                       ofType:@"mp3"
                                                   withVolume:0.9f];
        }
    }

    if ([self.tileViews count] < 6)
    {
        // Something went wrong, we have less than 6 tiles in game.
        // Restart the game in this level and exit.

        [self restartGameWithNextLevel:NO];

        return;
    }

    if ([self.tileViewsLeft count] != 0)
    {
        // This game is being played, it's not over yet.

        MemoransTile *gameTile;
        NSInteger tileIndex;

        for (MemoransTileView *tileView in self.tileViews)
        {
            // For each tile view, update its status in the UI.

            // Get this tile view index.

            tileIndex = [self.tileViews indexOfObject:tileView];

            if (tileIndex != NSNotFound)
            {
                // Get the game tile in the engine corresponding to this tile view.

                gameTile = [self.game gameTileAtIndex:tileIndex];

                // Synchronize the tile view status to the game tile status.

                tileView.imageID = gameTile.tileID;
                tileView.paired = gameTile.paired;
            }
        }
    }

    // The next level button is hidden if the current level is not succesfully
    // completed
    // and viceversa.

    self.nextLevelButton.hidden = ![self currentLevel].completed;

    // Update the bad score flag status, it's bad if the score is negative.

    self.isBadScore = (self.game.gameScore < 0);

    // Update the score label to display the latest score from the game engine.

    self.scoreLabel.attributedText = [Utilities
        styledAttributedStringWithString:[NSString
                                             stringWithFormat:@"★ %d", (int)self.game.gameScore]
                           andAlignement:NSTextAlignmentCenter
                                andColor:nil
                                 andSize:60
                          andStrokeColor:nil];
}

- (void)createAndAnimateTileViews
{
    // This method is called when creating a fresh new game.

    MemoransTileView *tileView;

    CGRect tileOnBoardFrame;

    UITapGestureRecognizer *tileTapRecog;

    // The tile view back side image is one of the six different back images
    // available.
    // Choose using the level number.

    NSString *tileBackImage =
        [NSString stringWithFormat:@"tileBackRibbon%d", (int)self.currentLevelNumber % 6];

    NSInteger tileYOffset;

    for (int i = 0; i < self.numOfTilesRows; i++)
    {
        for (int j = 0; j < self.numOfTilesCols; j++)
        {
            // For each matrix cell available.

            // Get the frame for the tile view.

            tileOnBoardFrame = [self frameForTileAtRow:i Col:j];

            // Create a tile view with the above frame.

            tileView = [[MemoransTileView alloc] initWithFrame:tileOnBoardFrame];

            // Remember the tile view center when it's on screen.

            tileView.onBoardCenter = tileView.center;

            // Get a random vertical offset variable from 0 to the tile view height -
            // 1.
            // This is to vertically scatter the tile view off screen.

            tileYOffset = arc4random() % (int)self.view.frame.size.height;

            // The actual tile view center at game start is off screen.
            // Vertically scattering the tile views of each column allows to create a
            // nice drop
            // animation at game start.

            // The center Y is the visible screen origin Y minus the variable vertical
            // offset and
            // minus the tile view height.

            tileView.center =
                CGPointMake(tileOnBoardFrame.origin.x + tileOnBoardFrame.size.width / 2,
                            (self.view.frame.origin.y - tileYOffset) - tileView.frame.size.height);

            // Set the tile back side image.

            tileView.tileBackImage = tileBackImage;

            // Create and add a single finger tap recognizer to the tile view.

            tileTapRecog =
                [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tileTapped:)];

            tileTapRecog.numberOfTapsRequired = 1;
            tileTapRecog.numberOfTouchesRequired = 1;

            [tileView addGestureRecognizer:tileTapRecog];

            // Add the tile view created to the tile views array.

            [self.tileViews addObject:tileView];

            // Add the tile view created to tile area view.

            [self.tileArea addSubview:tileView];

            // Perform a drop animation with each tile view.

            [UIView animateWithDuration:2.0f
                                  delay:0
                 usingSpringWithDamping:0.6f
                  initialSpringVelocity:0.4f
                                options:0
                             animations:^{

                                 // Drop the tile view from off screen to the on
                                 // screen correct
                                 // place, bouncing it.

                                 tileView.center = tileView.onBoardCenter;
                             }
                             completion:nil];
        }
    }
}

- (MemoransOverlayView *)addBonusScoreOverlayView
{
    // An overlay view configured to display the latest positive change to the
    // game score.

    MemoransOverlayView *bonusScoreOverlayView = [[MemoransOverlayView alloc]
        initWithString:[NSString stringWithFormat:@"+%d", (int)self.game.lastDeltaScore]
              andColor:[Utilities colorFromHEXString:@"#0BD318" withAlpha:1]
           andFontSize:200];

    // Add the overlay view to the main view.

    [self.view addSubview:bonusScoreOverlayView];

    // Return the overlay view.

    return bonusScoreOverlayView;
}

- (MemoransOverlayView *)addMalusScoreOverlayView
{
    // An overlay view configured to display the latest negative change to the
    // game score.

    MemoransOverlayView *malusScoreOverlayView = [[MemoransOverlayView alloc]
        initWithString:[NSString stringWithFormat:@"%d", (int)self.game.lastDeltaScore]
              andColor:[Utilities colorFromHEXString:@"#FF1300" withAlpha:1]
           andFontSize:200];

    // Add the overlay view to the main view.

    [self.view addSubview:malusScoreOverlayView];

    // Return the overlay view.

    return malusScoreOverlayView;
}

- (MemoransOverlayView *)addMessageOverlayView
{
    // An overlay view for on-screen messages.

    MemoransOverlayView *messageOverlayView =
        [[MemoransOverlayView alloc] initWithString:nil andColor:nil andFontSize:130];

    // Add the overlay view to the main view.

    [self.view addSubview:messageOverlayView];

    // Return the overlay view.

    return messageOverlayView;
}

- (void)viewDidLoad
{
    // This controller’s view was loaded into memory!

    [super viewDidLoad];

    // The tile area view must be transparent to let the user see the nice
    // background gradient.

    self.tileArea.backgroundColor = [UIColor clearColor];

    // Configure restart button, next level button, and back button to look
    // consistently throughout
    // the whole app.

    [Utilities configureButton:self.restartGameButton withTitleString:@"↺" andFontSize:50];

    [Utilities configureButton:self.nextLevelButton withTitleString:@"▶︎" andFontSize:50];

    [Utilities configureButton:self.backToLevelsButton withTitleString:@"⬅︎" andFontSize:50];

    // Be sure to always bring the tile area and its subviews (tile views) to the
    // front,
    // so the tile views can drop above all the other elements at game start.

    [self.view bringSubviewToFront:self.tileArea];
}

- (void)viewWillAppear:(BOOL)animated
{
    // This controller’s view is about to go on screen!

    [super viewWillAppear:animated];

    // Every time this view is about to go on screen, be sure to update the UI
    // with a new game.

    [self updateUIWithNewGame:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // This controller’s view is about to go OFF screen!

    [super viewWillDisappear:animated];

    // Save the game levels status (locked / unlocked, etc..).

    [[MemoransSharedLevelsPack sharedLevelsPack] archiveLevelsStatus];
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

#pragma mark - ARCHIVING

- (NSString *)filePathForArchivingWithName:(NSString *)filename
{
    // User's documents folder in the app sandbox.

    NSString *documentDirectory =
        NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];

    // Return a path to the specified file in the user's documents folder.

    return [documentDirectory stringByAppendingPathComponent:filename];
}

- (BOOL)archiveGameControllerStatus
{
    // This methods saves game engine status and UI status.

    // Call the archiving chain on the game engine.

    BOOL gameArchiving = [NSKeyedArchiver
        archiveRootObject:self.game
                   toFile:[self filePathForArchivingWithName:@"gameStatus.archive"]];

    // Call the archiving chain on the tile views array.

    BOOL tileViewsArchiving = [NSKeyedArchiver
        archiveRootObject:self.tileViews
                   toFile:[self filePathForArchivingWithName:@"tileViewsStatus.archive"]];

    // If both the archiving operations were successful this method worked
    // properly.

    return (gameArchiving && tileViewsArchiving);
}

- (BOOL)deleteSavedGameControllerStatus
{
    // Get a file manager.

    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSError *gameError;

    // Remove the game engine status save file.

    BOOL gameArchiveRemoval =
        [fileManager removeItemAtPath:[self filePathForArchivingWithName:@"gameStatus.archive"]
                                error:&gameError];

    NSError *tileError;

    // Remove the UI status save file.

    BOOL tileViewsArchiveRemoval =
        [fileManager removeItemAtPath:[self filePathForArchivingWithName:@"tileViewsStatus.archive"]
                                error:&tileError];

    // If both removals were successful this method worked properly.

    return (gameArchiveRemoval && tileViewsArchiveRemoval);
}

@end
