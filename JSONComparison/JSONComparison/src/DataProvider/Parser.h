//
//  Parser.h
//  JSONComparison
//
//  Created by taehoon.jung on 2014. 3. 10..
//  Copyright (c) 2014년 NHN Technology Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NDCommonDefines.h"

@interface Parser : NSObject

@property (nonatomic, assign) ParserType type;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) BOOL finished;

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) double min;
@property (nonatomic, assign) double max;

@property (nonatomic, readonly) NSMutableArray *results;

- (id)initWithType:(ParserType)type name:(NSString *)name lineColor:(UIColor *)lineColor;


- (void)reset;
- (void)addResultObject:(NSDictionary *)item;

- (NSString *)average;

@end
