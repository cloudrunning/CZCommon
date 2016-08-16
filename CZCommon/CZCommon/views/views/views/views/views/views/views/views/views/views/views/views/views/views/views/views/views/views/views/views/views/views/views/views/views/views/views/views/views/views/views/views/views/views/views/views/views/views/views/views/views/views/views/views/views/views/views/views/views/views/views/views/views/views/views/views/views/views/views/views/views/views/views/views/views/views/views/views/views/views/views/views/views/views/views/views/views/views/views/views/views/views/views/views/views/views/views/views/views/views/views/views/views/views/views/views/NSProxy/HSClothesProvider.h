//
//  HSClothesProvider.h
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/10.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,HSClothesSize) {
    HSClothesSizeSmall = 0,
    HSClothesSizeMedium,
    HSClothesSizeLarge,
};

@protocol HSClothesProviderProtocol <NSObject>

- (void)purchaseClothesWithSize:(HSClothesSize)size;

@end


@interface HSClothesProvider : NSObject

@end
