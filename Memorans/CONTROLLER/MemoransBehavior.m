//
//  MemoransBehavior.m
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
//  Created by emi on 17/08/14.
//
//

#import "MemoransBehavior.h"

@interface MemoransBehavior () <UICollisionBehaviorDelegate>

#pragma mark - PROPERTIES

// A push force.

@property(strong, nonatomic) UIPushBehavior *push;

// A collision manager.

@property(strong, nonatomic) UICollisionBehavior *collision;

// A bouncing behavior.

@property(strong, nonatomic) UIDynamicItemBehavior *bouncing;

@end

@implementation MemoransBehavior

#pragma mark - SETTERS AND GETTERS

- (UIPushBehavior *)push
{
    if (!_push)
    {
        // A strong push force, directed to the bottom and slightly to the right.

        _push = [[UIPushBehavior alloc] init];
        _push.magnitude = 500.0f;
        _push.angle = 1.45f;
    }

    return _push;
}

- (UICollisionBehavior *)collision
{
    if (!_collision)
    {
        // A collision behavior with this custom behavior as delegate.

        _collision = [[UICollisionBehavior alloc] init];
        _collision.collisionDelegate = self;

        // We set this to NO and we create the boundaries manually, because it seems that after
        // releasing the collision behavior a memory leak occurs as the CGPath for the boundaries is
        // not relased properly.

        _collision.translatesReferenceBoundsIntoBoundary = NO;

        // Get the screen's bounds.

        CGRect screenBounds = [[UIScreen mainScreen] bounds];

        // Get the controller's view's dimensions.

        CGFloat shortSide = MIN(screenBounds.size.width, screenBounds.size.height);
        CGFloat longSide = MAX(screenBounds.size.width, screenBounds.size.height);

        // Get the four screen corners coordinates.
        
        CGFloat margin = 25;
        CGPoint topLeft = CGPointMake(0, margin);
        CGPoint topRight = CGPointMake(longSide, margin);
        CGPoint bottomLeft = CGPointMake(0, shortSide - margin);
        CGPoint bottomRight = CGPointMake(longSide, shortSide - margin);

        // Set the collision boundaries manually to avoid CGPath memory leak in the collision
        // behavior.

        [_collision addBoundaryWithIdentifier:@"1" fromPoint:topLeft toPoint:topRight];
        [_collision addBoundaryWithIdentifier:@"2" fromPoint:topRight toPoint:bottomRight];
        [_collision addBoundaryWithIdentifier:@"3" fromPoint:bottomRight toPoint:bottomLeft];
        [_collision addBoundaryWithIdentifier:@"4" fromPoint:bottomLeft toPoint:topLeft];
    }

    return _collision;
}

- (UIDynamicItemBehavior *)bouncing
{
    if (!_bouncing)
    {
        // A strong bouncing behavior with rotation.

        _bouncing = [[UIDynamicItemBehavior alloc] init];
        _bouncing.elasticity = 0.8f;
        _bouncing.allowsRotation = YES;
    }

    return _bouncing;
}

#pragma mark - ITEMS

- (void)addItem:(id<UIDynamicItem>)item
{
    // A method for adding an item to this custom behavior.

    [self.push addItem:item];
    [self.collision addItem:item];
    [self.bouncing addItem:item];
}

- (void)removeItem:(id<UIDynamicItem>)item
{
    // A method for removing an item frome this custom behavior.

    [self.push removeItem:item];
    [self.collision removeItem:item];
    [self.bouncing removeItem:item];
}

#pragma mark - INIT

- (instancetype)init
{
    self = [super init];

    if (self)
    {
        // Add the push, the collision, and bouncing behaviors to this custom behavior.

        [self addChildBehavior:self.push];
        [self addChildBehavior:self.collision];
        [self addChildBehavior:self.bouncing];
    }

    return self;
}

- (instancetype)initWithItems:(NSArray *)items
{
    // Call the designated initialiser.

    self = [self init];

    if (self)
    {
        // An init method to initialise a custom behavior with an array of objects.

        // Add the items in the array to this custom behavior.

        for (id<UIDynamicItem> item in items)
        {
            [self addItem:item];
        }
    }

    return self;
}

#pragma mark - UICollisionBehaviorDelegate PROTOCOL

- (void)collisionBehavior:(UICollisionBehavior *)behavior
      beganContactForItem:(id<UIDynamicItem>)item1
                 withItem:(id<UIDynamicItem>)item2
                  atPoint:(CGPoint)p
{

    // When the 2 objects collide, remove them from the push force, so they can float free.

    [self.push removeItem:item1];
    [self.push removeItem:item2];
}

@end
