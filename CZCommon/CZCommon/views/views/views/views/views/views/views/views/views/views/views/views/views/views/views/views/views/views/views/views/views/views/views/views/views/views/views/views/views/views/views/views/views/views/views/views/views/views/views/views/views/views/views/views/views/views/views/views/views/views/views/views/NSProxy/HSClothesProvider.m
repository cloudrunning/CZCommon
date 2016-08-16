//
//  HSClothesProvider.m
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/10.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import "HSClothesProvider.h"

@implementation HSClothesProvider
- (void)purchaseClothesWithSize:(HSClothesSize)size {
    NSString *sizeStr = nil;
    switch (size) {
        case HSClothesSizeSmall: {
            sizeStr = @"small size";
            break;
        }
        case HSClothesSizeMedium: {
            sizeStr = @"medium size";
            break;
        }
        case HSClothesSizeLarge: {
            sizeStr = @"large size";
            break;
        }
    }
    NSLog(@"You have purchased some clothes of %@",sizeStr);
}
@end
