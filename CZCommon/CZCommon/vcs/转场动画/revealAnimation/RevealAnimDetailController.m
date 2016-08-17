//
//  RevealAnimDetailController.m
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/17.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import "RevealAnimDetailController.h"
#import "HSLogoLayer.h"
@interface RevealAnimDetailController ()

@end

@implementation RevealAnimDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.maskLayer = [HSLogoLayer logoLayer];
    self.maskLayer.position = self.view.center;
    self.view.layer.mask = self.maskLayer;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    self.view.layer.mask = nil;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
