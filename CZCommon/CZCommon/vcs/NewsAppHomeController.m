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
@interface NewsAppHomeController ()<SFSelectionBarDelegate>
@property (weak, nonatomic) IBOutlet UIView *referView;
@property (nonatomic,strong) NSArray *titles;

@end

@implementation NewsAppHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SFSelectionBar *sectionBar = [[SFSelectionBar alloc]initWithFrame:CGRectZero];
    [self.referView addSubview:sectionBar];
    [sectionBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.referView);
    }];
    sectionBar.titles = self.titles;
    sectionBar.lineColor = kOrangeColor;
    sectionBar.delegate = self;
    [sectionBar reloadData];
}
- (NSArray *)titles{
    if (_titles) return _titles;
    _titles = @[@"特价酒店",@"景点门票",@"公寓",@"专车自驾",@"周边团购",@"全球购",@"换购",@"理财",@"金融"];
    return _titles;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)itemDidSelectedAtIndex:(NSInteger)index {
    NSLog(@"click %@",self.titles[index]);
    
}


@end
