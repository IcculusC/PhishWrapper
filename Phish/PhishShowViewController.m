//
//  PhishShowViewController.m
//  Phish
//
//  Created by llll on 4/22/13.
//  Copyright (c) 2013 llll. All rights reserved.
//

#import "PhishShowViewController.h"

@interface PhishShowViewController ()
@property (strong, nonatomic) IBOutlet UIWebView * webView;

@end

@implementation PhishShowViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [_webView loadHTMLString:self.content baseURL:Nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
