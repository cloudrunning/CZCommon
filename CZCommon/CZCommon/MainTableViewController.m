//
//  MainTableViewController.m
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/9.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import "MainTableViewController.h"

#import "PopoverController.h"

@interface MainTableViewController ()
@property (nonatomic,strong) NSArray *listTitles;


@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
 
}

- (NSArray *)listTitles{
    if (_listTitles) return _listTitles;
    _listTitles = @[@"PopoverView"];
    return _listTitles;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listTitles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainTableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.listTitles[indexPath.row];
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PopoverController *popoverVC =  [storyBoard instantiateViewControllerWithIdentifier:@"PopoverController"];
        [self.navigationController pushViewController:popoverVC animated:YES];
    }
    
    
    
}

#pragma mark ---- StoryBoard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

@end
