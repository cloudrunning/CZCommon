//
//  PopoverController.m
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/9.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import "PopoverController.h"
#import "HSPopover.h"
@interface PopoverController ()

@end

@implementation PopoverController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)leftAction:(id)sender {
    HSPopover *popover = [HSPopover new];
    popover.menuTitles = @[@"aa",@"bb",@"vv"];
    [popover showInView:sender selected:^(NSInteger index) {
        NSLog(@"%@",popover.menuTitles[index]);
    }];
}

- (IBAction)rightAction:(id)sender {
    
}

- (IBAction)nextAction:(id)sender {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


@end
