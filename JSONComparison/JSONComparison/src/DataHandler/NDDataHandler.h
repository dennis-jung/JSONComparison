//
//  NDDataHandler.h
//  JSONComparison
//
//  Created by taehoon.jung on 2014. 3. 7..
//  Copyright (c) 2014년 NHN Technology Services. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NDCommonDefines.h"

@interface NDDataHandler : NSObject

@property (nonatomic, assign) ParserType type;
@property (nonatomic, strong) NSData *rawData;
@property (nonatomic, strong) id parsedObject;

+ (NDDataHandler *)createDataHandler:(ParserType)type withRawData:(NSData *)rawData;

- (id)initWithData:(NSData *)data;

- (void)parse;

- (void)startProcess;
- (void)endProcess;

- (void)postProcess;

- (double)turnaroundTime;

@end
