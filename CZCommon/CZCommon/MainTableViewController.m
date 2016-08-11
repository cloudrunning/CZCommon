//
//  MainTableViewController.m
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/9.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import "MainTableViewController.h"

#import "PopoverController.h"
#import "HSDealerProxy.h"
#import "RuntimeController.h"
#import "NewsAppHomeController.h"


@interface MainTableViewController ()
@property (nonatomic,strong) NSArray *listTitles;


@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
 
}

- (NSArray *)listTitles{
    if (_listTitles) return _listTitles;
    _listTitles = @[@"PopoverView",@"NSProxy",@"Runtime",@"NewsAppHome"];
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
     UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (indexPath.row == 0) {
        PopoverController *popoverVC =  [storyBoard instantiateViewControllerWithIdentifier:@"PopoverController"];
        [self.navigationController pushViewController:popoverVC animated:YES];
    } else if (indexPath.row == 1) {
    
        HSDealerProxy *dealerProxy = [HSDealerProxy dealerProxy];
        [dealerProxy purchaseBookWithTitle:@"Swift 100 Tips"];
        [dealerProxy purchaseClothesWithSize:HSClothesSizeMedium];
    } else if (indexPath.row == 2)  {
        
       RuntimeController *runtimeVC = [storyBoard instantiateViewControllerWithIdentifier:@"RuntimeController"];
        [self.navigationController pushViewController:runtimeVC animated:YES];
    } else if (indexPath.row == 3){
        NewsAppHomeController *newsVC = [storyBoard instantiateViewControllerWithIdentifier:@"NewsAppHomeController"];
        [UIApplication sharedApplication].keyWindow.rootViewController = newsVC;
    }
    
    
    
}

#pragma mark ---- StoryBoard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

@end
