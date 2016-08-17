//
//  RevealAnimController.m
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/17.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import "RevealAnimController.h"
#import "RevealAnimDetailController.h"
#import "HSRevealAnimation.h"

@interface RevealAnimController () <UINavigationControllerDelegate>
@property (nonatomic,strong) HSRevealAnimation *revealAnimation;

@end

@implementation RevealAnimController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.revealAnimation = [HSRevealAnimation new];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.logo = [HSLogoLayer logoLayer];
    self.logo.position = self.view.center;
    self.logo.fillColor = [[UIColor whiteColor] CGColor];
    [self.view.layer addSublayer:self.logo];
}

- (void)tapAction {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.navigationController.delegate = self;

    RevealAnimDetailController *revealDetailVC = [story instantiateViewControllerWithIdentifier:@"RevealAnimDetailController"];
    [self.navigationController pushViewController:revealDetailVC animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                animationControllerForOperation:(UINavigationControllerOperation)operation
                fromViewController:(UIViewController *)fromVC
                toViewController:(UIViewController *)toVC
{
    self.revealAnimation.operation = UINavigationControllerOperationPush;
    return self.revealAnimation;

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
