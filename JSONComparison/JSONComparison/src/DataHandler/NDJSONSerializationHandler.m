//
//  NDJSONSerializationHandler.m
//  JSONComparison
//
//  Created by taehoon.jung on 2014. 3. 7..
//  Copyright (c) 2014년 NHN Technology Services. All rights reserved.
//

#import "NDJSONSerializationHandler.h"

@implementation NDJSONSerializationHandler

- (id)init
{
    self = [super init];
    if (self) {
        self.type = Parser_DEFAULT;
    }
    return self;
}

- (void)parse
{
    NSAssert(self.rawData, @"The rawdata must be not nil.");
    
    [self startProcess];
    
    NSError *error = nil;
    self.parsedObject = [NSJSONSerialization JSONObjectWithData:self.rawData
                                                        options:kNilOptions
                                                          error:&error];
    
    if (error) {
        NSLog(@"error occurred: %@", error);
    }
    
    [self endProcess];
    [self postProcess];
}

@end
