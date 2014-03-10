//
//  NDChartViewController.h
//  JSONComparison
//
//  Created by taehoon.jung on 2014. 3. 10..
//  Copyright (c) 2014년 NHN Technology Services. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCLineChartView.h"

@interface NDChartViewController : UIViewController

@property (nonatomic, strong) NSArray *objects;

@property (nonatomic, strong) IBOutlet LCLineChartView *lineChartView;

@end
