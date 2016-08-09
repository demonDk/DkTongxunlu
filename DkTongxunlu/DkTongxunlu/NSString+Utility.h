//
//  NSString+Utility.h
//  DkTongxunlu
//
//  Created by 党坤 on 16/8/9.
//  Copyright © 2016年 党坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utility)
/**
 *  判断是否空字符
 *
 *  @param string 被判断字符
 *
 *  @return bool
 */
+ (BOOL)isBlankString:(NSString *)string;
@end
