//
//  MemoransSharedLocalizationController.m
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
//  Created by emi on 30/08/14.
//
//

#import "MemoransSharedLocalizationController.h"

@interface MemoransSharedLocalizationController ()

#pragma mark - PROPERTIES

// The current bundle used by the app to localize the strings.

@property(strong, nonatomic) NSBundle *currentBundle;

// The current language (code) used in the app.

@property(strong, nonatomic) NSString *currentLanguageCode;

// The default language code used as a safe fall-back value.

@property(strong, nonatomic) NSString *defaultLanguageCode;

@end

@implementation MemoransSharedLocalizationController

#pragma mark - SETTERS AND GETTERS

- (NSBundle *)currentBundle
{
    // If the current language bundle is nil, create it with the default language.

    if (!_currentBundle)
    {
        // The default language code is computed in the private init method,
        // according to user preferences and the app language support.

        NSString *defaultLanguageFolder =
            [[NSBundle mainBundle] pathForResource:self.defaultLanguageCode ofType:@"lproj"];

        _currentBundle = [NSBundle bundleWithPath:defaultLanguageFolder];
    }

    return _currentBundle;
}

#pragma mark - LANGUAGE AND LOCALIZATION METHODS

- (NSString *)localizedStringForKey:(NSString *)key
{
    // This method actually performs the localization of a string (the "key" parameter),
    // according to the current language set.
    // This method is meant to be used in place of NSLocalizedString in the code.

    // Use the current language bundle to localize the string passed.

    return [self.currentBundle localizedStringForKey:key value:@"??" table:nil];
}

- (void)setAppLanguage:(NSString *)language
{
    // This method actually change the language bundle used in the app.

    // Look for a language folder according to the passed language parameter.

    NSString *languageFolder = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];

    // Set the current language used to the one passed.

    self.currentLanguageCode = language;

    if (!languageFolder)
    {
        // If there's not a folder for the language requested,
        // fall back to the default language folder.

        languageFolder = [[NSBundle mainBundle] pathForResource:self.defaultLanguageCode ofType:@"lproj"];

        // Set the current language used back to the default one.

        self.currentLanguageCode = self.defaultLanguageCode;
    }

    // Write to a local user's language preference the language code currently set.

    [[NSUserDefaults standardUserDefaults] setObject:self.currentLanguageCode forKey:@"appLanguage"];

    // Update the actual used language bundle to point to the language folder computed.

    self.currentBundle = [NSBundle bundleWithPath:languageFolder];
}

- (NSString *)nextSupportedLanguage
{
    // The index of the current set language

    NSInteger currentLanguageIndex =
        [[MemoransSharedLocalizationController supportedLanguagesCodes] indexOfObject:self.currentLanguageCode];

    // The index of the next language in the list of the languages by the app,
    // starting from the current set one. If the current language is the last of the list,
    // the next one is the first one.

    NSInteger nextLanguageIndex =
        (currentLanguageIndex + 1) % [[MemoransSharedLocalizationController supportedLanguagesCodes] count];

    // Returns the code of the next language.

    return [MemoransSharedLocalizationController supportedLanguagesCodes][nextLanguageIndex];
}

#pragma mark - CLASS METHODS

+ (instancetype)sharedLocalizationController
{
    // The class method which actually creates the singleton.

    // The static variable which will hold the single and only instance of this class.

    static MemoransSharedLocalizationController *sharedLocalizationController;

    static dispatch_once_t blockHasCompleted;

    // Create an instance of this class once and only once for the lifetime of the application.

    dispatch_once(&blockHasCompleted, ^{ sharedLocalizationController = [[self alloc] initActually]; });

    return sharedLocalizationController;
}

+ (NSArray *)supportedLanguagesCodes
{
    // Return list of localizations actually present in the app.

    return [[NSBundle mainBundle] localizations];
}

#pragma mark - INIT

- (instancetype)init
{
    // Return an exception if someone try to use the default init
    // instead of creating a singleton by using the class method.
    NSString *exceptionString =
        [NSString stringWithFormat:@"Please use: [%@ sharedInstance] instead.", NSStringFromClass([self class])];

    @throw [NSException exceptionWithName:@"SingletonException" reason:exceptionString userInfo:nil];

    return nil;
}

- (instancetype)initActually
{
    // The actual (private) init method used by the class method to create a singleton.

    self = [super init];

    if (self)
    {
        // The localizations actually present in the app.

        NSArray *supportedLanguagesCodes = [MemoransSharedLocalizationController supportedLanguagesCodes];

        // The local user's language preference set from inside the app.

        NSString *previouslySetAppLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:@"appLanguage"];

        if (previouslySetAppLanguage)
        {
            // If user previously set a language preference from inside the app,
            // use that as default language.

            _defaultLanguageCode = previouslySetAppLanguage;
        }
        else
        {
            // Else if there isn't a local user's language preference (as on the app first launch),
            // use the first language in the system AppleLanguages preference list
            // that is supported by the app.

            for (NSString *code in [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"])
            {
                if ([supportedLanguagesCodes containsObject:code])
                {
                    _defaultLanguageCode = code;
                    break;
                }
            }
        }

        // If no language in the system AppleLanguages preference list is supported by the app
        // then default to English if the app supports it
        // or default to the first language present in the app if not.

        if (!_defaultLanguageCode)
        {
            if ([supportedLanguagesCodes containsObject:@"en"])
            {
                _defaultLanguageCode = @"en";
            }
            else
            {
                _defaultLanguageCode = supportedLanguagesCodes[0];
            }
        }

        // When the app starts set the current language used to the default one.

        _currentLanguageCode = _defaultLanguageCode;
    }

    return self;
}

@end
