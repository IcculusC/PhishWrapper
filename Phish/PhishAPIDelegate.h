//
//  PhishAPIDelegate.h
//  PhishWrapper
//
//  Created by llll on 3/3/13.
//  Copyright (c) 2013 llll. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PhishAPIDelegate <NSObject>

//@required
//- (void)gotData:(NSData *)dat method:(NSString *)method;

@required
- (void)gotData:(NSData *)dat;

@required
- (void)connFailed:(NSError *)err;

@end
