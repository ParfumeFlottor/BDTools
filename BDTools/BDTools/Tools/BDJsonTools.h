//
//  BDJsonTools.h
//  BDTools
//
//  Created by 枫叶砂 on 2019/1/15.
//  Copyright © 2019 枫叶砂. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BDJsonTools : NSObject
//字典 数组转json
+ (NSString*)dataToJson:(id)theData;
/*
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end

NS_ASSUME_NONNULL_END
