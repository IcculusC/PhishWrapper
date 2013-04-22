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
    
    NSString * apikey = @"FFD6ACA2EEF31B9DE38E";
    
    NSString * method = [[NSString alloc] initWithFormat:@"pnet.shows.setlists.get&apikey=%@&showdate=%@", apikey, prettydate];
    
    localAPI = [[PhishAPI alloc] initWithMethod:method keyed:YES sender:self];
    
    [localAPI fetchData];
}

- (void)gotData:(NSData *)dat
{
    NSLog(@"SEARCH SUCCESSFUL");
    NSError *e = nil;
    json = [NSJSONSerialization JSONObjectWithData:dat options: NSJSONReadingMutableContainers error:&e];
    
    NSString * apikey = @"FFD6ACA2EEF31B9DE38E";
    
    if([json isKindOfClass:[NSArray class]] && [json count] == 1)
        [self performSegueWithIdentifier:@"searchToShow" sender:self];
    else if([json isKindOfClass:[NSMutableDictionary class]])
    {
        localAPI = Nil;
                
        NSString * method = [[NSString alloc] initWithFormat:@"pnet.shows.query&apikey=%@&year=%d", apikey, [[[NSCalendar currentCalendar] components:(NSYearCalendarUnit) fromDate:[_datePicker date]] year]];
        
        localAPI = [[PhishAPI alloc] initWithMethod:method keyed:YES sender:self];
        [localAPI fetchData];
    }
    else if([json isKindOfClass:[NSMutableArray class]])
    {
        resultsList = [[NSMutableArray alloc] init];
        for(int i=0;i<[json count];i++)
        {
            NSMutableDictionary * dict = [json objectAtIndex:i];
            
            //for(NSString * str in [dict allKeys])
            //NSLog(str);
            
            if([dict objectForKey:@"nicedate"] != [NSNull null])
                [resultsList addObject:[dict objectForKey:@"nicedate"]];
        }
        [_tableView reloadData];
        NSLog(@"%@", json);
    }
}

- (void)connFailed:(NSError *)err
{
    NSLog(@"SEARCH FAILED");
    NSLog([err description]);
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
            target.content = [dict objectForKey:@"setlistdata"];
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
    NSMutableDictionary * dict = [json objectAtIndex:[indexPath row]];
    
    NSString * showid = [dict objectForKey:@"showid"];
    
    NSString * apikey = @"FFD6ACA2EEF31B9DE38E";
    
    NSString * method = [[NSString alloc] initWithFormat:@"pnet.shows.setlists.get&apikey=%@&showid=%@", apikey, showid];
    
    localAPI = [[PhishAPI alloc] initWithMethod:method keyed:YES sender:self];
    
    [localAPI fetchData];
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}	


@end
