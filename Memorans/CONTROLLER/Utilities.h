//
//  MemoransColorConverter.h
//  Memorans
//
//  Created by emi on 29/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

#pragma mark - PUBLIC METHODS

+ (UIColor *)colorFromHEXString:(NSString *)hexString;

+ (NSDictionary *)stringAttributesWithColor:(UIColor *)color andSize:(CGFloat)size;

@end
