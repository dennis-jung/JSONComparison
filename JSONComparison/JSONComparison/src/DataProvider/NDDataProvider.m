//
//  NDDataProvider.m
//  JSONComparison
//
//  Created by taehoon.jung on 2014. 3. 7..
//  Copyright (c) 2014년 NHN Technology Services. All rights reserved.
//

#import "NDDataProvider.h"
#import "Parser.h"

NSString *NDDataProviderException = @"NDDataProviderException";

@implementation NDDataProvider

+ (NSData *)dummyJSONData
{
    NSString *dummyPath = [[NSBundle mainBundle] pathForResource:@"dummy" ofType:@"json" inDirectory:nil];
    
    NSError *error = nil;
    NSData *jsonData = [NSData dataWithContentsOfFile:dummyPath
                                              options:NSDataReadingMappedIfSafe
                                                error:&error];
    
    if (error) {
        NSLog(@"load json error occurred: %@", error);
        
        @throw [NSException exceptionWithName:NDDataProviderException
                                       reason:[NSString stringWithFormat:@"load error from %@", dummyPath]
                                     userInfo:@{@"error": error}];
    }
    
    return jsonData;
}

+ (NSArray *)listOfTypes
{
    return @[
             [[Parser alloc] initWithType:Parser_DEFAULT name:@"NSJSONSerialization" lineColor:[UIColor greenColor]],
             [[Parser alloc] initWithType:Parser_JSONKit name:@"JSONKit" lineColor:[UIColor redColor]]
             ];
}

@end
