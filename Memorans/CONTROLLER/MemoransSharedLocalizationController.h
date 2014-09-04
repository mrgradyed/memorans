//
//  MemoransSharedLocalizationController.h
//  Memorans
//
//  Created by emi on 30/08/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemoransSharedLocalizationController : NSObject

#pragma mark - PUBLIC PROPERTIES

// The current language (code) used in the app.

@property(strong, nonatomic, readonly) NSString *currentLanguageCode;

#pragma mark - PUBLIC METHODS

// This method actually performs the localization of a string (the "key" parameter),
// according to the current language set.
// This method is meant to be used in place of NSLocalizedString in the code.

- (NSString *)localizedStringForKey:(NSString *)key;

// This method change the language bundle used to localize the app strings.

- (void)setAppLanguage:(NSString *)language;

// This method returns the next language actually supported by the app,
// it circularly iterates the list of supported languages starting from the current set one.

- (NSString *)nextSupportedLanguage;

// This method creates an instance of this class once and only once
// for the entire lifetime of the application.
// Do NOT use the init method to create an instance, it will just return an exception.

+ (instancetype)sharedLocalizationController;

@end
