//
//  PhishViewController.h
//  Phish
//
//  Created by llll on 4/20/13.
//  Copyright (c) 2013 llll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhishAPI.h"

@interface PhishViewController : UITableViewController <PhishAPIDelegate>
{
    PhishAPI * localAPI;
    NSMutableArray * newsList;
    NSArray * json;
}

@end
