//
//  NSString+Utility.m
//  DkTongxunlu
//
//  Created by 党坤 on 16/8/9.
//  Copyright © 2016年 党坤. All rights reserved.
//

#import "NSString+Utility.h"

@implementation NSString (Utility)
+ (BOOL)isBlankString:(NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    if ([string isEqual:[NSNull null]]) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([string isEqualToString:@"<null>"]){
        return YES;
    }
    return NO;
}
@end
