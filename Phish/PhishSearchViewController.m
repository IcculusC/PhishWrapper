//
//  PhishSearchViewController.m
//  Phish
//
//  Created by llll on 4/22/13.
//  Copyright (c) 2013 llll. All rights reserved.
//

#import "PhishSearchViewController.h"
#import "PhishShowViewController.h"

@interface PhishSearchViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem * confirmButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIDatePicker * datePicker;

@end

@implementation PhishSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    fromSearchFallback = NO;
    showedAlert = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickedOK:(id)sender
{
    NSDateComponents * comps = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit) fromDate:[_datePicker date]];
    
    NSString * prettydate;
    
    if([comps day] < 10)
    {
        if([comps month] < 10)
        {
            prettydate = [[NSString alloc] initWithFormat:@"%d-0%d-0%d", [comps year], [comps month], [comps day]];
        }
        else
        {
            prettydate = [[NSString alloc] initWithFormat:@"%d-%d-0%d", [comps year], [comps month], [comps day]];
        }
    }
    else
    {
        if([comps month] < 10)
        {
            prettydate = [[NSString alloc] initWithFormat:@"%d-0%d-%d", [comps year], [comps month], [comps day]];
        }
    }
    
    NSString * method = [[NSString alloc] initWithFormat:@"showdate=%@", prettydate];
    
    localAPI = [[PhishAPI alloc] initWithMethod:@"pnet.shows.setlists.get" arguments:method keyed:YES sender:self];
    
    [localAPI fetchData];
}

- (void)gotData:(NSData *)dat method:(NSString *)method
{
    NSLog(@"%@", method);
    NSLog(@"SEARCH SUCCESSFUL");
    NSError *e = nil;
    NSMutableDictionary *temp = [[NSMutableDictionary alloc]init];
    BOOL failure = NO;
    json = [NSJSONSerialization JSONObjectWithData:dat options: NSJSONReadingMutableContainers error:&e];
    
    if ([json isKindOfClass:[NSMutableDictionary class]]) {
        temp = json;
        if ([temp objectForKey:@"success"] != [NSNull null])
            failure = YES;
    }
        
    if ([method isEqualToString:@"pnet.shows.setlists.get"] && !failure)
    {
        [self performSegueWithIdentifier:@"searchToShow" sender:self];
        fromSearchFallback = NO;
    }
    else if ([method isEqualToString:@"pnet.shows.setlists.get"] && failure)
    {
        localAPI = Nil;
                
        NSString * method = [[NSString alloc] initWithFormat:@"year=%d", [[[NSCalendar currentCalendar] components:(NSYearCalendarUnit) fromDate:[_datePicker date]] year]];
        
        localAPI = [[PhishAPI alloc] initWithMethod:@"pnet.shows.query" arguments:method keyed:YES sender:self];
        [localAPI fetchData];
        
        fromSearchFallback = YES;
    }
    else if ([method isEqualToString:@"pnet.shows.query"] && !failure)
    {
        resultsList = [[NSMutableArray alloc] init];
        idList = [[NSMutableArray alloc] init];
        for(int i=0;i<[json count];i++)
        {
            NSMutableDictionary * dict = [json objectAtIndex:i];
            
            if([dict objectForKey:@"nicedate"] != [NSNull null])
                [resultsList addObject:[dict objectForKey:@"nicedate"]];
            
            if ([dict objectForKey:@"showid"] != [NSNull null])
                [idList addObject:[dict objectForKey:@"showid"]];

        }
        [_tableView reloadData];
        NSLog(@"%@", json);
        fromSearchFallback = NO;
    }
    else if ([method isEqualToString:@"pnet.shows.query"] && failure)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Shows"
                                                        message:[[NSString alloc] initWithFormat:@"No shows for the year %d.", [[[NSCalendar currentCalendar] components:(NSYearCalendarUnit) fromDate:[_datePicker date]] year]]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        fromSearchFallback = NO;
        return;
    }
}

- (void)connFailed:(NSError *)err
{
    NSLog(@"SEARCH FAILED");
    NSLog(@"%@", [err description]);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"searchToShow"])
    {       
        PhishShowViewController * target = [segue destinationViewController];
        
        NSMutableDictionary * dict = [json objectAtIndex:0];
        
        if([dict objectForKey:@"nicedate"] != [NSNull null])
            target.title = [dict objectForKey:@"nicedate"];
        
        if([dict objectForKey:@"setlistdata"] != [NSNull null])
        {
            target.content = [dict objectForKey:@"setlistdata"];
            target.content = [target.content stringByAppendingString:@"<BR>"];
            target.content = [target.content stringByAppendingString:[dict objectForKey:@"setlistnotes"]];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [resultsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * listIdent = @"listEntry";
    
    UITableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:@"SearchItem"];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listIdent];
    }
    
    NSString * item = [resultsList objectAtIndex:indexPath.row];
    if (item == [NSNull null]) {
        item = @"Untitled Search Entry";
    }
    cell.textLabel.text = item;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * showid = [idList objectAtIndex:[indexPath row]];
        
    NSString * method = [[NSString alloc] initWithFormat:@"showid=%@", showid];
    
    localAPI = [[PhishAPI alloc] initWithMethod:@"pnet.shows.setlists.get" arguments:method keyed:YES sender:self];
    
    [localAPI fetchData];
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}	


@end
