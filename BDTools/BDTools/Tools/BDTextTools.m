//
//  BDTextTools.m
//  BDTools
//
//  Created by 枫叶砂 on 2019/1/15.
//  Copyright © 2019 枫叶砂. All rights reserved.
//

#import "BDTextTools.h"
#define BDDotNumbers     @"0123456789.\n"
#define BDNumbers        @"0123456789\n"

@implementation BDTextTools
+ (BOOL)shouldChangeTextField:(NSString *)text changeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //    当执行删除操作时，不做判断
    if (string.length == 0) {
        return YES;
    }
    NSCharacterSet *cs;
    //    判断"."的位置
    NSUInteger nDotLoc = [text rangeOfString:@"."].location;
    //    判断可输入的字符
    if (NSNotFound == nDotLoc && 0 != range.location) {
        cs = [[NSCharacterSet characterSetWithCharactersInString:BDDotNumbers] invertedSet];
    }
    else {
        cs = [[NSCharacterSet characterSetWithCharactersInString:BDNumbers] invertedSet];
    }
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if (!basicTest) {
        return NO;
    }
    //    当“.”存在时，新添加的字符位置不能大于“.”的位置加2
    if (NSNotFound != nDotLoc && range.location > nDotLoc + 2) {
        return NO;
    }
    return YES;
}
+ (BOOL)calculatorOfCompoundInterestViewShouldChangeTextField:(NSString *)text changeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //    当执行删除操作时，不做判断
    if (string.length == 0) {
        return YES;
    }
    NSCharacterSet *cs;
    //    判断"."的位置
    NSUInteger nDotLoc = [text rangeOfString:@"."].location;
    //    判断可输入的字符
    if (NSNotFound == nDotLoc && 0 != range.location) {
        cs = [[NSCharacterSet characterSetWithCharactersInString:BDDotNumbers] invertedSet];
    }
    else {
        cs = [[NSCharacterSet characterSetWithCharactersInString:BDNumbers] invertedSet];
    }
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if (!basicTest) {
        return NO;
    }
    //    当“.”存在时，新添加的字符位置不能大于“.”的位置加2
    if (NSNotFound != nDotLoc && range.location > nDotLoc + 4) {
        return NO;
    }
    return YES;
}
+ (BOOL)isBlankString:(NSString *)string
{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length==0) {
        return YES;
    }
    return NO;
}
@end
