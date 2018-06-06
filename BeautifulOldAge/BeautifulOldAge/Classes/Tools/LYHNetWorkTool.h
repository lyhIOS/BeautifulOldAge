//
//  LYHNetWorkTool.h
//  BeautifulOldAge
//
//  Created by Mac on 2018/6/6.
//  Copyright © 2018年 hncoon. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

// 宏定义请求成功的block
typedef void (^successBlock)(BOOL isSuccess,id responseObject);
// 宏定义请求失败的block
typedef void (^failureBlock)(NSError * error);

@interface LYHNetWorkTool : AFHTTPSessionManager

// LYHNetWorkTool单利
+ (instancetype)shareNetWorkTool;

// 监测网络状态
+ (void)networkStateMonitoring;

// get请求网络数据
+ (void)GET:(NSString *)url
     params:(NSDictionary *)params
    success:(successBlock)success
    failure:(failureBlock)failure;

// post请求网络数据
+ (void)POST:(NSString *)url
      params:(NSDictionary *)params
     success:(successBlock)success
     failure:(failureBlock)failure;

#pragma mark POST 上传图片
/**
 *  @param path           上传的地址url
 *  @param paramters      上传图片预留参数--根据具体需求而定，可以出
 *  @param imageArray     上传的图片数组
 *  @param width          图片要被压缩到的宽度
 *  @param upLoadProgress 进度
 *  @param success        请求成功的回调
 *  @param failure        请求失败的回调
 */
+ (void)UploadImageWithPath:(NSString *)path
                withParamters:(NSDictionary *)paramters
               withImageArray:(NSArray *)imageArray
              withtargetWidth:(CGFloat )width
                 withProgress:(void(^) (float progress))upLoadProgress
                      success:(void(^) (BOOL isSuccess,id responseObject))success
                      failure:(void(^) (NSError * error))failure;

#pragma mark POST 上传视频
/**
 *  @param path           上传的地址url
 *  @param videoPath      上传的视频-本地沙盒的路径
 *  @param paramters      上传视频预留参数--根据具体需求而定，可以出
 *  @param upLoadProgress 进度
 *  @param success        请求成功的回调
 *  @param failure        请求失败的回调
 */
+ (void)UploadVideoWithPath:(NSString *)path
                withVideoPath:(NSString *)videoPath
                withParamters:(NSDictionary *)paramters
                 withProgress:(void(^) (float progress))upLoadProgress
                      success:(void(^) (BOOL isSuccess,id responseObject))success
                      failure:(void(^) (NSError * error))failure;


// 文件下载
+ (void)downLoadFileWithPath:(NSString *)path
                      withParamters:(NSDictionary *)paramters
                       withSavaPath:(NSString *)savePath
                       withProgress:(void(^) (float progress))downLoadProgress
                            success:(void(^) (BOOL isSuccess,id responseObject))success
                            failure:(void(^) (NSError * error))failure ;


@end
