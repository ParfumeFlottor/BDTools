//
//  BDImageTools.h
//  
//
//  Created by 枫叶砂 on 2019/1/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BDImageTools : NSObject

/**
 压缩图片

 @param source_image 源图
 @param maxSize 压缩大小
 @return 压缩后的图
 */
+ (NSData *)resetSizeOfImageDataMethodTwo:(UIImage *)source_image maxSize:(int)maxSize;

/**
 生成二维码

 @param string 二维码内容
 @param logoImage logo
 @return 二维码
 */
+ (UIImage *)codeImageForString:(NSString *)string andLogoImage:(UIImage *)logoImage;
@end

NS_ASSUME_NONNULL_END
