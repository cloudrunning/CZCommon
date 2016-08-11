//
//  NewsAppHomeController.m
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/11.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import "NewsAppHomeController.h"
#import "SFSelectionBar.h"
#import <Masonry.h>
#import "SocietyController.h"
@interface NewsAppHomeController ()<SFSelectionBarDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *referView;
@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) NSArray *subVcs;


@property (weak, nonatomic) IBOutlet UIView *referContentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,strong) SFSelectionBar *selectionbar;

@end

@implementation NewsAppHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SFSelectionBar *sectionBar = [[SFSelectionBar alloc]initWithFrame:CGRectZero];
    self.selectionbar = sectionBar;
    [self.referView addSubview:sectionBar];
    [sectionBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.referView);
    }];
    sectionBar.titles = self.titles;
    sectionBar.lineColor = kOrangeColor;
    sectionBar.delegate = self;
    [sectionBar reloadData];
    
    [self.referContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.titles.count * kScreenWidth);
    }];
    
  
//    self.navigationController.navigationBarHidden = YES;
}
- (NSArray *)titles{
    if (_titles) return _titles;
    _titles = @[@"特价酒店",@"景点门票",@"公寓",@"专车自驾",@"周边团购",@"全球购",@"换购",@"理财",@"金融"];
    return _titles;
}
- (NSArray *)subVcs {
    if (_subVcs) return _subVcs;
    NSMutableArray *subViewControllers = [NSMutableArray array];
    
    for (int i = 0; i<self.titles.count; i++) {
        SocietyController *society = [[SocietyController alloc]init];
        society.number = i + 1;
        [subViewControllers addObject:society];
    }
    _subVcs = subViewControllers;
    return _subVcs;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)itemDidSelectedAtIndex:(NSInteger)index {
    NSLog(@"click %@",self.titles[index]);
    self.scrollView.contentOffset = CGPointMake(index * kScreenWidth, 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger curIndex = scrollView.contentOffset.x / kScreenWidth;
    UIViewController *vc = self.subVcs[curIndex];
    vc.view.frame = CGRectMake(curIndex * kScreenWidth, 0, kScreenWidth, self.referContentView.bounds.size.height);
    [self.referContentView addSubview:vc.view];
    [self addChildViewController:vc];
    self.selectionbar.curIndex = curIndex;
}


@end
