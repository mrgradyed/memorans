//
//  MemoransSharedAudioController.h
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
//  Created by emi on 26/08/14.
//
//

@import AVFoundation;

#import <Foundation/Foundation.h>

@interface MemoransSharedAudioController : NSObject

#pragma mark - PUBLIC PROPERTIES

// Music and sounds switch options.

@property(nonatomic) BOOL soundsOff;
@property(nonatomic) BOOL musicOff;

#pragma mark - PUBLIC METHODS

// This method creates an instance of this class once and only once
// for the entire lifetime of the application.
// Do NOT use the init method to create an instance, it will just return an exception.

+ (instancetype)sharedAudioController;

// This methods play sound effects on a serial dedicated queue.

- (void)playIiiiSound;
- (void)playUiiiSound;
- (void)playUeeeSound;
- (void)playPopSound;

// This method starts playing the specified music on the default priority global queue.

- (void)playMusicFromResource:(NSString *)fileName
                       ofType:(NSString *)fileType
                   withVolume:(float)volume;

@end
