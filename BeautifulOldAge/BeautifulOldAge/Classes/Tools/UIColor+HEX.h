//
//  UIColor+HEX.h
//  BeautifulOldAge
//
//  Created by Mac on 2018/6/6.
//  Copyright © 2018年 hncoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HEX)
+ (UIColor *)colorWithHex:(UInt32)hex;
+ (UIColor *)colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString:(NSString *)hexString;
- (NSString *)HEXString;

+ (UIColor *)colorWithWholeRed:(CGFloat)red
                         green:(CGFloat)green
                          blue:(CGFloat)blue
                         alpha:(CGFloat)alpha;

+ (UIColor *)colorWithWholeRed:(CGFloat)red
                         green:(CGFloat)green
                          blue:(CGFloat)blue;
@end
