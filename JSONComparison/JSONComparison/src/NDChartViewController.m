//
//  NDChartViewController.m
//  JSONComparison
//
//  Created by taehoon.jung on 2014. 3. 10..
//  Copyright (c) 2014년 NHN Technology Services. All rights reserved.
//

#import "NDChartViewController.h"
#import "Parser.h"

@interface NDChartViewController ()

@end

@implementation NDChartViewController

@synthesize objects = _objects;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Chart";
    [self drawChart:self.objects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (float)minInObjects:(NSArray *)objects
{
    NSParameterAssert(objects);
    NSParameterAssert(objects.count > 0);
    
    float min = 0;
    for (Parser *parserItem in objects) {
        if (min == 0 || min > parserItem.min) {
            min = parserItem.min;
        }
    }
    
    return min;
}

- (float)maxInObjects:(NSArray *)objects
{
    NSParameterAssert(objects);
    NSParameterAssert(objects.count > 0);
    
    float max = 0;
    for (Parser *parserItem in objects) {
        if (max == 0 || max < parserItem.max) {
            max = parserItem.max;
        }
    }
    
    return max;
}

- (void)drawChart:(NSArray *)objects
{
    NSParameterAssert(objects);
    NSParameterAssert(objects.count > 0);
    
    NSMutableArray *chartData = [NSMutableArray arrayWithCapacity:objects.count];
    
    for (Parser *parserItem in objects) {
        
        LCLineChartData *d = [LCLineChartData new];
        d.xMin = 0;
        d.xMax = parserItem.results.count;
        d.title = parserItem.name;
        d.color = parserItem.lineColor;
        d.itemCount = parserItem.results.count;

        [parserItem.results sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1[@"idx"] compare:obj2[@"idx"]];
        }];
        
        d.getData = ^(NSUInteger idx) {
            NSDictionary *resultItem = parserItem.results[idx];

            double x = idx;
            double y = [resultItem[@"time"] doubleValue];
            NSString *label1 = [NSString stringWithFormat:@"%d %@", idx, parserItem.name];
            NSString *label2 = [NSString stringWithFormat:@"%f", y];
            return [LCLineChartDataItem dataItemWithX:x y:y xLabel:label1 dataLabel:label2];
        };
        
        [chartData addObject:d];
    }
    
    self.lineChartView.yMin = [self minInObjects:objects] - .3;
    self.lineChartView.yMax = [self maxInObjects:objects] + .3;
    self.lineChartView.ySteps = @[@"0.0",
                         [NSString stringWithFormat:@"%.02f", self.lineChartView.yMax / 2],
                         [NSString stringWithFormat:@"%.02f", self.lineChartView.yMax]];

    self.lineChartView.data = chartData;
}

@end
