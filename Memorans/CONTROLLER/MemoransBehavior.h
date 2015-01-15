//
//  MemoransBehavior.h
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
//  Created by emi on 17/08/14.
//
//

#import <UIKit/UIKit.h>

@interface MemoransBehavior : UIDynamicBehavior

#pragma mark - PUBLIC METHODS

// This method adds an item to this custom behavior.

- (void)addItem:(id<UIDynamicItem>)item;

// This method removes an item from this custom behavior.

- (void)removeItem:(id<UIDynamicItem>)item;

#pragma mark - INIT

// An init method to initialise this custom behavior with an array of objects.

- (instancetype)initWithItems:(NSArray *)items;

@end
