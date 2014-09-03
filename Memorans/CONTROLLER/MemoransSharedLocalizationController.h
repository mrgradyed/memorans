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

@property(strong, nonatomic, readonly) NSString *currentLanguageCode;

#pragma mark - PUBLIC METHODS

- (NSString *)localizedStringForKey:(NSString *)key;

- (void)setAppLanguage:(NSString *)language;

- (NSString *)nextSupportedLanguage;

+ (instancetype)sharedLocalizationController;

@end
