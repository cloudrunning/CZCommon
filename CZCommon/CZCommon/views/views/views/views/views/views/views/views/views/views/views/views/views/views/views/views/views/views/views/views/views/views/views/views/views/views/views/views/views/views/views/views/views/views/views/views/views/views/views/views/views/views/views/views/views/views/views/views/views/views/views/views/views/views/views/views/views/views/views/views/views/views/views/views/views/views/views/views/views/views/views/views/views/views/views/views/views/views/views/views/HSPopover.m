//
//  HSPopover.m
//  Popover
//
//  Created by caozhen@neusoft on 16/8/8.
//  Copyright © 2016年 lifution. All rights reserved.
//

#import "HSPopover.h"
#define kPopoverFontSize 14.f
#define HSColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kHSBorderColor HSColorFromRGB(0xE1E2E3)

#define kHSSCREENWIDTH [UIScreen mainScreen].bounds.size.width

#define kHSArrowH 8
#define kHSArrowW 15
@interface HSPopover () <UITableViewDataSource,UITableViewDelegate> {
    HSPopoverBlock _popoverBlock;
    UIView *_backgroudView;
    HSPopoverArrow *_arrowView;
    
}

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation HSPopover

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        // 箭头
        _arrowView = [HSPopoverArrow new];
        [self addSubview:_arrowView];
        // tableview 放在箭头下面
        [self insertSubview:self.tableView belowSubview:_arrowView];
        
    }
    return self;
}

- (UITableView *)tableView{
    if (_tableView) return _tableView;
    _tableView = [UITableView new];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight       = 38;
    _tableView.separatorColor  = HSColorFromRGB(0xE1E2E3);
    _tableView.scrollEnabled   = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.showsVerticalScrollIndicator = NO;
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"kPopoverCellIdentifier"];
    _tableView.tableFooterView = UIView.new;
    
    return _tableView;
}

- (void)showInView:(UIView *)aView selected:(HSPopoverBlock)block {
    if (block) {
        _popoverBlock = block;
    }
    
    UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
    
    // backgourdView;
    _backgroudView = [UIView new];
    _backgroudView.frame = keyWindow.bounds;
    _backgroudView.backgroundColor = [UIColor clearColor];
    _backgroudView.userInteractionEnabled = YES;
    [_backgroudView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)]];
    [keyWindow addSubview:_backgroudView];
    
    
    [self.tableView reloadData];
    
    
    CGRect triggerRect = [aView convertRect:aView.bounds toView:keyWindow];
    
    CGFloat arrowCeterX = CGRectGetMaxX(triggerRect) - CGRectGetWidth(triggerRect) * 0.5;
    
    CGFloat maxWith = 0;
    for (NSString *title  in self.menuTitles) {
        if ([title isKindOfClass:[NSString class]]) {
            CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kPopoverFontSize]}];
            if (titleSize.width > maxWith) {
                maxWith = titleSize.width;
            }
        }
    }
    
    CGFloat finalWith = MIN((maxWith + 40), (kHSSCREENWIDTH-30));
    CGFloat finalHeight = kHSArrowH + self.tableView.contentSize.height;
    CGFloat finalX = arrowCeterX - finalWith * 0.5;
    CGFloat finalY = CGRectGetMaxY(triggerRect) + 10;
    
    //调整弹出框位置:规则是：保证(箭头centerX与屏幕的距离 + 5) > (finalWith * 0.5)
    //左
    if (arrowCeterX + 5 < finalWith * 0.5) {
        CGFloat toRightAjust = finalWith * 0.5- arrowCeterX + 5;
        finalX += toRightAjust;
    }
     //右
    if (kHSSCREENWIDTH - arrowCeterX -5 < finalWith * 0.5) {
        CGFloat toleftAjust = finalWith * 0.5 - (kHSSCREENWIDTH - arrowCeterX - 5);
        finalX -= toleftAjust;
    }
    _arrowView.frame = CGRectMake(arrowCeterX - finalX - kHSArrowW *0.5, 0, kHSArrowW, kHSArrowH);
    self.tableView.frame = CGRectMake(0, kHSArrowH, finalWith, self.tableView.contentSize.height);
    
    self.frame = CGRectMake(finalX, finalY, finalWith, finalHeight);
    
    [keyWindow addSubview:self];
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
    
}


#pragma mark ---- UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuTitles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kPopoverCellIdentifier"];
    cell.textLabel.font = [UIFont systemFontOfSize:kPopoverFontSize];
    cell.textLabel.text = self.menuTitles[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [_backgroudView removeFromSuperview];
        _backgroudView = nil;
        if (_popoverBlock) {
            _popoverBlock(indexPath.row);
        }
        [self removeFromSuperview];
    }];
}
#pragma mark ---- privite
- (void)hide {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [_backgroudView removeFromSuperview];
        _backgroudView = nil;
        [self removeFromSuperview];
    }];
    
}

@end


@implementation HSPopoverArrow
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
    
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGSize curSize = rect.size;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, curSize.height);
    CGContextMoveToPoint(context, curSize.width * 0.5, 0);
    CGContextMoveToPoint(context, curSize.width, curSize.height);
    
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
}
@end






















