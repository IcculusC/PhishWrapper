//
//  PhishNewsViewController.m
//  Phish
//
//  Created by llll on 4/21/13.
//  Copyright (c) 2013 llll. All rights reserved.
//

#import "PhishNewsViewController.h"

@interface PhishNewsViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSString * title;
@property (weak, nonatomic) IBOutlet NSString * content;

@end

@implementation PhishNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [_webView loadHTMLString:self.title baseURL:Nil];
}

- (void)didReceiveMemoryWarning
{	
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
