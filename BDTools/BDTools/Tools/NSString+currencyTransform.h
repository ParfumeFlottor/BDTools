//
//  NSString+currencyTransform.h
//  cashDemo
//
//  Created by 枫叶砂 on 16/8/12.
//  Copyright © 2016年 枫叶砂. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (currencyTransform)

// 保留小数点后两位
- (NSString *)currencyTransformWithCurrencyStyle:(NSNumberFormatterStyle)style;
- (NSString *)currencyTransformDeleteSeparatrixToString;

// 保留小数点后四位
- (NSString *)currencyTransformWithCurrencyStyleForCalculator:(NSNumberFormatterStyle)style;
@end
