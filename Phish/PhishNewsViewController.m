//
//  PhishNewsViewController.m
//  Phish
//
//  Created by llll on 4/21/13.
//  Copyright (c) 2013 llll. All rights reserved.
//

#import "PhishNewsViewController.h"

@interface PhishNewsViewController ()
@property (weak, nonatomic) IBOutlet UIWebView * webView;

@end

@implementation PhishNewsViewController

@synthesize content;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"News";

    [_webView loadHTMLString:self.content baseURL:Nil];
}

- (void)didReceiveMemoryWarning
{	
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
