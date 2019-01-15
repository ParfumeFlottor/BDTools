//
//  NSString+currencyTransform.m
//  cashDemo
//
//  Created by 枫叶砂 on 16/8/12.
//  Copyright © 2016年 枫叶砂. All rights reserved.
//

#import "NSString+currencyTransform.h"

@implementation NSString (currencyTransform)
- (NSString *)currencyTransformWithCurrencyStyle:(NSNumberFormatterStyle)style
{
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    /**
     *  以几个数字为分割
     */
    [numFormatter setGroupingSize:3];
    [numFormatter setGroupingSeparator:@","];
    [numFormatter setUsesGroupingSeparator:YES];
    [numFormatter setDecimalSeparator:@"."];
    if (!style) {
        [numFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    else{
        [numFormatter setNumberStyle:style];
    }
    /**
     *  小数点后保留位数
     */
    [numFormatter setMaximumFractionDigits:2];
    NSString *priceStr = [numFormatter stringFromNumber:[NSNumber numberWithDouble:[[self currencyTransformDeleteSeparatrixToString] doubleValue]]];
    if ([self isEqualToString:@"-"]) {
        priceStr = self;
    }
    return priceStr;
}
- (NSString *)currencyTransformWithCurrencyStyleForCalculator:(NSNumberFormatterStyle)style
{
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    /**
     *  以几个数字为分割
     */
    [numFormatter setGroupingSize:3];
    [numFormatter setGroupingSeparator:@","];
    [numFormatter setUsesGroupingSeparator:YES];
    [numFormatter setDecimalSeparator:@"."];
    if (!style) {
        [numFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    else{
        [numFormatter setNumberStyle:style];
    }
    /**
     *  小数点后保留位数
     */
    NSArray *array = [self componentsSeparatedByString:@"."];
    CGFloat digits = 0;
    if (array.count>1) {
        NSString *string = [NSString stringWithFormat:@"%@",array[1]];
        digits = string.length > 4? 4:string.length;
    }
    [numFormatter setMinimumFractionDigits:digits];
    NSString *priceStr = [numFormatter stringFromNumber:[NSNumber numberWithDouble:[[self currencyTransformDeleteSeparatrixToString] doubleValue]]];
    return priceStr;
}
- (NSString *)currencyTransformDeleteSeparatrixToString{
    NSString *valueStr = [[NSString alloc]init];
    if([self rangeOfString:@"%"].location != NSNotFound && [self rangeOfString:@","].location != NSNotFound)
    {
         valueStr = [self stringByReplacingOccurrencesOfString:@"," withString:@""];
        valueStr = [valueStr stringByReplacingOccurrencesOfString:@"%" withString:@""];
    }
    else if ([self rangeOfString:@","].location != NSNotFound) {
//        NSArray *array = [self componentsSeparatedByString:@","];
//        for (int i = 0; i < array.count; i++) {
//            valueStr = [valueStr stringByAppendingString:array[i]];
//        }
        valueStr = [self stringByReplacingOccurrencesOfString:@"," withString:@""];
    }
    else if([self rangeOfString:@"%"].location != NSNotFound)
    {
        NSArray *array = [self componentsSeparatedByString:@"%"];
        valueStr = [valueStr stringByAppendingString:[array firstObject]];
    }
    else
    {
        valueStr = self;
    }
    return valueStr;
}
@end
