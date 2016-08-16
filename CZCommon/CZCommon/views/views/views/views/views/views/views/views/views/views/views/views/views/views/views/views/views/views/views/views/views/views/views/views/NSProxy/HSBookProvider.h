//
//  HSBookProvider.h
//  CZCommon
//
//  Created by caozhen@neusoft on 16/8/10.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol HSBookProviderProtocol

- (void)purchaseBookWithTitle:(NSString *)bookTitle;

@end


@interface HSBookProvider : NSObject

@end
