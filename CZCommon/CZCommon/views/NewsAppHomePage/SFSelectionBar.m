//
//  SFSelectionBar.m
//  ScanFloor
//
//  Created by caozhen@neusoft on 16/5/30.
//  Copyright © 2016年 neusoft. All rights reserved.
//

#import "SFSelectionBar.h"
#import <Masonry.h>

@interface SFSelectionBar ()
{
    UIScrollView *_tabBar;
    UIView       *_lineView;
    NSArray      *_widths;
}
@property (nonatomic,assign) NSInteger curIndex;
@property (nonatomic,strong) UIButton *curBtn;
@property (nonatomic,strong) NSMutableArray<UIButton *> *items;

@end
static const CGFloat halfSpacing = 15.0;
@implementation SFSelectionBar


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initSubViews];
    }
    return self;
}
- (void)initSubViews{
    _tabBar = [[UIScrollView alloc]initWithFrame:CGRectZero];
    _tabBar.backgroundColor = [UIColor clearColor];
    _tabBar.showsHorizontalScrollIndicator = NO;
    [self addSubview:_tabBar];
    
    [self masSubViews];
}

- (void)masSubViews{
    [_tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


- (NSMutableArray *)items{
    if (!_items) {
        _items = [[NSMutableArray alloc]init];
    }
    return _items;
}

- (void)reloadData{
     _widths = [self getButtonsWidthWithTitles:self.titles];
    if (_widths.count > 0) {
        CGFloat contentWidth = [self contentWidthAndAddTabBarItemsWithButtonsWidth:_widths];
        _tabBar.contentSize = CGSizeMake(contentWidth, 0);
    }

}
- (NSArray *)getButtonsWidthWithTitles:(NSArray *)titles{
    NSMutableArray *widths = [@[] mutableCopy];
    
    for (NSString *title in titles)
    {
        
        CGSize finalSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:NULL].size;
        
        NSNumber *width = [NSNumber numberWithFloat:finalSize.width];
        [widths addObject:width];
    }

    return widths;
}

- (CGFloat)contentWidthAndAddTabBarItemsWithButtonsWidth:(NSArray *)widths{

    CGFloat iterationX = 0;
    
    for (int i = 0; i < [widths count]; i ++)
    {
        CGFloat width = [widths[i] floatValue];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:self.titles[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];

        button.frame = CGRectMake(iterationX, 0,width + 2*halfSpacing, 44);
        
        //字体颜色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];        [button addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [_tabBar addSubview:button];
        [self.items addObject:button];
        iterationX += button.frame.size.width;
    }
    CGFloat firstItemWith = [widths[0] floatValue];
    
    [self showLineWithButtonWidth:firstItemWith halfSpacing:halfSpacing];
    return iterationX;

 
}
#pragma mark  下划线
- (void)showLineWithButtonWidth:(CGFloat)width  halfSpacing:(CGFloat)spacing
{
    //第一个线的位置
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(spacing, 45 - 3.0f, width, 2.0f)];
    _lineView.backgroundColor = self.lineColor;
    [_tabBar addSubview:_lineView];
    
    UIButton *btn = self.items[0];
    [self itemClick:btn];
}

- (void)itemClick:(UIButton *)button{
    if (!button.selected) {
        self.curBtn.selected = NO;
        button.selected = YES;
        self.curBtn = button;
        
        if (self.delegate) {
            [self.delegate itemDidSelectedAtIndex:[self.items indexOfObject:button]];
        }
    }
}



- (void)setCurIndex:(NSInteger)curIndex{
    _curIndex = curIndex;
    UIButton *button = self.items[curIndex];
    
    if (button.frame.origin.x + button.frame.size.width >= kScreenWidth)
    {
        CGFloat offsetX = button.frame.origin.x + button.frame.size.width - kScreenWidth;
        if (curIndex < [self.titles count]-1)
        {
            offsetX = offsetX + button.frame.size.width;
        }
        [_tabBar setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        
    }
    else
    {
        [_tabBar setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    //下划线的偏移量
    [UIView animateWithDuration:0.1f animations:^{
        _lineView.frame = CGRectMake(button.frame.origin.x + 15, _lineView.frame.origin.y, [_widths[curIndex] floatValue], _lineView.frame.size.height);
    }];
}

@end
