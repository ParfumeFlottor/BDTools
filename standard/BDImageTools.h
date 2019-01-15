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

+ (NSData *)resetSizeOfImageDataMethodTwo:(UIImage *)source_image maxSize:(int)maxSize;

+ (UIImage *)codeImageForString:(NSString *)string andLogoImage:(UIImage *)logoImage;
@end

NS_ASSUME_NONNULL_END
