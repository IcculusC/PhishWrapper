//
//  PhishViewController.m
//  PhishWrapper
//
//  Created by llll on 2/21/13.
//  Copyright (c) 2013 llll. All rights reserved.
//

#import "PhishViewController.h"
#import "PhishAPI.h"

@interface PhishViewController ()

@end

@implementation PhishViewController

@synthesize jsonstring;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    api = [[PhishAPI alloc] initWithMethod:@"pnet.news.get" keyed:NO sender:self];
    [api fetchData];
    
    listText = [[NSMutableArray alloc] init];
    
    [tableView setDataSource:self];
	
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClicked:(id)sender
{
    api = [[PhishAPI alloc] initWithMethod:@"pnet.news.get" keyed:NO sender:self];
    [api fetchData];
}

- (void)gotData:(NSData *)dat
{
    NSLog(@"gotData");
    
    NSError * e = nil;
    
    NSArray * arr = [NSJSONSerialization JSONObjectWithData:dat options:NSJSONReadingMutableContainers error:&e];
    
    for(int i=0;i<[arr count];i++)
    {
        NSMutableDictionary * dict = [arr objectAtIndex:i];
        
        for(NSString * str in [dict allKeys])
            NSLog(str);
            
        //if([dict objectForKey:@"title"])
        //    [listText addObject:[dict objectForKey:@"title"]];
    }
    
    //[tableView reloadData];
    
    api = nil;
}

- (void)connFailed:(NSError *)err
{
    NSString * error = [err localizedDescription];
    NSLog(@"%@", error);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableV numberOfRowsInSection:(NSInteger)section
{
    return [listText count];
}

- (UITableViewCell *)tableView:(UITableView *)tableV cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * listIdent = @"listEntry";
    
    UITableViewCell * cell = [tableV dequeueReusableCellWithIdentifier:listIdent];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listIdent];
    }

    [[cell textLabel] setText:[listText objectAtIndexedSubscript:indexPath.row]];
    
    return cell;
}

@end
