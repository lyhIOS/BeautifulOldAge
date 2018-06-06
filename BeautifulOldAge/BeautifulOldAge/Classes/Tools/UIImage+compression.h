//
//  UIImage+compression.h
//  BeautifulOldAge
//
//  Created by Mac on 2018/6/6.
//  Copyright © 2018年 hncoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (compression)

/**
 *  图片压缩
 *
 *  @param compressImage   被压缩的图片
 *  @param defineWidth 被压缩的尺寸(宽)
 *  @return 被压缩的图片
 */
+(UIImage *)imageCompressed:(UIImage *)compressImage withdefineWidth:(CGFloat)defineWidth;

@end
