//
//  WDAdvRequest.m
//  NBBS
//
//  Created by caozhen@neusoft on 16/7/12.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import "CZRequest.h"

#if DEBUG
#define CZLog(s,...) NSLog(@"\n[%@ in line %d]\n%@",[[NSString stringWithUTF8String:__FILE__] lastPathComponent],__LINE__,[NSString stringWithFormat:(s),##__VA_ARGS__])
#else
#define CZLog(s,...) nil
#endif

@interface CZRequest () <NSURLConnectionDelegate>{
    CZRequestSuccess sucHandler;
    CZRequestFail failHandler;
}

@property (nonatomic,strong) NSMutableData *mResponseData;

@end

static float kTimeout = 10.0;
@implementation CZRequest
- (void)postWithURL:(NSURL *)URL params:(NSDictionary *)params suc:(CZRequestSuccess)suc fail:(CZRequestFail)fail {

    sucHandler = [suc copy];
    failHandler = [fail copy];
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:URL];
    urlRequest.timeoutInterval = kTimeout;
    [urlRequest setHTTPMethod:@"POST"];
    if (params && params.allKeys.count>0) {
        NSMutableArray *arrParams = [NSMutableArray array];
        for (NSString *key in params.allKeys) {
            NSString *s = [NSString stringWithFormat:@"%@=%@",key,params[key]?params[key]:@""];
            [arrParams addObject:s];
        }
        NSString *paramsString = [arrParams componentsJoinedByString:@"&"];
        [urlRequest setHTTPBody:[paramsString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
  
        BOOL isSuccess = NO;
        NSDictionary *dict = nil;
        if (!error) {
            dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (dict) {
                isSuccess = YES;
            }
            
        }else{
            failHandler((int)error.code,error.localizedDescription);
        }
        if (isSuccess) {
            [self logSuccess:data url:URL.absoluteString params:params];
        }else{
            [self logFail:error url:URL.absoluteString params:params];
        }
        //FIXME!
        if(isSuccess) {
            int status = [[dict objectForKey:@"status"] intValue];
            if (status == 200) {
                id data = dict[@"data"];
                if (sucHandler && data) {
                    sucHandler(data);
                }else if(failHandler){
                    failHandler(status,dict[@"message"]);
                }
            }else{
                if (failHandler) {
                    failHandler(status,dict[@"message"]);
                }
            }
        }else{
            if (failHandler) {
                failHandler(-1,@"数据格式有误!");
            }
        }

       
    }];
    [dataTask resume];

}

- (void)getWithURL:(NSURL *)URL suc:(CZRequestSuccess)suc fail:(CZRequestFail)fail {
    
    sucHandler = [suc copy];
    failHandler = [fail copy];
  
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:URL];
    [urlRequest setHTTPMethod:@"GET"];
    urlRequest.timeoutInterval = kTimeout;
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        BOOL isSuccess = NO;
        NSDictionary *dict = nil;
        if (!error) {
            dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (dict) {
                isSuccess = YES;
            }
        }else{
            failHandler((int)error.code,error.localizedDescription);
        }
        
        if (isSuccess) {
            [self logSuccess:data url:URL.absoluteString params:nil];
        }else{
            [self logFail:error url:URL.absoluteString params:nil];
        }
        //FIXME!
        if (isSuccess) {
            int status = [[dict objectForKey:@"status"] intValue];
            if (status == 200) {
                id data = dict[@"data"];
                if (sucHandler && data) {
                    sucHandler(data);
                }else if(failHandler){
                    failHandler(status,dict[@"message"]);
                }
            }else{
                if (failHandler) {
                    failHandler(status,dict[@"message"]);
                }
            }

        }else{
            if (failHandler) {
                failHandler(-1,@"数据格式有误!");
            }
        }
        
       
    }];
    [dataTask resume];

}

#pragma mark ---- 输出请求信息
- (void)logSuccess:(NSData *)data url:(NSString *)url params:(NSDictionary *)params {
    
    NSDictionary *dict = nil;
    dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSString *successMsg = @"";
    if (dict) {
        successMsg = @"Request success!";
    }else{
        successMsg = @"Request success,but json serialize failed!";
    }
    CZLog(@"\n#########################################################\n%@\nurl:%@\nparams:%@\nresponseData:%@",successMsg,url,params,dict);
    
}
- (void)logFail:(NSError *)error url:(NSString *)url params:(NSDictionary *)params {
    
        CZLog(@"\n????????????????????????????????????????????????\nRequest fail!\nurl:%@\nparams:%@\nerror message:%@",url,params,[error localizedDescription]);
}
@end

