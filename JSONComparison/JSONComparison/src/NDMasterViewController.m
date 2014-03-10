//
//  NDMasterViewController.m
//  JSONComparison
//
//  Created by taehoon.jung on 2014. 3. 7..
//  Copyright (c) 2014년 NHN Technology Services. All rights reserved.
//

#import "NDMasterViewController.h"

#import "NDDetailViewController.h"
#import "NDChartViewController.h"

#import "NDJSONKitHandler.h"
#import "NDJSONSerializationHandler.h"

#import "NDDataProvider.h"
#import "Parser.h"


@interface NDMasterViewController () {
    NSMutableArray *_objects;
}

@end


@implementation NDMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *chartButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showChart:)];
    self.navigationItem.leftBarButtonItem = chartButton;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(start:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    _objects = [NSMutableArray arrayWithArray:[NDDataProvider listOfTypes]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reset
{
    for (Parser *item in _objects) {
        if ([item isKindOfClass:[Parser class]] == NO) {
            continue;
        }
        
        [item reset];
    }
    
    [self.tableView reloadData];
}


#pragma mark - testing 

- (BOOL)isFinished:(NSArray *)list
{
    __block BOOL finished = YES;
    dispatch_apply(list.count, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t idx) {
        Parser *item = [list objectAtIndex:idx];
        if (item.finished == NO) {
            finished = NO;
        }
    });
    return finished;
}


- (void)showChart:(id)sender
{
    if ([self isFinished:_objects] == NO) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"작업이 완료되지 않았습니다."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    NDChartViewController *viewController = [[NDChartViewController alloc] initWithNibName:@"NDChartViewController" bundle:nil];
    viewController.objects = _objects;
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)start:(id)sender
{
    [self reset];
    
    NSData *jsonRawData = [NDDataProvider dummyJSONData];
    
    NDDataHandler *jsonSerializationHandler = [NDDataHandler createDataHandler:Parser_DEFAULT withRawData:jsonRawData];
    NDDataHandler *jsonkitHandler = [NDDataHandler createDataHandler:Parser_JSONKit withRawData:jsonRawData];
    
    [self performParsing:jsonSerializationHandler];
    [self performParsing:jsonkitHandler];
}

static dispatch_queue_t json_processing_queue() {
    static dispatch_queue_t json_processing_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        json_processing_queue = dispatch_queue_create("com.nhncorp.json.processing", DISPATCH_QUEUE_SERIAL);
    });
    
    return json_processing_queue;
}

- (void)performParsing:(NDDataHandler *)handler
{
    dispatch_async(json_processing_queue(), ^{

        for (int i=0; i<COUNT_OF_SAMPLING; i++) {
            [handler parse];
            
            NSDictionary *result = @{@"index": @(i),
                                     @"time": @(handler.turnaroundTime)};
            
            dispatch_async(dispatch_get_main_queue(), ^{
                Parser *parser = [_objects objectAtIndex:handler.type];
                [parser addResultObject:result];
                
                if (i+1 == COUNT_OF_SAMPLING) {
                    parser.finished = YES;
                }
                
                [self.tableView reloadData];
            });
        }
    });
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    Parser *item = _objects[indexPath.row];
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = item.average;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Parser *selectedItem = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:selectedItem];
    }
}

@end
