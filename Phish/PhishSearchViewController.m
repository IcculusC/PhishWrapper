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
@property (strong, nonatomic) IBOutlet UITableView * tableView;
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

    if([json isKindOfClass:[NSArray class]])
        [self performSegueWithIdentifier:@"searchToShow" sender:self];
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

@end
