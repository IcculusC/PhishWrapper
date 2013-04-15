//
//  PhishAppDelegate.h
//  PhishWrapper
//
//  Created by llll on 2/21/13.
//  Copyright (c) 2013 llll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhishAPIDelegate.h"

@class PhishViewController;

@interface PhishAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) PhishViewController *viewController;

@end
