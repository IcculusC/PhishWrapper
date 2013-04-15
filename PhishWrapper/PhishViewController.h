	//
//  PhishViewController.h
//  PhishWrapper
//
//  Created by llll on 2/21/13.
//  Copyright (c) 2013 llll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhishAPIDelegate.h"
#import "PhishAPI.h"

@interface PhishViewController : UIViewController <PhishAPIDelegate, UITableViewDataSource>
{
    IBOutlet UIButton * clickButton;
    IBOutlet UITableView * tableView;
    PhishAPI * api;
    NSMutableArray * listText;
}

- (IBAction)buttonClicked:(id)sender;

@property (nonatomic) NSString * jsonstring;

@end