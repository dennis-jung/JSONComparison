//
//  NDDataHandler.m
//  JSONComparison
//
//  Created by taehoon.jung on 2014. 3. 7..
//  Copyright (c) 2014년 NHN Technology Services. All rights reserved.
//

#import "NDDataHandler.h"

#import "NDJSONKitHandler.h"
#import "NDJSONSerializationHandler.h"

@interface NDDataHandler ()

@property (nonatomic, assign) NSTimeInterval startTimeInterval;
@property (nonatomic, assign) NSTimeInterval endTimeInterval;

@end

@implementation NDDataHandler

@synthesize rawData, startTimeInterval, endTimeInterval, parsedObject;


+ (NDDataHandler *)createDataHandler:(ParserType)type withRawData:(NSData *)rawData
{
    switch (type) {
        case Parser_DEFAULT:
            return [[NDJSONSerializationHandler alloc] initWithData:rawData];
            break;
            
        case Parser_JSONKit:
            return [[NDJSONKitHandler alloc] initWithData:rawData];
            break;
            
        default:
            break;
    }
    
    return nil;
}

- (id)initWithData:(NSData *)data
{
    NSParameterAssert(data);
    
    self = [self init];
    if (self) {
        self.rawData = data;
    }
    
    return self;
}

- (void)dealloc
{
    self.rawData = nil;
}


#pragma mark - 

- (void)parse
{
    
}


- (void)startProcess
{
    self.endTimeInterval = 0;
    self.startTimeInterval = [[NSDate date] timeIntervalSince1970];
}

- (void)endProcess
{
    self.endTimeInterval = [[NSDate date] timeIntervalSince1970];
}

- (void)postProcess
{
    [self print];
}

- (double)turnaroundTime
{
    if (self.startTimeInterval <= 0 || self.endTimeInterval <= 0) {
        return 0.0;
    }
    
    NSTimeInterval gap = self.endTimeInterval - self.startTimeInterval;
    return gap;
}

- (void)print
{
    NSLog(@"type :%d - %.2f", self.type, [self turnaroundTime]);
}

@end
