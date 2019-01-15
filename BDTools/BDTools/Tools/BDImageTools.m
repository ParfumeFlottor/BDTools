//
//  BDImageTools.m
//  
//
//  Created by 枫叶砂 on 2019/1/15.
//

#import "BDImageTools.h"
#import <CoreImage/CoreImage.h>

@implementation BDImageTools
+ (NSData *)resetSizeOfImageDataMethodTwo:(UIImage *)source_image maxSize:(int)maxSize
{
    
    //先判断当前质量是否满足要求，不满足再进行压缩
    NSData * finallImageData = UIImageJPEGRepresentation(source_image,1.0);
    int sizeOriginKB = (int)finallImageData.length/1024;
    
    if (sizeOriginKB<=maxSize) {
        return finallImageData;
    }
    //先调整分辨率
    CGSize defaultSize = CGSizeMake(1000, 1000);
    UIImage *newImage = [self newSizeImage:defaultSize source_image:source_image];
    finallImageData = UIImageJPEGRepresentation(newImage,1.0);
    //保存压缩系数
    NSMutableArray * compressionQualityArr = [NSMutableArray array];
    CGFloat avg = 1.0/250;
    CGFloat value = avg;
    for (int i = 250; i>=1; i--) {
        value = i* avg;
        [compressionQualityArr addObject:@(value)];
    }
    /*
     调整大小
     说明：压缩系数数组compressionQualityArr是从大到小存储。
     */
    //思路：使用二分法搜索
    finallImageData = [self halfFuntion:compressionQualityArr image:newImage sourceData:finallImageData maxSize:maxSize];
    //如果还是未能压缩到指定大小，则进行降分辨率
    while (finallImageData.length == 0) {
        //每次降100分辨率
        if (defaultSize.width-100 <= 0 || defaultSize.height-100 <= 0){
            break;
        }
        defaultSize = CGSizeMake(defaultSize.width-100, defaultSize.height-100);
        UIImage * image = [self newSizeImage:defaultSize source_image:[UIImage imageWithData:UIImageJPEGRepresentation(newImage, [compressionQualityArr.lastObject floatValue])]];
        finallImageData = [self halfFuntion:compressionQualityArr image:image sourceData:UIImageJPEGRepresentation(image,1.0) maxSize:maxSize];
    }
    return finallImageData;
}

+ (UIImage *)newSizeImage:(CGSize )size source_image:(UIImage *)source_image
{
    CGSize newSize = CGSizeMake(source_image.size.width, source_image.size.height);
    CGFloat tempHeight = newSize.height / size.height;
    CGFloat tempWidth = newSize.width / size.width;
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize =  CGSizeMake(source_image.size.width / tempWidth, source_image.size.height / tempWidth);
        
    } else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(source_image.size.width / tempHeight,  source_image.size.height / tempHeight)  ;
    }
    UIGraphicsBeginImageContext(newSize);
    [source_image drawInRect:CGRectMake(0, 0, newSize.width+1, newSize.height+1)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// MARK: - 二分法
+ (NSData *)halfFuntion:(NSArray *)arr image:(UIImage *)image sourceData:(NSData *)finallImageData maxSize:(int)maxSize
{
    NSData * tempFinallImageData = finallImageData;
    NSData * tempData = [NSData new];
    int start = 0;
    int end = (int)arr.count-1;
    int index = 0;
    int difference = INT_MAX;
    while (start<=end) {
        index = start + (end - start)/2;
        tempFinallImageData = UIImageJPEGRepresentation(image, [arr[index] floatValue]);
        int sizeOrigin = (int)tempFinallImageData.length;
        int sizeOriginKB = sizeOrigin / 1024;
        if (sizeOriginKB > maxSize) {
            start = index + 1;
        } else if (sizeOriginKB < maxSize) {
            if (maxSize-sizeOriginKB < difference){
                difference = maxSize-sizeOriginKB;
                tempData = tempFinallImageData;
            }
            end = index - 1;
        } else {
            break;
        }
    }
    return  tempData;
}

/**
 二维码生成
 
 @param string 字符串
 @return 二维码
 */
+ (UIImage *)codeImageForString:(NSString *)string andLogoImage:(UIImage *)logoImage
{
    //创建名为"CIQRCodeGenerator"的CIFilter
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //将filter所有属性设置为默认值
    [filter setDefaults];
    //将所需尽心转为UTF8的数据，并设置给filter
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    //设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大 /* * L: 7% * M: 15% * Q: 25% * H: 30% */
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    //拿到二维码图片，此时的图片不是很清晰，需要二次加工
    CIImage *outPutImage = [filter outputImage];
    UIImage *codeImage = [self getHDImgWithCIImage:outPutImage size:CGSizeMake(150, 150)];
    codeImage = [self imagewithBGImage:codeImage addAvatarImage:logoImage ofTheSize:CGSizeMake(150, 150)];
    return codeImage;
}
+ (UIImage *)imagewithBGImage:(UIImage *)bgImage addAvatarImage:(UIImage *)avatarImage ofTheSize:(CGSize)size{
    if (avatarImage == nil) {
        return bgImage;
    }
    BOOL opaque = 1.0;
    // 获取当前设备的scale
    CGFloat scale = [UIScreen mainScreen].scale;
    // 创建画布Rect
    CGRect bgRect = CGRectMake(0, 0, size.width, size.height);
    // 头像大小 不能大于 画布的1/4 （这个大小之内的不会遮挡二维码的有效信息）
    CGFloat avatarWidth = (size.width/4.0);
    CGFloat avatarHeight = avatarWidth;
    //MARK:-调用一个新的切割绘图方法 crop image add cornerRadius (裁切头像图片为圆角，并添加bored 返回一个newimage)
    avatarImage = [self clipCornerRadius:avatarImage withSize:CGSizeMake(avatarWidth, avatarHeight)];
    // 设置头像的位置信息
    CGPoint position = CGPointMake(size.width/2.0, size.height/2.0);
    CGRect avatarRect = CGRectMake(position.x-(avatarWidth/2.0), position.y-(avatarHeight/2.0), avatarWidth, avatarHeight);
    // 设置画布信息
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);{// 开启画布
        // 翻转context （画布）
        CGContextTranslateCTM(context, 0, size.height);
        CGContextScaleCTM(context, 1, -1);
        // 根据 bgRect 用二维码填充视图
        CGContextDrawImage(context, bgRect, bgImage.CGImage);
        // 根据newAvatarImage 填充头像区域
        CGContextDrawImage(context, avatarRect, avatarImage.CGImage);
    }CGContextRestoreGState(context);// 提交画布
    // 从画布中提取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 释放画布
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)clipCornerRadius:(UIImage *)image withSize:(CGSize) size{
    // 白色border的宽度
    CGFloat outerWidth = size.width/15.0;
    // 黑色border的宽度
    CGFloat innerWidth = outerWidth/10.0;
    // 圆角这个就是我觉着的适合的一个值 ，可以自行改
    CGFloat corenerRadius = size.width/5.0;
    // 为context创建一个区域
    CGRect areaRect = CGRectMake(0, 0, size.width, size.height);
    UIBezierPath *areaPath = [UIBezierPath bezierPathWithRoundedRect:areaRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(corenerRadius, corenerRadius)];
    
    // origin position
    CGFloat outerOrigin = outerWidth/2.0;
    CGFloat innerOrigin = innerWidth/2.0 + outerOrigin/1.2;
    CGRect outerRect = CGRectInset(areaRect, outerOrigin, outerOrigin);
    CGRect innerRect = CGRectInset(outerRect, innerOrigin, innerOrigin);
    //  外层path
    UIBezierPath *outerPath = [UIBezierPath bezierPathWithRoundedRect:outerRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(outerRect.size.width/5.0, outerRect.size.width/5.0)];
    //  内层path
    UIBezierPath *innerPath = [UIBezierPath bezierPathWithRoundedRect:innerRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(innerRect.size.width/5.0, innerRect.size.width/5.0)];
    // 创建上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);{
        // 翻转context
        CGContextTranslateCTM(context, 0, size.height);
        CGContextScaleCTM(context, 1, -1);
        CGContextAddPath(context, areaPath.CGPath);
        CGContextClip(context);
        // context 添加 背景颜色，避免透明背景会展示后面的二维码不美观的。（当然也可以对想遮住的区域进行clear操作，但是我当时写的时候还没有想到）
        CGContextAddPath(context, areaPath.CGPath);
        UIColor *fillColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        CGContextFillPath(context);
        // context 执行画头像
        CGContextDrawImage(context, innerRect, image.CGImage);
        // context 添加白色的边框 -> 执行填充白色画笔
        CGContextAddPath(context, outerPath.CGPath);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(context, outerWidth);
        CGContextStrokePath(context);
        // context 添加黑色的边界 -> 执行填充黑色画笔
        CGContextAddPath(context, innerPath.CGPath);
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
        CGContextSetLineWidth(context, innerWidth);
        CGContextStrokePath(context);
    }CGContextRestoreGState(context);
    UIImage *radiusImage  = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return radiusImage;
}
/** 调整二维码清晰度
 @param img 模糊的二维码图片
 @param size 二维码的宽高
 @return 清晰的二维码图片
 */
+ (UIImage *)getHDImgWithCIImage:(CIImage *)img size:(CGSize)size {
    //二维码的颜色
    UIColor *pointColor = [UIColor blackColor];
    //背景颜色
    UIColor *backgroundColor = [UIColor whiteColor];
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor" keysAndValues: @"inputImage", img, @"inputColor0", [CIColor colorWithCGColor:pointColor.CGColor], @"inputColor1", [CIColor colorWithCGColor:backgroundColor.CGColor], nil]; CIImage *qrImage = colorFilter.outputImage;
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    return codeImage;
}
@end
