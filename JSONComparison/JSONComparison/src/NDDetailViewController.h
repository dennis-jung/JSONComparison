//
//  NDDetailViewController.h
//  JSONComparison
//
//  Created by taehoon.jung on 2014. 3. 7..
//  Copyright (c) 2014년 NHN Technology Services. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parser.h"

@interface NDDetailViewController : UIViewController

@property (strong, nonatomic) Parser *detailItem;

@property (weak, nonatomic) IBOutlet UITextView *detailDescriptionTextView;
@end
