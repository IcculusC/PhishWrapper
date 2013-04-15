//
//  PhishAPI.m
//  PhishWrapper
//
//  Created by llll on 2/21/13.
//  Copyright (c) 2013 llll. All rights reserved.
//

#import "PhishAPI.h"

@implementation PhishAPI

@synthesize delegate;
@synthesize baseURL;

- (id)initWithMethod:(NSString *)methodName keyed:(BOOL)keyed sender:(id)sender;
{
    self = [super init];
    
    if(self)
    {
        json = [[NSMutableData alloc] init];
        baseURL = @"https://api.phish.net/api.js?method=";
        baseURL = [baseURL stringByAppendingString:methodName];
        NSLog(@"%@", baseURL);
        delegate = sender;
    }
    
    return self;
}

- (void)fetchData
{
    NSURL * url = [NSURL URLWithString:baseURL];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    [json appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(delegate)
        [delegate gotData:json];
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    if(delegate)
        [delegate connFailed:error];
}

@end