//
//  LYHNetWorkTool.m
//  BeautifulOldAge
//
//  Created by Mac on 2018/6/6.
//  Copyright © 2018年 hncoon. All rights reserved.
//

#import "LYHNetWorkTool.h"


static LYHNetWorkTool *netWorkTool = nil;

@implementation LYHNetWorkTool

+ (instancetype)shareNetWorkTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (netWorkTool == nil) {
            NSURL *url = [NSURL URLWithString:@"http://iosapi.itcast.cn/loveBeen/"];
            netWorkTool = [[LYHNetWorkTool alloc]initWithBaseURL:url];
            netWorkTool.requestSerializer = [[AFJSONRequestSerializer alloc]init];
            netWorkTool.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        }
    });
    return netWorkTool;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (netWorkTool == nil) {
            netWorkTool = [super allocWithZone:zone];
        }
    });
    return netWorkTool;
}

// 监测网络状态
+ (void)networkStateMonitoring {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变时调用
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"手机自带网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                break;
        }
    }];
    //开始监控
    [manager startMonitoring];
}

#pragma mark get请求网络数据
+ (void)GET:(NSString *)url
     params:(NSDictionary *)params success:(successBlock)success
       failure:(failureBlock)failure {
    [LYHNetWorkTool GET:url params:params success:^(BOOL isSuccess,id responseObject) {
        success(YES,responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark post请求网络数据
+ (void)POST:(NSString *)url
      params:(NSDictionary *)params
     success:(successBlock)success
        failure:(failureBlock)failure {
    [LYHNetWorkTool POST:url params:params success:^(BOOL isSuccess,id responseObject) {
        success(YES,responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark POST 上传图片
+ (void)UploadImageWithPath:(NSString *)path withParamters:(NSDictionary *)paramters withImageArray:(NSArray *)imageArray withtargetWidth:(CGFloat)width withProgress:(void (^)(float))upLoadProgress success:(void (^)(BOOL, id))success failure:(void (^)(NSError *))failure {
    
    [[LYHNetWorkTool shareNetWorkTool] POST:path parameters:paramters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSUInteger i = 0 ;
        // 上传图片时，为了用户体验或是考虑到性能需要进行压缩
        for (UIImage * image in imageArray) {
            // 压缩图片，指定宽度（注释：imageCompressed：withdefineWidth：图片压缩的category）
            UIImage *  resizedImage =  [UIImage imageCompressed:image withdefineWidth:width];
            NSData * imgData = UIImageJPEGRepresentation(resizedImage, 0.5);
            // 拼接Data
            [formData appendPartWithFileData:imgData name:[NSString stringWithFormat:@"picflie%ld",(long)i] fileName:@"image.png" mimeType:@" image/jpeg"];
            i++;
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"downLoadProcess = %@",uploadProgress);
        if (uploadProgress) upLoadProgress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        if (success) {
            success(YES,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
        if (failure)
            failure(error);
    }];
}

#pragma mark 上传视频
+ (void)UploadVideoWithPath:(NSString *)path withVideoPath:(NSString *)videoPath withParamters:(NSDictionary *)paramters withProgress:(void (^)(float))upLoadProgress success:(void (^)(BOOL, id))success failure:(void (^)(NSError *))failure {
    // 获取视频资源
    AVURLAsset * avUrlAsset = [AVURLAsset assetWithURL:[NSURL URLWithString:videoPath]];
    // 视频压缩
    AVAssetExportSession  *  avAssetExport = [[AVAssetExportSession alloc] initWithAsset:avUrlAsset presetName:AVAssetExportPreset640x480];
    // 获取上传的时间
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    // 转化后直接写入Library---caches
    NSString *videoWritePath = [NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/output-%@.mp4", [formatter stringFromDate:[NSDate date]]]; 
    avAssetExport.outputURL = [NSURL URLWithString:videoWritePath];
    avAssetExport.outputFileType =  AVFileTypeMPEG4;
    [avAssetExport exportAsynchronouslyWithCompletionHandler:^{
        switch ([avAssetExport status]) {
            case AVAssetExportSessionStatusCompleted:
            {
                [[LYHNetWorkTool shareNetWorkTool] POST:path parameters:paramters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                    //获得沙盒中的视频内容
                    [formData appendPartWithFileURL:[NSURL fileURLWithPath:videoWritePath] name:@"write you want to writre" fileName:videoWritePath mimeType:@"video/mpeg4" error:nil];
                    
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                    NSLog(@"downLoadProcess = %@",uploadProgress);
                    if (uploadProgress) {
                        
                        upLoadProgress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
                    }
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
                    
                    NSLog(@"responseObject = %@",responseObject);
                    if (success) {
                        success(YES,responseObject);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    NSLog(@"responseObject = %@",error);
                    if (failure) {
                        failure(error);
                    }
                }];
                break;
            }
            default:
                break;
        }
    }];
}

#pragma mark 文件下载
+ (void)downLoadFileWithPath:(NSString *)path withParamters:(NSDictionary *)paramters withSavaPath:(NSString *)savePath withProgress:(void (^)(float))downLoadProgress success:(void (^)(BOOL, id))success failure:(void (^)(NSError *))failure {
    [[LYHNetWorkTool shareNetWorkTool] downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]] progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"downLoadProcess = %@",downLoadProgress);
        if (downloadProgress) {
            
            downLoadProgress(downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return  [NSURL URLWithString:savePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error) {
            
            failure(error);
        }
        
    }];
}


@end
