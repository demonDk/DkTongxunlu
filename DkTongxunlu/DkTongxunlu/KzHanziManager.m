//
//  KzHanziManager.m
//  KzInside
//
//  Created by 党坤 on 16/8/8.
//  Copyright © 2016年 党坤. All rights reserved.
//

#import "KzHanziManager.h"
#import "pinyin.h"
#import "KzContactsModel.h"
#import <AddressBook/AddressBook.h>

@implementation KzHanziManager

+(NSMutableArray *)initAddressBook
{
    NSMutableArray *resultArray = [NSMutableArray array];
    KzHanziManager *manager = [[KzHanziManager alloc] init];
    resultArray =[manager loadPerson];
    //排序
    [self sortContactsNameArray:resultArray key:@"namePinyin"];
    return resultArray;
}
#pragma mark-生成通讯录
- (NSMutableArray *)loadPerson
{
    _contactArray = [NSMutableArray array];
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error)
                                                 {
                                                     CFErrorRef *error1 = NULL;
                                                     ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
                                                     _contactArray = [self copyAddressBook:addressBook];
                                                 });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
    {
        CFErrorRef *error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
       _contactArray = [self copyAddressBook:addressBook];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            // [hud turnToError:@"没有获取通讯录权限"];
            _contactArray = nil;
        });
    }
    return _contactArray;
}

#pragma mark-获取联系人信息
- (NSMutableArray *)copyAddressBook:(ABAddressBookRef)addressBook
{
    //联系人数组
    NSMutableArray *contactArray = [NSMutableArray array];
    
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    for ( int i = 0; i < numberOfPeople; i++)
    {
        KzContactsModel *contactsModel = [[KzContactsModel alloc] init];
        
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        contactsModel.firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        contactsModel.lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        //读取middlename
        contactsModel.middlename = (__bridge NSString*)ABRecordCopyValue(person, kABPersonMiddleNameProperty);
        //读取prefix前缀
        contactsModel.prefix = (__bridge NSString*)ABRecordCopyValue(person, kABPersonPrefixProperty);
        //读取suffix后缀
        contactsModel.suffix = (__bridge NSString*)ABRecordCopyValue(person, kABPersonSuffixProperty);
        //读取nickname呢称
        contactsModel.nickname = (__bridge NSString*)ABRecordCopyValue(person, kABPersonNicknameProperty);
        //读取firstname拼音音标
        contactsModel.firstnamePhonetic = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty);
        //读取lastname拼音音标
        contactsModel.lastnamePhonetic = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty);
        //读取middlename拼音音标
        contactsModel.middlenamePhonetic = (__bridge NSString*)ABRecordCopyValue(person, kABPersonMiddleNamePhoneticProperty);
        //读取organization公司
        contactsModel.organization = (__bridge NSString*)ABRecordCopyValue(person, kABPersonOrganizationProperty);
        //读取jobtitle工作
        contactsModel.jobtitle = (__bridge NSString*)ABRecordCopyValue(person, kABPersonJobTitleProperty);
        //读取department部门
        contactsModel.department = (__bridge NSString*)ABRecordCopyValue(person, kABPersonDepartmentProperty);
        //读取birthday生日
        contactsModel.birthday = (__bridge NSDate*)ABRecordCopyValue(person, kABPersonBirthdayProperty);
        //读取note备忘录
        contactsModel.note = (__bridge NSString*)ABRecordCopyValue(person, kABPersonNoteProperty);
        //第一次添加该条记录的时间
        contactsModel.firstknow = (__bridge NSString*)ABRecordCopyValue(person, kABPersonCreationDateProperty);
        //        NSLog(@"第一次添加该条记录的时间%@\n",firstknow);
        //最后一次修改該条记录的时间
        contactsModel.lastknow = (__bridge NSString*)ABRecordCopyValue(person, kABPersonModificationDateProperty);
        //        NSLog(@"最后一次修改該条记录的时间%@\n",lastknow);
        
        //获取email多值
        ABMultiValueRef email = ABRecordCopyValue(person, kABPersonEmailProperty);
        int  emailcount = (int) ABMultiValueGetCount(email);
        NSMutableArray *emailArray = [NSMutableArray array];
        for (int x = 0; x < emailcount; x++)
        {
            //获取email Label
            //            NSString* emailLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(email, x));
            //获取email值
            NSString *emailContent = (__bridge NSString*)ABMultiValueCopyValueAtIndex(email, x);
            [emailArray addObject:emailContent];
        }
        contactsModel.email = emailArray;
        //读取地址多值
        NSMutableArray *addressArray = [NSMutableArray array];
        ABMultiValueRef address = ABRecordCopyValue(person, kABPersonAddressProperty);
        int count = (int)ABMultiValueGetCount(address);
        for(int j = 0; j < count; j++)
        {
            //获取地址Label
            //            NSString* addressLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(address, j);
            //获取該label下的地址6属性
            contactsAddress *peopleAddress = [[contactsAddress alloc] init];
            NSDictionary *personaddress =(__bridge NSDictionary*) ABMultiValueCopyValueAtIndex(address, j);
            peopleAddress.country = [personaddress valueForKey:(NSString *)kABPersonAddressCountryKey];
            peopleAddress.city = [personaddress valueForKey:(NSString *)kABPersonAddressCityKey];
            peopleAddress.state = [personaddress valueForKey:(NSString *)kABPersonAddressStateKey];
            peopleAddress.street = [personaddress valueForKey:(NSString *)kABPersonAddressStreetKey];
            peopleAddress.zip = [personaddress valueForKey:(NSString *)kABPersonAddressZIPKey];
            peopleAddress.coutntrycode = [personaddress valueForKey:(NSString *)kABPersonAddressCountryCodeKey];
            [addressArray addObject:peopleAddress];
        }
        contactsModel.address = addressArray;
        
        //获取dates多值
        NSMutableArray *datesArray = [NSMutableArray array];
        ABMultiValueRef dates = ABRecordCopyValue(person, kABPersonDateProperty);
        int datescount = (int)ABMultiValueGetCount(dates);
        for (int y = 0; y < datescount; y++)
        {
            //获取dates Label
            //            NSString* datesLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(dates, y));
            //获取dates值
            NSString *datesContent = (__bridge NSString*)ABMultiValueCopyValueAtIndex(dates, y);
            [datesArray addObject:datesContent];
        }
        contactsModel.dates = datesArray;
        //获取kind值
        //        CFNumberRef recordType = ABRecordCopyValue(person, kABPersonKindProperty);
        //        if (recordType == kABPersonKindOrganization) {
        //            // it's a company
        //            NSLog(@"it's a company\n");
        //        } else {
        //            // it's a person, resource, or room
        //            NSLog(@"it's a person, resource, or room\n");
        //        }
        //        contactsModel.recordType = recordType;
        //获取IM多值
        NSMutableArray *IMArray = [NSMutableArray array];
        ABMultiValueRef instantMessage = ABRecordCopyValue(person, kABPersonInstantMessageProperty);
        for (int l = 1; l < ABMultiValueGetCount(instantMessage); l++)
        {
            //获取IM Label
            //            NSString* instantMessageLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(instantMessage, l);
            //获取該label下的2属性
            contactsIM *contactsIm = [[contactsIM alloc] init];
            NSDictionary* instantMessageContent =(__bridge NSDictionary*) ABMultiValueCopyValueAtIndex(instantMessage, l);
            contactsIm.username = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageUsernameKey];
            contactsIm.service = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageServiceKey];
            [IMArray addObject:contactsIm];
        }
        //读取电话多值
        NSMutableArray *phoneArray = [NSMutableArray array];
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
            //获取电话Label
            //            NSString *personPhoneLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
            //获取该Label下的电话值
            NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
            //            if(k == 0)
            //            {
            //                contactsModel.tellPhone = personPhone;
            //            }
            [phoneArray addObject:personPhone];
        }
        contactsModel.phone = phoneArray;
        
        //获取URL多值
        NSMutableArray *urlArray = [NSMutableArray array];
        ABMultiValueRef url = ABRecordCopyValue(person, kABPersonURLProperty);
        for (int m = 0; m < ABMultiValueGetCount(url); m++)
        {
            //获取电话Label
            //            NSString * urlLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(url, m));
            //获取該Label下的电话值
            NSString *urlContent = (__bridge NSString*)ABMultiValueCopyValueAtIndex(url,m);
            [urlArray addObject:urlContent];
        }
        contactsModel.url = urlArray;
        //读取照片
        NSData *image = (__bridge NSData*)ABPersonCopyImageData(person);
        contactsModel.image = image;
        
        contactsModel.namePinyin = [KzHanziManager chineseToPrefixLetter:contactsModel.name];
        [contactArray addObject:contactsModel];
    }
    return contactArray;
}

#pragma mark-汉字转拼音
+(NSString *)chineseToPrefixLetter:(NSString *)souce
{
    NSString *hanzi = souce;
    NSString *pinyin = nil;
    if(hanzi == nil)
    {
        hanzi = @"";
    }
    //去除两端空格和回车
    hanzi = [hanzi stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //递归过滤指定字符串   RemoveSpecialCharacter
    hanzi = [KzHanziManager RemoveSpecialCharacter:hanzi];
    //判断首字符是否为字母
    NSString *regex = @"[A-Za-z]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    NSString *initialStr = [hanzi length]?[hanzi substringToIndex:1]:@"";
    if ([predicate evaluateWithObject:initialStr])
    {
//        NSLog(@"汉字为 == %@",hanzi);
        //首字母大写
        pinyin = [hanzi capitalizedString] ;
    }else
    {
        if(![hanzi isEqualToString:@""]){
            NSString *pinYinResult = [NSString string];
            for(int j=0;j<hanzi.length;j++){
                NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                                 pinyinFirstLetter([hanzi characterAtIndex:j])]uppercaseString];
                //                    NSLog(@"singlePinyinLetter ==%@",singlePinyinLetter);
                
                pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            pinyin = pinYinResult;
        }else{
            pinyin = @"";
        }

    }
    return pinyin;
}
//过滤指定字符串   里面的指定字符根据自己的需要添加 过滤特殊字符
+(NSString*)RemoveSpecialCharacter:(NSString *)str{
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @",.？、 ~￥#&<>《》()[]{}【】^@/￡¤|§¨「」『』￠￢￣~@#&*（）——+|《》$_€"]];
    if (urgentRange.location != NSNotFound)
    {
        return [self RemoveSpecialCharacter:[str stringByReplacingCharactersInRange:urgentRange withString:@""]];
    }
    return str;
}

#pragma mark-拼音排序
+(void)sortContactsNameArray:(NSMutableArray *)contactArray key:(NSString *)sortkey
{
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:sortkey ascending:YES]];
    [contactArray sortUsingDescriptors:sortDescriptors];
}

#pragma mark-返回拼音首字母数组
+(NSMutableArray *)returnPinyinFirstLetter:(NSMutableArray *)contactsArray
{
    NSString *tempString = nil;
    NSMutableArray *firstArray = [NSMutableArray array];
    for (KzContactsModel *contact in contactsArray) {
        NSString *firstLetter = [contact.namePinyin substringToIndex:1];
        //不同
        if(![tempString isEqualToString:firstLetter])
        {
            // NSLog(@"IndexArray----->%@",pinyin);
            [firstArray addObject:firstLetter];
            tempString = firstLetter;
        }
    }
    return firstArray;
}

#pragma mark-返回拼音排序结果,返回的是按拼音首字母分好组的数组
+(NSMutableArray *)returnSortResult:(NSMutableArray *)contactsArray
{
    NSString *tempString = nil;
    NSMutableArray *resultArray = [NSMutableArray array];
    NSMutableArray *item = [NSMutableArray array];
    for (KzContactsModel *contact in contactsArray) {
        NSString *firstLetter = [contact.namePinyin substringToIndex:1];
        //不同
        if(![tempString isEqualToString:firstLetter])
        {
            //分组
            item = [NSMutableArray array];
            [item addObject:contact];
            [resultArray addObject:item];
            //遍历
            tempString = firstLetter;
        }else
        {//相同
            [item addObject:contact];
        }
    }
    return resultArray;
}
@end
