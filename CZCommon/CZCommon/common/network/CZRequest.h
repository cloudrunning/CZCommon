//
//  WDAdvRequest.h
//  NBBS
//
//  Created by caozhen@neusoft on 16/7/12.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CZRequestSuccess)(id data);
typedef void(^CZRequestFail)(int status,NSString *message);

@interface CZRequest : NSObject

- (void)postWithURL:(NSURL *)URL params:(NSDictionary *)params suc:(CZRequestSuccess)suc fail:(CZRequestFail)fail;

- (void)getWithURL:(NSURL *)URL suc:(CZRequestSuccess)suc fail:(CZRequestFail)fail;

@end
