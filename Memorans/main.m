//
//  main.m
//  Memorans
//
//  Created by emi on 01/07/14.
//  Copyright (c) 2014 Emiliano D'Alterio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MemoransAppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool
    {

        // WARNING: FOR TESTING ONLY - START -

        [[NSUserDefaults standardUserDefaults] setObject:@[ @"bg" ] forKey:@"AppleLanguages"];

        // WARNING: FOR TESTING ONLY - END -

        return UIApplicationMain(argc, argv, nil, NSStringFromClass([MemoransAppDelegate class]));
    }
}
