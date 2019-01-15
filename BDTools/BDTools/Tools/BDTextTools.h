//
//  BDTextTools.h
//  BDTools
//
//  Created by 枫叶砂 on 2019/1/15.
//  Copyright © 2019 枫叶砂. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BDTextTools : NSObject

// 限制输入小数点后两位(数字)
+ (BOOL)shouldChangeTextField:(NSString *)text changeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

// 限制输入小数点后四位(数字)
+ (BOOL)calculatorOfCompoundInterestViewShouldChangeTextField:(NSString *)text changeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

+ (BOOL)isBlankString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
