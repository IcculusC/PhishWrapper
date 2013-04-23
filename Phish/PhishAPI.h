//
//  PhishAPI.h
//  PhishWrapper
//
//  Created by llll on 2/21/13.
//  Copyright (c) 2013 llll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhishAPIDelegate.h"

@interface PhishAPI : NSObject
{
    NSURLConnection *connection;
    id <PhishAPIDelegate> delegate;
    NSMutableData * json;
    NSString * method;
}

- (id)initWithMethod:(NSString *)method arguments:(NSString *)args keyed:(BOOL)keyed sender:(id)sender;

- (void)fetchData;

@property (retain) id delegate;
@property (nonatomic, copy) NSString * baseURL;

@end
