//
//  Parser.m
//  JSONComparison
//
//  Created by taehoon.jung on 2014. 3. 10..
//  Copyright (c) 2014년 NHN Technology Services. All rights reserved.
//

#import "Parser.h"
#import "NDCommonDefines.h"

@interface Parser ()

@end

@implementation Parser

@synthesize type = _type;
@synthesize name = _name;
@synthesize results = _results;
@synthesize finished = _finished;

@synthesize lineColor = _lineColor;
@synthesize max = _max;
@synthesize min = _min;

- (id)init
{
    self = [super init];
    return self;
}

- (id)initWithType:(ParserType)type name:(NSString *)name lineColor:(UIColor *)lineColor
{
    self = [self init];
    if (self) {
        self.type = type;
        self.name = name;
        _results = [NSMutableArray array];
        self.lineColor = lineColor;
    }
    return self;
}

- (void)dealloc
{
    self.lineColor = nil;
    self.name = nil;
    _results = nil;
}


#pragma mark - setter

- (void)setMax:(double)max
{
    if (_max < max) {
        _max = max;
    }
}

- (void)setMin:(double)min
{
    if (_min == 0 || _min > min) {
        _min = min;
    }
}

#pragma mark -

- (void)reset
{
    [_results removeAllObjects];
    
    _max = 0;
    _min = 0;
    _finished = NO;
}

- (void)addResultObject:(NSDictionary *)item
{
    if (!_results) {
        _results = [NSMutableArray array];
    }
    
    [_results addObject:item];
    
    NSNumber *time = item[@"time"];
    [self setMin:time.doubleValue];
    [self setMax:time.doubleValue];
}

- (NSString *)average
{
    if (!self.results || self.results.count == 0) {
        return @"0.0";
    }
    
    double sum = 0;
    
    for (NSDictionary *item in self.results) {
        NSNumber *time = item[@"time"];
        sum += time.doubleValue;
    }
    
    double avg = sum/self.results.count;
    
    return [NSString stringWithFormat:@"%d/%d %.3f", self.results.count, COUNT_OF_SAMPLING, avg];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"type: %@\naverage: %@\n\nresults: %@", self.name, [self average], self.results];
}

@end
