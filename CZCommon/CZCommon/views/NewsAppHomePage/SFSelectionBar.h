//
//  SFSelectionBar.h
//  ScanFloor
//
//  Created by caozhen@neusoft on 16/5/30.
//  Copyright © 2016年 neusoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SFSelectionBarDelegate <NSObject>

- (void)itemDidSelectedAtIndex:(NSInteger)index;

@end

@interface SFSelectionBar : UIView

@property (nonatomic,weak)   id<SFSelectionBarDelegate> delegate;

@property (nonatomic,strong) NSArray *titles;

@property (nonatomic,strong) UIColor *lineColor;


- (void)reloadData;


@end
