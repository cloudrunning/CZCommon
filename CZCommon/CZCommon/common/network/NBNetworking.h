//
//  NBNetworking.h
//  AFNetworkingDemo
//
//  Created by caozhen on 16/5/20.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef DEBUG
#define NBLog(s, ...) NSLog(@"\n[%@ in line %d] \n%@",[[NSString stringWithUTF8String:__FILE__] lastPathComponent],__LINE__,[NSString stringWithFormat:(s),##__VA_ARGS__])

#else
#define NBLog(s, ... )

#endif



typedef NSURLSessionTask NBURLSessionTask;
typedef void (^NBResponseSuccess)(id responseData) ;
typedef void (^NBResponseFail)(NSError *error) ;

//上传和下载进度
typedef void (^NBDownloadProgress)(int64_t bytesRead,int64_t totalBytesRead);
typedef NBDownloadProgress NBGetProgress;
typedef NBDownloadProgress NBPostProgress;
typedef void(^NBUploadProgress)(int64_t bytesWriten,int64_t totalBytesWiriten);


// 请求方法,响应,格式
typedef NS_ENUM(NSUInteger,NBHttpMethod){
    kNBHttpMethodGet  = 1,
    kNBHttpMethodPost = 2,
};

typedef NS_ENUM(NSUInteger,NBRequestType) {
    kNBRequestTypeJSON,
    kNBRequestTypePlainText,//text/html

};

typedef NS_ENUM(NSUInteger,NBResponseType) {
    kNBResponseTypeJSON = 1,
    kNBResponseTypeXML  = 2,
    kNBResponseTypeData = 3,
};

//网络状态
typedef NS_ENUM(NSInteger,NBNetworkStatus) {
    kNBNetworkStatusUnknown,
    kNBNetworkStatusNotReachable,
    kNBNetworkStatusReachableViaWWAN,
    KNBNetworkStatusReachableViaWiFi,
};



@interface NBNetworking : NSObject
#pragma mark -- 基地址

+ (void)updateBaseUrl:(NSString *)baseUrl;
+ (NSString *)baseUrl;

#pragma mark -- 基本配置

+ (void)setTimeout:(NSTimeInterval)timeout;
+ (void)obtainDataFromLocalWhenNetworkUnconnected:(BOOL)shouldObtain;
+ (void)cacheGetRequest:(BOOL)isCacheGet shoulCachePost:(BOOL)shouldCachePost;
+ (void)enableInterfaceDebug:(BOOL)isDebug;
+ (void)configRequestType:(NBRequestType)requestType
             responseType:(NBResponseType)responseType
      shouldAutoEncodeUrl:(BOOL)shouldAutoEncode
  callbackOnCancelRequest:(BOOL)shouldCallbackOnCancelRequest;
+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders;
+ (void)configCommonHttpHeaders;

# pragma mark -- 清理缓存
+ (unsigned long long)totalCacheSize;
+ (void)clearCaches;


#pragma mark  -- 暂停操作
+ (void)cancelAllRequest;
+ (void)cancelRequestWithURL:(NSString *)url;
+ (NSString *)nb_URLEncode:(NSString *)url;
#pragma mark -- 请求
// get请求 三种情况  有无参数 和进度
+ (NBURLSessionTask *)getWithUrl:(NSString *)url
                    refreshCache:(BOOL)refreshCache
                         success:(NBResponseSuccess)success
                            fail:(NBResponseFail)fail;

+ (NBURLSessionTask *)getWithUrl:(NSString *)url
                    refreshCache:(BOOL)refreshCache
                          params:(NSDictionary *)params
                         success:(NBResponseSuccess)success
                            fail:(NBResponseFail)fail;

+ (NBURLSessionTask *)getWithUrl:(NSString *)url
                    refreshCache:(BOOL)refreshCache
                          params:(NSDictionary *)params
                        progress:(NBGetProgress)progress
                         success:(NBResponseSuccess)success
                            fail:(NBResponseFail)fail;


// post 请求

+ (NBURLSessionTask *)postWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                           params:(NSDictionary *)params
                          success:(NBResponseSuccess)success
                             fail:(NBResponseFail)fail;

+ (NBURLSessionTask *)postWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                           params:(NSDictionary *)params
                         progress:(NBPostProgress)progress
                          success:(NBResponseSuccess)success
                             fail:(NBResponseFail)fail;

// 上传文件
+ (NBURLSessionTask *)uploadWithImage:(UIImage *)image
                                  url:(NSString *)url
                               params:(NSDictionary *)params
                             fileName:(NSString *)fileName
                                 name:(NSString *)name
                             mimeType:(NSString *)mime
                              success:(NBResponseSuccess)success
                                 fail:(NBResponseFail)fail;

//上传文件
+ (NBURLSessionTask *)uploadWithDate:(NSData *)data
                                     url:(NSString *)url
                                  params:(NSDictionary *)params
                                fileName:(NSString *)fileName
                                    name:(NSString *)name
                                mimeType:(NSString *)mime
                                 success:(NBResponseSuccess)success
                                    fail:(NBResponseFail)fail;

+ (NBURLSessionTask *)uploadFileWithUrl:(NSString *)url
                               fileName:(NSString *)fileName
                               progerss:(NBUploadProgress)progress
                                success:(NBResponseSuccess)success
                                   fail:(NBResponseFail)fail;

//下载文件
+ (NBURLSessionTask *)downloadFileWithUrl:(NSString *)url
                               saveToPath:(NSString *)path
                                 progress:(NBDownloadProgress)progress
                                  success:(NBResponseSuccess)success
                                     fail:(NBResponseFail)fail;


@end















