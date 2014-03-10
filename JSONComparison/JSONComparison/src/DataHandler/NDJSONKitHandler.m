//
//  NDJSONKitHandler.m
//  JSONComparison
//
//  Created by taehoon.jung on 2014. 3. 10..
//  Copyright (c) 2014년 NHN Technology Services. All rights reserved.
//

#import "NDJSONKitHandler.h"
#import "JSONKit.h"

@implementation NDJSONKitHandler

- (id)init
{
    self = [super init];
    if (self) {
        self.type = Parser_JSONKit;
    }
    return self;
}

- (void)parse
{
    NSAssert(self.rawData, @"The rawdata must be not nil.");
    
    [self startProcess];
    
    NSError *error = nil;
    
    self.parsedObject = [self.rawData objectFromJSONDataWithParseOptions:JKParseOptionNone
                                                                   error:&error];
    
    if (error) {
        NSLog(@"error occurred: %@", error);
    }
    
    [self endProcess];
    [self postProcess];
}

@end
