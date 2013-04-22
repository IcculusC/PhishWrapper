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
@property (strong, nonatomic) IBOutlet UIBarButtonItem * searchButton;
@property (strong, nonatomic) IBOutlet UITableView * newsTableView;

@end

@implementation PhishViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"LOADED");
    localAPI = [[PhishAPI alloc] initWithMethod:@"pnet.news.get" keyed:NO sender:self];
    [localAPI fetchData];
    
    newsList = [[NSMutableArray alloc] init];
    
    [_newsTableView setDataSource:self];
}

- (void)gotData:(NSData *)dat;
{
    NSLog(@"SUCCESS");
    NSError *e = nil;
    json = [NSJSONSerialization JSONObjectWithData:dat options: NSJSONReadingMutableContainers error:&e];
    
    for(int i=0;i<[json count];i++)
    {
        NSMutableDictionary * dict = [json objectAtIndex:i];
        
        //for(NSString * str in [dict allKeys])
            //NSLog(str);
        
        if([dict objectForKey:@"title"] != [NSNull null])
            [newsList addObject:[dict objectForKey:@"title"]];
        else
        {
            NSString *myString = [dict objectForKey:@"pubdate"];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSDate *yourDate = [dateFormatter dateFromString:myString];
            dateFormatter.dateFormat = @"MMM dd yyyy";
            [newsList addObject:[[NSString alloc] initWithFormat:@"Untitled %@", [dateFormatter stringFromDate:yourDate]]];
        }
    }
    
    [_newsTableView reloadData];
    
    localAPI = nil;
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
    return [newsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * listIdent = @"listEntry";
    
    UITableViewCell * cell = [_newsTableView dequeueReusableCellWithIdentifier:@"NewsItem"];
   
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listIdent];
    }
    
    NSString * item = [newsList objectAtIndex:indexPath.row];
    if (item == [NSNull null]) {
        item = @"Untitled News Entry";
    }
    NSString * noHTML = [item stringByStrippingHTML];
    cell.textLabel.text = noHTML;
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if(sender != _searchButton)
    {
        NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
    
        PhishNewsViewController * target = [segue destinationViewController];
    
        NSMutableDictionary * targetDict = [json objectAtIndex:indexPath.row];
    
        NSString * tit = [targetDict objectForKey:@"title"];
        NSString * con = [targetDict objectForKey:@"txt"];
        NSString * dat = [targetDict objectForKey:@"pubdate"];
    
        target.content = [[NSString alloc] initWithFormat:@"<h2> %@ </h2> %@ %@", tit, dat, con];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation NSString (HTMLStringAdditions)

-(NSString *) stringByStrippingHTML {
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

@end
