//
//  PhishSearchViewController.h
//  Phish
//
//  Created by llll on 4/22/13.
//  Copyright (c) 2013 llll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhishAPIDelegate.h"
#import "PhishAPI.h"

@interface PhishSearchViewController : UIViewController <PhishAPIDelegate>
{
    PhishAPI * localAPI;
    NSMutableArray * resultsList;
    NSArray * json;
}

- (IBAction)clickedOK:(id)sender;

@end
