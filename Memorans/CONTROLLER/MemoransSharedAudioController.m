//
//  MemoransSharedAudioController.m
//  Memorans
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Created by emi on 26/08/14.
//
//

#import "MemoransSharedAudioController.h"

// The audio controller singleton acts also as the delegate for the music player, in case the play
// is interrupted.

@interface MemoransSharedAudioController () <AVAudioPlayerDelegate>

#pragma mark - PROPERTIES

// The sound effect players.

@property(strong, nonatomic) AVAudioPlayer *iiiiPlayer;
@property(strong, nonatomic) AVAudioPlayer *uiiiPlayer;
@property(strong, nonatomic) AVAudioPlayer *uuuePlayer;
@property(strong, nonatomic) AVAudioPlayer *popPlayer;

// The music player.

@property(strong, nonatomic) AVAudioPlayer *musicPlayer;

// These properties keep track of the music file currently set for playing.

@property(strong, nonatomic) NSString *currentMusicFileName;
@property(strong, nonatomic) NSString *currentMusicFileType;

@end

@implementation MemoransSharedAudioController

#pragma mark - GETTERS AND SETTERS

- (AVAudioPlayer *)iiiiPlayer
{
    //  An AudioPlayer for the iiii.caf sound. Low volume, no repeat.

    if (!_iiiiPlayer)
    {
        _iiiiPlayer = [MemoransSharedAudioController audioPlayerFromResource:@"iiii"
                                                                      ofType:@"caf"
                                                                withDelegate:nil
                                                                      volume:0.4f
                                                            andNumberOfLoops:0];
    }
    return _iiiiPlayer;
}

- (AVAudioPlayer *)uiiiPlayer
{
    //  An AudioPlayer for the uiii.caf sound. Low volume, no repeat.

    if (!_uiiiPlayer)
    {
        _uiiiPlayer = [MemoransSharedAudioController audioPlayerFromResource:@"uiii"
                                                                      ofType:@"caf"
                                                                withDelegate:nil
                                                                      volume:0.4f
                                                            andNumberOfLoops:0];
    }

    return _uiiiPlayer;
}

- (AVAudioPlayer *)uuuePlayer
{
    //  An AudioPlayer for the uuue.caf sound. Low volume, no repeat.

    if (!_uuuePlayer)
    {
        _uuuePlayer = [MemoransSharedAudioController audioPlayerFromResource:@"uuue"
                                                                      ofType:@"caf"
                                                                withDelegate:nil
                                                                      volume:0.4f
                                                            andNumberOfLoops:0];
    }
    return _uuuePlayer;
}

- (AVAudioPlayer *)popPlayer
{
    //  An AudioPlayer for the pop.caf sound. Low volume, no repeat.

    if (!_popPlayer)
    {
        _popPlayer = [MemoransSharedAudioController audioPlayerFromResource:@"pop"
                                                                     ofType:@"caf"
                                                               withDelegate:nil
                                                                     volume:0.4f
                                                           andNumberOfLoops:0];
    }
    return _popPlayer;
}

- (void)setSoundsOff:(BOOL)soundsOff
{
    // Set the status of the soundsOff property.

    _soundsOff = soundsOff;

    if (soundsOff)
    {
        // If soundsOff is YES stop all the sound players and release them.

        [_iiiiPlayer stop];
        [_uiiiPlayer stop];
        [_uuuePlayer stop];
        [_popPlayer stop];

        // We do not need players anymore. Save memory.

        _iiiiPlayer = nil;
        _uiiiPlayer = nil;
        _uuuePlayer = nil;
        _popPlayer = nil;
    }

    // If soundsOff is NO then sound players will be reacreated by the accessor methods when needed.
}

- (void)setMusicOff:(BOOL)musicOff
{
    // Set the status of the musicOff property.

    _musicOff = musicOff;

    if (musicOff)
    {
        // If musicOff is YES stop the music player and release it.

        [_musicPlayer stop];

        // We do not need a music player anymore. Save memory.

        _musicPlayer = nil;
    }
    else
    {
        // If musicOff is NO then (re)create the player with the currently set track and play, we
        // know what music we should play when the music option is turned back on thanks to
        // properties.

        _musicPlayer =
            [MemoransSharedAudioController audioPlayerFromResource:self.currentMusicFileName
                                                            ofType:self.currentMusicFileType
                                                      withDelegate:self
                                                            volume:0.4
                                                  andNumberOfLoops:-1];

        [_musicPlayer play];
    }
}

#pragma mark - SOUNDS EFFECTS PLAY

- (void)playIiiiSound
{
    if (self.soundsOff)
    {
        // Sounds are turned OFF, do not play.

        return;
    }

    dispatch_async([MemoransSharedAudioController sharedSoundEffectsSerialQueue], ^(void) {

        // Play the sound effect on a separate serial queue where all the sounds effects are played
        // in the same order they are dispatched, if the sound player for this effect is still
        // playing from a previous dispatch, then stop, reset and play it again.

        [self.iiiiPlayer stop];

        self.iiiiPlayer.currentTime = 0;

        [self.iiiiPlayer play];
    });
}

- (void)playUiiiSound
{
    if (self.soundsOff)
    {
        // Sounds are turned OFF, do not play.

        return;
    }

    dispatch_async([MemoransSharedAudioController sharedSoundEffectsSerialQueue], ^(void) {

        // Play the sound effect on a separate serial queue where all the sounds effects are played
        // in the same order they are dispatched, if the sound player for this effect is still
        // playing from a previous dispatch, then stop, reset and play it again.

        [self.uiiiPlayer stop];

        self.uiiiPlayer.currentTime = 0;

        [self.uiiiPlayer play];
    });
}

- (void)playUeeeSound
{
    if (self.soundsOff)
    {
        // Sounds are turned OFF, do not play.

        return;
    }

    dispatch_async([MemoransSharedAudioController sharedSoundEffectsSerialQueue], ^(void) {

        // Play the sound effect on a separate serial queue where all the sounds effects are played
        // in the same order they are dispatched, if the sound player for this effect is still
        // playing from a previous dispatch, then stop, reset and play it again.

        [self.uuuePlayer stop];

        self.uuuePlayer.currentTime = 0;

        [self.uuuePlayer play];
    });
}

- (void)playPopSound
{
    if (self.soundsOff)
    {
        // Sounds are turned OFF, do not play.

        return;
    }

    dispatch_async([MemoransSharedAudioController sharedSoundEffectsSerialQueue], ^(void) {

        // Play the sound effect on a separate serial queue where all the sounds effects are played
        // in the same order they are dispatched, if the sound player for this effect is still
        // playing from a previous dispatch, then stop, reset and play it again.

        [self.popPlayer stop];

        self.popPlayer.currentTime = 0;

        [self.popPlayer play];
    });
}

#pragma mark - MUSIC PLAY

- (void)playMusicFromResource:(NSString *)fileName
                       ofType:(NSString *)fileType
                   withVolume:(float)volume
{
    if (self.musicOff)
    {
        // Music is turned OFF, do not play.

        return;
    }

    // From Apple docs: "Unlike the main queue or queues allocated with
    // dispatch_queue_create(), the global concurrent queues
    // schedule blocks as soon as threads become available(non - FIFO completion order)."

    // Get the the default priority global queue.

    dispatch_queue_t globalDefaultQueue =
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_async(globalDefaultQueue, ^(void) {

        // Update properties to keep track of the current music file playing.

        self.currentMusicFileName = fileName;
        self.currentMusicFileType = fileType;

        // We want just one music player at time, so stop the previous playing music player
        // and release it.

        [self.musicPlayer stop];

        self.musicPlayer = nil;

        // Get a new audio player for the music player property. Infinite loops.
        // Set the audio controller singleton as the delegate for the music player, in case the play
        // is interrupted.

        self.musicPlayer = [MemoransSharedAudioController audioPlayerFromResource:fileName
                                                                           ofType:fileType
                                                                     withDelegate:self
                                                                           volume:volume
                                                                 andNumberOfLoops:-1];

        // Play the requested music.

        [self.musicPlayer prepareToPlay];
        [self.musicPlayer play];
    });
}

#pragma mark - CLASS METHODS

+ (dispatch_queue_t)sharedSoundEffectsSerialQueue
{
    // This method returns always the same serial queue on which all sound effects will be
    // dispatched.

    static dispatch_queue_t soundEffectsSerialQueue;

    static dispatch_once_t blockHasCompleted;

    // Create once and always returns the same serial queue. We want the sounds effect played
    // serially on the same queue in the same order they are dispatched.

    dispatch_once(&blockHasCompleted, ^{

        soundEffectsSerialQueue =
            dispatch_queue_create("SOUND_EFFECTS_SERIAL_QUEUE", DISPATCH_QUEUE_SERIAL);
    });

    return soundEffectsSerialQueue;
}

+ (AVAudioPlayer *)audioPlayerFromResource:(NSString *)fileName
                                    ofType:(NSString *)fileType
                              withDelegate:(id<AVAudioPlayerDelegate>)delegate
                                    volume:(float)volume
                          andNumberOfLoops:(NSInteger)numberOfLoops
{

    // This methods returns a customised audio player.

    if (!fileName || !fileType)
    {
        // If no audio file is provided, do not play.

        return nil;
    }

    // Get the app root folder.

    NSBundle *appBundle = [NSBundle mainBundle];

    // Search for the audio file and load its data.

    NSData *soundData =
        [NSData dataWithContentsOfFile:[appBundle pathForResource:fileName ofType:fileType]];

    NSError *error;

    // Create the audio player.

    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:soundData error:&error];

    if (delegate)
    {
        // If a delegate has benn passed then set it.

        player.delegate = delegate;
    }

    // Configure number of loops and volume.

    player.numberOfLoops = numberOfLoops;
    player.volume = volume;

    return player;
}

+ (instancetype)sharedAudioController
{
    // The class method which actually creates the singleton.

    // The static variable which will hold the single and only instance of this class.

    static MemoransSharedAudioController *sharedAudioController;

    static dispatch_once_t blockHasCompleted;

    // Create an instance of this class once and only once for the lifetime of the application.

    dispatch_once(&blockHasCompleted, ^{ sharedAudioController = [[self alloc] initActually]; });

    return sharedAudioController;
}

#pragma mark - INIT

- (instancetype)init
{
    // Return an exception if someone try to use the default init
    // instead of creating a singleton by using the class method.

    @throw [NSException
        exceptionWithName:@"SingletonException"
                   reason:
                       @"Please use: [MemoransSharedAudioController sharedAudioController] instead."
                 userInfo:nil];

    return nil;
}

- (instancetype)initActually
{
    // The actual (private) init method used by the class method to create a singleton.

    self = [super init];

    if (self)
    {
        NSError *categoryError;

        // Set the audio session. Use the iOS default one.

        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient
                                               error:&categoryError];
    }

    return self;
}

#pragma mark - AVAudioPlayerDelegate PROTOCOL

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    if ([player isEqual:self.musicPlayer] && flags == AVAudioSessionInterruptionOptionShouldResume)
    {
        // In case the music player is interrupted, start playing again when possible.

        // From Apple docs: "Unlike the main queue or queues allocated with
        // dispatch_queue_create(), the global concurrent queues
        // schedule blocks as soon as threads become available(non - FIFO completion order)."

        // Get the the default priority global queue.

        dispatch_queue_t globalDefaultQueue =
            dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

        dispatch_async(globalDefaultQueue, ^(void) {

            // Play the music again.

            [player prepareToPlay];
            [player play];
        });
    }
}

@end
