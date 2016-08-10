

//
//  NBNetworking.m
//  AFNetworkingDemo
//
//  Created by caozhen on 16/5/20.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import "NBNetworking.h"
#import <AFNetworking.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (MD5)
+ (NSString *)NB_MD5:(NSString *)str;

@end


@implementation NSString (MD5)
+ (NSString *)NB_MD5:(NSString *)str
{
    if (str == nil || [str length] == 0) {
        return nil;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([str UTF8String], (int)[str lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    
    return [ms copy];

}

@end


static NSString         *nb_baseUrl = nil;
static NBNetworkStatus nb_networkStatus = kNBNetworkStatusUnknown;

static NSDictionary     *nb_httpHeaders = nil;

static NBRequestType    nb_requestType = kNBRequestTypePlainText;
static NBResponseType   nb_responseType = kNBResponseTypeJSON;

static NSTimeInterval nb_timeout = 60.0;
// 网络变化读缓存
static BOOL nb_cacheGet = NO;
static BOOL nb_cachePost = NO;
static BOOL nb_shouldReadLocalCacheWhenUnconnected = NO;

static BOOL nb_shouldAutoEncode = YES;
static BOOL nb_debug = YES;

static BOOL nb_shoudCallBackWhenCancelRequest = YES;

//请求
static NSMutableArray   *nb_requestTasks = nil;

#define NBNetworkingCachePath [NSHomeDirectory() stringByAppendingString:@"/Document/NBNetworkingCaches"]


@implementation NBNetworking


+ (NSString *)baseUrl{
    return nb_baseUrl;
}

+ (void)updateBaseUrl:(NSString *)baseUrl{
    nb_baseUrl = baseUrl;
}

+ (void)setTimeout:(NSTimeInterval)timeout{
    nb_timeout = timeout;
}

+ (void)obtainDataFromLocalWhenNetworkUnconnected:(BOOL)shouldObtain{

    nb_shouldReadLocalCacheWhenUnconnected = shouldObtain;
}

+ (void)cacheGetRequest:(BOOL)isCacheGet shoulCachePost:(BOOL)shouldCachePost{
    nb_cacheGet = isCacheGet;
    nb_cachePost = shouldCachePost;
}

+ (void)enableInterfaceDebug:(BOOL)isDebug{
    nb_debug = isDebug;
}

+ (void)configRequestType:(NBRequestType)requestType
             responseType:(NBResponseType)responseType
      shouldAutoEncodeUrl:(BOOL)shouldAutoEncode
  callbackOnCancelRequest:(BOOL)shouldCallbackOnCancelRequest{
    nb_requestType = requestType;
    nb_responseType = responseType;
    nb_shouldAutoEncode = shouldAutoEncode;
    nb_shoudCallBackWhenCancelRequest = shouldCallbackOnCancelRequest;

}

+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders{
    
    nb_httpHeaders = httpHeaders;
}

+ (void)configCommonHttpHeaders{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *tokenStr = [userDefault objectForKey:@"token"];
    [userDefault synchronize];

    if (tokenStr&&![tokenStr isEqualToString:@""]) {
    

        NSDictionary *dicHeaders   = @{@"version":version,@"deviceid":identifierForVendor,@"token":tokenStr};

        nb_httpHeaders = dicHeaders;

    }else
    {
        NSDictionary *dicHeaders   = @{@"version":version,@"deviceid":identifierForVendor};
        nb_httpHeaders = dicHeaders;

    }

}


+ (unsigned long long)totalCacheSize{
    BOOL isDir = NO;
    unsigned long long totalCacheSize = 0;
    if ([[NSFileManager defaultManager] fileExistsAtPath:NBNetworkingCachePath isDirectory:&isDir]) {
        if (isDir) {
            NSError *error = nil;
            NSArray *array = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:NBNetworkingCachePath error:&error];
            if (!error) {
                for (NSString *relativePath in array) {
                    NSString *path = [NBNetworkingCachePath stringByAppendingString:relativePath];
                    NSDictionary *fileDict = [[NSFileManager defaultManager]attributesOfItemAtPath:path error:&error];
                    if (!error) {
                        totalCacheSize += [fileDict[NSFileSize] unsignedIntegerValue];
                    }
                }
            }
        }
    }
    
    return totalCacheSize;
}

+ (void)clearCaches{
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:NBNetworkingCachePath isDirectory:nil]) {
        NSError *error = nil;
        if ([[NSFileManager defaultManager] removeItemAtPath:NBNetworkingCachePath error:&error]) {
            if (!error) {
                NBLog(@"clear path success!");
            }else{
                NBLog(@"clear path error:%@",[error localizedDescription]);
            
            }
        }
    }
}

+ (void)cancelAllRequest{
    
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(NBURLSessionTask *task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[NBURLSessionTask class]]) {
                [task cancel];
            }
        }];
        [[self allTasks] removeAllObjects];
    }

}


+ (void)cancelRequestWithURL:(NSString *)url{
    if (!url) {
        return;
    }
    
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(NBURLSessionTask *task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[NBURLSessionTask class]] ||
                [task.currentRequest.URL.absoluteString hasSuffix:url]) {
                [task cancel];
                [[self allTasks] removeObject:task];
                return ;
            }
            
        }];
    }
}

+ (BOOL)shouldEncode {
    return nb_shouldAutoEncode;
}



+ (AFHTTPSessionManager *)manager{
    AFHTTPSessionManager *manager = nil;
    if ([self baseUrl]) {
        manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:[self baseUrl]]];
    }else{
        manager = [[AFHTTPSessionManager alloc]init];
    }
    switch (nb_requestType) {
        case kNBRequestTypeJSON:
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        case kNBRequestTypePlainText:
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        default:
            break;
    }
    for (NSString *key in nb_httpHeaders.allKeys) {
        if (nb_httpHeaders[key]) {
            [manager.requestSerializer setValue:nb_httpHeaders[key] forHTTPHeaderField:key];
        }
    }
   
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    switch (nb_responseType) {
        case kNBResponseTypeJSON: {
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        }
        case kNBResponseTypeXML: {
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        }
        case kNBResponseTypeData: {
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        }
    }
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                         @"text/html",
                                                         @"text/json",
                                                         @"text/plain",
                                                         @"text/javascript",
                                                         @"text/xml",
                                                         @"imag/*"]];
    
    
    manager.operationQueue.maxConcurrentOperationCount = 3;
    
    if ((nb_cacheGet || nb_cachePost) && nb_shouldReadLocalCacheWhenUnconnected) {
        [self detectNetwork];
    }
    
    
    return manager;
}

+ (void)detectNetwork{
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager startMonitoring];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable){
            nb_networkStatus = kNBNetworkStatusNotReachable;
        }else if (status == AFNetworkReachabilityStatusUnknown){
            nb_networkStatus = kNBNetworkStatusUnknown;
        }else if (status == kNBNetworkStatusReachableViaWWAN){
            nb_networkStatus = kNBNetworkStatusReachableViaWWAN;
        }else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
            nb_networkStatus = KNBNetworkStatusReachableViaWiFi;
        }
    }];

}
#pragma mark ---- get请求 三种情况  有无参数 和进度
+ (NBURLSessionTask *)getWithUrl:(NSString *)url
                refreshCache:(BOOL)refreshCache
                     success:(NBResponseSuccess)success
                        fail:(NBResponseFail)fail
{
    return [self _requestWithUrl:url refreshCache:refreshCache params:nil httpMethod:kNBHttpMethodGet progress:nil success:success fail:fail];

}

+ (NBURLSessionTask *)getWithUrl:(NSString *)url
                refreshCache:(BOOL)refreshCache
                      params:(NSDictionary *)params
                     success:(NBResponseSuccess)success
                        fail:(NBResponseFail)fail
{
    return [self _requestWithUrl:url refreshCache:refreshCache params:params httpMethod:kNBHttpMethodGet progress:nil success:success fail:fail];
}

+ (NBURLSessionTask *)getWithUrl:(NSString *)url
                refreshCache:(BOOL)refreshCache
                      params:(NSDictionary *)params
                    progress:(NBGetProgress)progress
                     success:(NBResponseSuccess)success
                        fail:(NBResponseFail)fail
{
    return [self _requestWithUrl:url refreshCache:refreshCache params:params httpMethod:kNBHttpMethodGet progress:progress success:success fail:fail];    
}



+ (NSString *)nb_URLEncode:(NSString *)url {
     NSString *finalValue = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return finalValue;
}


+ (NBURLSessionTask *)_requestWithUrl:(NSString *)url
                    refreshCache:(BOOL)refreshCache
                          params:(NSDictionary *)params
                      httpMethod:(NBHttpMethod)method
                        progress:(NBDownloadProgress)progress
                         success:(NBResponseSuccess)success
                             fail:(NBResponseFail)fail{
    
    AFHTTPSessionManager *manager = [self manager];

    NSString *absolute  = [self absoluteUrlWithPath:url];
    
    if ([self baseUrl] == nil) {
        if ([NSURL URLWithString:url] == nil) {
            NBLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return nil;
        }
    } else {
        NSURL *absouluteURL = [NSURL URLWithString:absolute];
        
        if (absouluteURL == nil) {
            NBLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            return nil;
        }
    }
    
    if ([self shouldEncode]) {
        url = [self nb_URLEncode:url];
    }
  
    NBURLSessionTask *task = nil;
    if (method == kNBHttpMethodGet) {
        // 有缓存的情况下,在没网的时候直接读取缓存
        if (nb_cacheGet) {
            if (nb_shouldReadLocalCacheWhenUnconnected) {
                if (nb_networkStatus == kNBNetworkStatusUnknown || nb_networkStatus == kNBNetworkStatusNotReachable) {
                    id response = [self cacheResponseWithURL:url params:params];
                    if (response) {
                        if (success) {
                            [self successResponse:response callback:success];
                        }
                        if (nb_debug) {
                            [self logWithSuccessResponse:response url:url params:params];
                        }
                    }
                }
            }
        }
        
        // 如果有网，并且只从缓存中获取
        if (!refreshCache) {
            id response = [self cacheResponseWithURL:url params:params];
            if (response) {
                if (success) {
                    [self successResponse:response callback:success];
                }
                if (nb_debug) {
                    [self logWithSuccessResponse:response url:url params:params];
                }
            }
            return task;
        }

        
         task = [manager GET:absolute parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
             if (progress) {
                 progress(downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
             }
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             [self successResponse:responseObject callback:success];
             // 处理缓存
             if (nb_cacheGet) {
                 [self cacheResponseObject:responseObject request:task.currentRequest params:params];
             }
             [[self allTasks] removeObject:task];
             
             if (nb_debug) {
                 [self logWithSuccessResponse:responseObject url:url params:params];
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [NBNetworking candleNoNetWork:error];

             [[self allTasks] removeObject:task];
             // 判断请求失败是否要读缓存
             if ([error code] < 0 && nb_cacheGet) {
                 id response = [self cacheResponseWithURL:url params:params];
                 if (response) {
                     if (success) {
                         [self successResponse:response callback:success];
                         if (nb_debug) {
                             [self logWithSuccessResponse:response url:url params:params];
                         }
                     }
                 }
                 
             }else{
                 //处理错误
                 fail(error);
                 
                 if (nb_debug) {
                     [self logWithFailError:error url:url params:params];
                 }
             }
             
         }];
        
    }else if(method == kNBHttpMethodPost){
        // 有缓存的情况下,在没网的时候直接读取缓存
        if (nb_cachePost) {
            if (nb_shouldReadLocalCacheWhenUnconnected) {
                if (nb_networkStatus == kNBNetworkStatusUnknown || nb_networkStatus == kNBNetworkStatusNotReachable) {
                    id response = [self cacheResponseWithURL:url params:params];
                    if (response) {
                        if (success) {
                            [self successResponse:response callback:success];
                        }
                        if (nb_debug) {
                            [self logWithSuccessResponse:response url:url params:params];
                        }
                    }
                }
            }
        }
        
        // 如果有网，并且只从缓存中获取
//        if (!refreshCache) {
//            id response = [self cacheResponseWithURL:url params:params];
//            if (response) {
//                if (success) {
//                    [self successResponse:response callback:success];
//                }
//                if (nb_debug) {
//                    [self logWithSuccessResponse:response url:url params:params];
//                }
//            }
//            return task;
//        }
 
        
        
        task = [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            if (progress) {
                progress(uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self successResponse:responseObject callback:success];
//            if (nb_cachePost) {
//                [self cacheResponseObject:responseObject request:task.currentRequest params:params];
//            }
            [[self allTasks] removeObject:task];
            if (nb_debug) {
                [self logWithSuccessResponse:responseObject url:url params:params];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [NBNetworking candleNoNetWork:error];

            [[self allTasks] removeObject:task];
            if (error.code < 0 && nb_cachePost) {
                id response = [self cacheResponseWithURL:url params:params];
                if (response) {
                    if (success) {
                        [self successResponse:response callback:success];
                        if (nb_debug) {
                            [self logWithSuccessResponse:response url:url params:params];
                        }
                    }
                }else{
                    fail(error);
                    if (nb_debug) {
                        [self logWithFailError:error url:url params:params];
                    }
                }
            }else{
                fail(error);
                if (nb_debug) {
                    [self logWithFailError:error url:url params:params];
                }
                
            }
        }];
    
    }
    
    return task;
}

// post
+ (NBURLSessionTask *)postWithUrl:(NSString *)url
                 refreshCache:(BOOL)refreshCache
                       params:(NSDictionary *)params
                      success:(NBResponseSuccess)success
                         fail:(NBResponseFail)fail

{
    return [self _requestWithUrl:url refreshCache:refreshCache params:params httpMethod:kNBHttpMethodPost progress:nil success:success fail:fail];

}

+ (NBURLSessionTask *)postWithUrl:(NSString *)url
                 refreshCache:(BOOL)refreshCache
                       params:(NSDictionary *)params
                     progress:(NBPostProgress)progress
                      success:(NBResponseSuccess)success
                         fail:(NBResponseFail)fail

{
    return [self _requestWithUrl:url refreshCache:refreshCache params:nil httpMethod:kNBHttpMethodGet progress:nil success:success fail:fail];

}


#pragma mark ---- 图片 文件的上传与下载
+ (NBURLSessionTask *)uploadWithImage:(UIImage *)image
                                  url:(NSString *)url
                               params:(NSDictionary *)params
                             fileName:(NSString *)fileName
                                 name:(NSString *)name
                             mimeType:(NSString *)mime
                              success:(NBResponseSuccess)success
                                 fail:(NBResponseFail)fail{
    NBURLSessionTask *task = nil;
    
    //url 转 absoluteURL
    NSString *absoluteURL = [self absoluteUrlWithPath:url];
    if ([self shouldEncode]) {
        absoluteURL = [self nb_URLEncode:absoluteURL];
    }
    
    AFHTTPSessionManager *manager = [self manager];
    task = [manager POST:absoluteURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *imgData = UIImageJPEGRepresentation(image,0.5);
        
        NSString *renameFileName = fileName;
        if (!fileName || ![fileName isKindOfClass:[NSString class]] || fileName.length == 0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *timeStr = [formatter stringFromDate:[NSDate date]];
            renameFileName = [timeStr stringByAppendingString:@".jpg"];
        }
        [formData appendPartWithFileData:imgData name:name fileName:renameFileName mimeType:mime];
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self successResponse:responseObject callback:success];
        [[self allTasks]removeObject:task];
        if (nb_debug) {
            [self logWithSuccessResponse:responseObject url:url params:params];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fail(error);
        if (nb_debug) {
            [self logWithFailError:error url:url params:params];
        }
        
    }];
    [task resume];
    [[self allTasks] addObject:task];
    return task;
}



+ (NBURLSessionTask *)uploadWithDate:(NSData *)data
                                  url:(NSString *)url
                               params:(NSDictionary *)params
                             fileName:(NSString *)fileName
                                 name:(NSString *)name
                             mimeType:(NSString *)mime
                              success:(NBResponseSuccess)success
                                 fail:(NBResponseFail)fail{
    NBURLSessionTask *task = nil;
    
    //url 转 absoluteURL
    NSString *absoluteURL = [self absoluteUrlWithPath:url];
    if ([self shouldEncode]) {
        absoluteURL = [self nb_URLEncode:absoluteURL];
    }
    
    AFHTTPSessionManager *manager = [self manager];
    task = [manager POST:absoluteURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mime];

        
    } progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self successResponse:responseObject callback:success];
        [[self allTasks]removeObject:task];
        if (nb_debug) {
            [self logWithSuccessResponse:responseObject url:url params:params];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
        if (nb_debug) {
            [self logWithFailError:error url:url params:params];
        }
        
    }];
    [task resume];
    [[self allTasks] addObject:task];
    return task;
}

+ (NBURLSessionTask *)uploadFileWithUrl:(NSString *)url
                               fileName:(NSString *)fileName
                               progerss:(NBUploadProgress)progress
                                success:(NBResponseSuccess)success
                                   fail:(NBResponseFail)fail{
    NBURLSessionTask *task = nil;
    
    NSString *uploadURL = [self absoluteUrlWithPath:url];
    
    AFHTTPSessionManager *manager = [self manager];
    task = [manager uploadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:uploadURL]] fromFile:[NSURL URLWithString:fileName] progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            [self successResponse:responseObject callback:success];
            if (nb_debug) {
                [self logWithSuccessResponse:responseObject url:url params:nil];
            }
            
        }else{
            if (fail) {
                fail(error);
            }
            if (nb_debug) {
                [self logWithFailError:error url:url params:nil];
            }
            
        }
    }];
    [task resume];
    if (task) {
        [[self allTasks] addObject:task];
    }
    
    return task;
}

+ (NBURLSessionTask *)downloadFileWithUrl:(NSString *)url
                               saveToPath:(NSString *)path
                                 progress:(NBDownloadProgress)progress
                                  success:(NBResponseSuccess)success
                                     fail:(NBResponseFail)fail{
    NBURLSessionTask *task = nil;
    AFHTTPSessionManager *manager = [self manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL URLWithString:path];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [[self allTasks] removeObject:task];
        if (!error) {
            if (success) {
                success(filePath.absoluteString);
            }
            if (nb_debug) {
                NBLog(@"Download success from url:%@ to path:%@",url,path);
            }
        }else{
            if (fail) {
                fail(error);
            }
            if (nb_debug) {
                NBLog(@"Download fail from url:%@ to path:%@",url,path);
            }
        
        }
        
    }];
    
    [task resume];
    if (task) {
        [[self allTasks] addObject:task];
    }

    return task;
}

#pragma mark ---- privite method
/**
 *  根据url+ params 产生最终的get url地址
 *
 *  @param url    请求路径 baseURL
 *  @param params 请求参数
 *
 *  @return Get的最终地址
 */
+ (NSString *)generateGETAbsoluteURL:(NSString *)url params:(NSDictionary *)params{
    if (!params||![params isKindOfClass:[NSDictionary class]]||params.count == 0) {
        return [self absoluteUrlWithPath:url];
    }
    
    //防止重复拼接参数
    NSRange range = [url rangeOfString:@"?"];
    if (range.length > 0 ) {
        url = [url substringToIndex:range.location];
    }
    NSString *queries = @"";
    for (NSString *key in params) {
        id value = [params objectForKey:key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            continue;
        }else if ([value isKindOfClass:[NSArray class]]) {
            continue;
        }else if ([value isKindOfClass:[NSSet class]]){
            continue;
        }
        queries = [NSString stringWithFormat:@"%@%@=%@&",queries.length == 0? @"&":queries,key,value];
    }
    //去掉前面多余的&
    if (queries.length>1) {
        queries = [queries substringFromIndex:1];
        queries = [queries substringToIndex:queries.length -1 ];
    }
    NSString *absoluteUrl = [self absoluteUrlWithPath:url];
    if ([absoluteUrl hasPrefix:@"http://"]||[absoluteUrl hasPrefix:@"https://"]||[absoluteUrl length] > 0) {
        
        //判断absolteUrl 末尾是否已经有？或者 #
        if ([absoluteUrl rangeOfString:@"?"].length > 0||
            [absoluteUrl rangeOfString:@"#"].length > 0) {
            url = [NSMutableString stringWithFormat:@"%@%@",absoluteUrl,queries];
        }else{
            url = [NSMutableString stringWithFormat:@"%@?%@",absoluteUrl,queries];
        }
        
    }
    return url.length == 0 ? queries:url;
    
}

/**
 *  读缓存
 *  注:targetPath = cachePath + absolutePath(url+params)
 *  @param url    请求路径
 *  @param params 请求参数
 *
 *  @return 缓存数据(nullable)
 */
+ (id)cacheResponseWithURL:(NSString *)url params:(NSDictionary *)params{
    id cacheData = nil;
    if (url) {
        NSString *cachePath = NBNetworkingCachePath;
        NSString *absoluteURL = [self generateGETAbsoluteURL:url params:params];
        NSString *key = [NSString NB_MD5:absoluteURL];
        NSString *path = [cachePath stringByAppendingPathComponent:key];
        
        NSData *data = [[NSFileManager defaultManager]contentsAtPath:path];
        if (data) {
            cacheData = data;
            NBLog(@"Read data from cache for url: %@\n",url);
        }
    }
    return cacheData;
}

/**
 *  存缓存
 *  注:targetPath = cachePath + absolutePath(url+params)
 *  @param responseObject 代存数据
 *  @param request        请求对象,包含请求路径
 *  @param params         请求参数
 */
+ (void)cacheResponseObject:(id)responseObject request:(NSURLRequest *)request params:(id)params{
    if (request&&responseObject&&![responseObject isKindOfClass:[NSNull class]]) {
        NSString *catchePath = NBNetworkingCachePath;
        
        // 保证cachePath存在
        
        NSError *error = nil;
        if (![[NSFileManager defaultManager] fileExistsAtPath:catchePath isDirectory:nil]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:catchePath withIntermediateDirectories:YES attributes:nil error:&error];
            if (error) {
                NBLog(@"\n create cachePath error:%@\n",[error localizedDescription]);
                return;
            }
            
            NSString *absoluteURL = [self generateGETAbsoluteURL:request.URL.absoluteString params:params];
            NSString *key = [NSString NB_MD5:absoluteURL];
            NSString *path = [catchePath stringByAppendingPathComponent:key];
            
            NSData *data = nil;
            if ([responseObject isKindOfClass:[NSData class]]) {
                data = responseObject;
            }else{
                data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
            }
            if (data && !error) {
                BOOL isOK = [[NSFileManager defaultManager]createFileAtPath:path contents:data attributes:nil];
                if (isOK) {
                    NBLog(@"read cache file success ,request:%@,\n\ncache path:%@\n\n",absoluteURL,path);
                }else{
                    NBLog(@"read cache file error:request:%@,\n\ncache path:%@\n\n",absoluteURL,path);
                }
                
            }
        }
    }
}


// 相对路径变为绝对路径
+ (NSString *)absoluteUrlWithPath:(NSString *)path{
    if (!path||path.length == 0) {
        return [self baseUrl];
    }
    //去掉末位多余的/
    if ([path characterAtIndex:path.length-1] == '/' ) {
        path = [path substringToIndex:path.length - 1];
        
    }
    
    if (![self baseUrl]||[self baseUrl].length == 0) {
        return path;
    }
    NSString *absoluteUrl = path;
    
    if (![path hasPrefix:@"http://"]&&![path hasPrefix:@"https://"]) {
        //判断baseUrl 有无后缀"/"  以及path有无前缀"/"
        if ([[self baseUrl] hasSuffix:@"/"]) {
            if ([path hasPrefix:@"/"]) {
                NSMutableString *mutiPath = [NSMutableString stringWithString:path];
                [mutiPath deleteCharactersInRange:NSMakeRange(0, 1)];
                absoluteUrl = [NSString stringWithFormat:@"%@%@",[self baseUrl],mutiPath];
            }else{
                absoluteUrl = [NSString stringWithFormat:@"%@%@",[self baseUrl],path];
                
            }
        }else{
            
            if ([path hasPrefix:@"/"]) {
                absoluteUrl = [NSString stringWithFormat:@"%@%@",[self baseUrl],path];
                
            }else{
                
                absoluteUrl = [NSString stringWithFormat:@"%@/%@",[self baseUrl],path];
            }
        }
        
    }
    return absoluteUrl;
}

// 对 responseData结果处理
+ (void)successResponse:(id)responseData callback:(NBResponseSuccess)success{
    if (success) {
        success(responseData);
    }
}

+ (id)tryToParseData:(id)responseData{
    if ([responseData isKindOfClass:[NSData class]]) {
        //尝试解析 nsdata -> json
        if (!responseData) {
            return  responseData;
        }else{
            NSError *err = nil;
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData  options:NSJSONReadingMutableContainers error:&err];
            return  err? responseData:responseDict;
        }
    }else{
        //utf 8 编码
        NSData *data = nil;
        
    
        return responseData ;
    }
    
}

+ (NSMutableArray *)allTasks{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!nb_requestTasks) {
            nb_requestTasks = [NSMutableArray array];
        }
    });
    return nb_requestTasks;
}

+ (void)logWithSuccessResponse:(id)response url:(NSString *)url params:(NSDictionary *)params{
    NBLog(@"\n Request success,URL: %@\n params: %@\n response: %@\n",url,params,[self tryToParseData:response]);
}
+ (void)logWithFailError:(NSError *)error url:(NSString *)url params:(id)params{
    NSString *format = @"params: ";
    if (!params || ![params isKindOfClass:[NSDictionary class]]) {
        format = @"";
        params = @"";
    }
    
    if ([error code] == NSURLErrorCancelled) {
        NBLog(@"\nRequest was cancelled mannully,URL: %@ %@%@n\n",[self generateGETAbsoluteURL:url params:params],format,params);
    }else{
        NBLog(@"\nRequest error,URL: %@ %@%@ errorInfo:%@n\n",[self generateGETAbsoluteURL:url params:params],format,params,[error localizedDescription]);
    }
    
}


+ (void)candleNoNetWork:(NSError *)error{
    //没网提示
    if (error.code == -1009) {
//        MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"网络异常,请检查网络设置";
//        [hud hide:YES afterDelay:1.0];
    }

}


@end
