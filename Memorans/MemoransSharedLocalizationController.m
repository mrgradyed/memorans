//
//  MemoransSharedLocalizationController.m
//  Memorans
//
//  Created by emi on 30/08/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import "MemoransSharedLocalizationController.h"

@interface MemoransSharedLocalizationController ()

#pragma mark - PROPERTIES

@property(strong, nonatomic) NSBundle *currentBundle;
@property(strong, nonatomic) NSString *currentLanguageCode;
@property(strong, nonatomic) NSString *defaultLanguageCode;

@end

@implementation MemoransSharedLocalizationController

#pragma mark - SETTERS AND GETTERS

- (NSBundle *)currentBundle
{
    if (!_currentBundle)
    {
        NSString *defaultLanguageFolder =
            [[NSBundle mainBundle] pathForResource:self.defaultLanguageCode ofType:@"lproj"];

        _currentBundle = [NSBundle bundleWithPath:defaultLanguageFolder];
    }

    return _currentBundle;
}

#pragma mark - LANGUAGE AND LOCALIZATION METHODS

- (NSString *)localizedStringForKey:(NSString *)key
{
    return [self.currentBundle localizedStringForKey:key value:@"???" table:nil];
}

- (void)setAppLanguage:(NSString *)language
{
    NSString *languageFolder = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];

    self.currentLanguageCode = language;

    if (!languageFolder)
    {
        languageFolder =
            [[NSBundle mainBundle] pathForResource:self.defaultLanguageCode ofType:@"lproj"];

        self.currentLanguageCode = self.defaultLanguageCode;
    }

    self.currentBundle = [NSBundle bundleWithPath:languageFolder];
}

- (NSString *)nextSupportedLanguage
{
    NSInteger currentLanguageIndex = [[MemoransSharedLocalizationController supportedLanguagesCodes]
        indexOfObject:self.currentLanguageCode];

    NSInteger nextLanguageIndex =
        (currentLanguageIndex + 1) %
        [[MemoransSharedLocalizationController supportedLanguagesCodes] count];

    return [MemoransSharedLocalizationController supportedLanguagesCodes][nextLanguageIndex];
}

#pragma mark - CLASS METHODS

+ (instancetype)sharedLocalizationController
{
    static MemoransSharedLocalizationController *sharedLocalizationController;

    static dispatch_once_t blockHasCompleted;

    dispatch_once(&blockHasCompleted,
                  ^{ sharedLocalizationController = [[self alloc] initActually]; });

    return sharedLocalizationController;
}

+ (NSArray *)supportedLanguagesCodes { return [[NSBundle mainBundle] localizations]; }

#pragma mark - INIT

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"SingletonException"
                                   reason:@"Please use: [MemoransSharedLocalizationController "
                                   @"sharedLocalizationController] instead."
                                 userInfo:nil];

    return nil;
}

- (instancetype)initActually
{
    self = [super init];

    if (self)
    {
        for (NSString *code in
             [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"])
        {
            if ([[MemoransSharedLocalizationController supportedLanguagesCodes]
                    containsObject:code])
            {
                _defaultLanguageCode = code;
                break;
            }
        }

        if (!_defaultLanguageCode)
        {
            if ([[MemoransSharedLocalizationController supportedLanguagesCodes]
                    containsObject:@"en"])

            {
                _defaultLanguageCode = @"en";
            }
            else
            {
                _defaultLanguageCode =
                    [MemoransSharedLocalizationController supportedLanguagesCodes][0];
            }
        }

        _currentLanguageCode = _defaultLanguageCode;
    }

    return self;
}

@end
