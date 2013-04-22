//
//  PhishViewController.m
//  Phish
//
//  Created by llll on 4/20/13.
//  Copyright (c) 2013 llll. All rights reserved.
//

#import "PhishViewController.h"
#import "PhishNewsViewController.h"

@interface PhishViewController ()

@end

@implementation PhishViewController

@synthesize newsList;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"LOADED");
    localAPI = [[PhishAPI alloc] initWithMethod:@"pnet.news.get" keyed:NO sender:self];
    [localAPI fetchData];
}

- (void)gotData:(NSData *)dat;
{
    NSLog(@"SUCCESS");
    NSError *e = nil;
    NSArray * json = [NSJSONSerialization JSONObjectWithData:dat options: NSJSONReadingMutableContainers error:&e];
}

- (void)connFailed:(NSError *)err;
{
    NSLog(@"ERROR");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10; //[newsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NewsItem"];
   
    cell.textLabel.text = @"TEST";
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
    
    PhishNewsViewController * target = [segue destinationViewController];
    
    target.content = @"TEST";
        
    NSLog(@"SEGUE!");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
