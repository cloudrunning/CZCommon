//
//  HSDealerProxy.h
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/10.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSClothesProvider.h"
#import "HSBookProvider.h"

@interface HSDealerProxy : NSProxy <HSBookProviderProtocol,HSClothesProviderProtocol>

+ (instancetype)dealerProxy;
@end
