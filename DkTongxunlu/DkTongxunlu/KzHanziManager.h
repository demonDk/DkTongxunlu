//
//  KzHanziManager.h
//  KzInside
//
//  Created by 党坤 on 16/8/8.
//  Copyright © 2016年 党坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KzHanziManager : NSObject

@property(nonatomic,strong)NSMutableArray *contactArray;
/**
 *  初始化通讯录
 *
 *  @return 联系人数组
 */
+(NSMutableArray *)initAddressBook;

/**
 *  将汉字转化成英文首字母
 *
 *  @param souce 汉字字符串
 *
 *  @return 英文首字母
 */
+(NSString *)chineseToPrefixLetter:(NSString *)souce;

/**
 *  数组排序
 *  使用说明 userArray数组 数组中是uesr对象 key为对象的某一属性名字
 *  @param contactArray 需要排序的数组
 *  @param sortkey      排序关键字
 */
+(void)sortContactsNameArray:(NSMutableArray *)contactArray key:(NSString *)sortkey;

/**
 *  返回拼音首字母数组
 *
 *  @param contactsArray 联系人数组
 *
 *  @return 拼音首字母数组
 */
+(NSMutableArray *)returnPinyinFirstLetter:(NSMutableArray *)contactsArray;

/**
 *  返回拼音排序结果,返回的是按拼音首字母分好组的数组
 *
 *  @param contactsArray 分好组的有序数组
 */
+(NSMutableArray *)returnSortResult:(NSMutableArray *)contactsArray;

@end
