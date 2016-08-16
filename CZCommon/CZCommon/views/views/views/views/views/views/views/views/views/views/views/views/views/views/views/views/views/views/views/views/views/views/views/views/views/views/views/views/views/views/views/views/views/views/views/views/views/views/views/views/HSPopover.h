//
//  HSPopover.h
//  Popover
//
//  Created by caozhen@neusoft on 16/8/8.
//  Copyright © 2016年 lifution. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^HSPopoverBlock)(NSInteger index);

@interface HSPopover : UIView

@property (nonatomic,copy) NSArray *menuTitles;

- (void)showInView:(UIView *)aView selected:(HSPopoverBlock)block;

@end



@interface HSPopoverArrow : UIView

@end