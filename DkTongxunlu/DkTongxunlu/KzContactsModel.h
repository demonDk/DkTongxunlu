//
//  KzContactsModel.h
//  KzInside
//
//  Created by 党坤 on 16/8/5.
//  Copyright © 2016年 党坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KzContactsModel : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *namePinyin;

//addressBook
@property(nonatomic,copy)NSString *firstName;
@property(nonatomic,copy)NSString *lastName;
@property(nonatomic,copy)NSString *middlename;
@property(nonatomic,copy)NSString *prefix;
@property(nonatomic,copy)NSString *suffix;
@property(nonatomic,copy)NSString *nickname;
@property(nonatomic,copy)NSString *firstnamePhonetic;
@property(nonatomic,copy)NSString *lastnamePhonetic;
@property(nonatomic,copy)NSString *middlenamePhonetic;
@property(nonatomic,copy)NSString *organization;
@property(nonatomic,copy)NSString *jobtitle;
@property(nonatomic,copy)NSString *department;
@property(nonatomic,strong)NSDate *birthday;
@property(nonatomic,copy)NSString *note;
@property(nonatomic,copy)NSString *firstknow;
@property(nonatomic,copy)NSString *lastknow;
@property(nonatomic,strong)NSArray *email;
@property(nonatomic,strong)NSArray *address;
@property(nonatomic,strong)NSArray *dates;
@property(nonatomic,copy)NSString *recordType;
@property(nonatomic,strong)NSArray *instantMessage;
@property(nonatomic,strong)NSArray *phone;
@property(nonatomic,strong)NSArray *url;
@property(nonatomic,strong)NSData *image;

@end

@interface contactsAddress : NSObject
@property(nonatomic,copy)NSString *country;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,copy)NSString *state;
@property(nonatomic,copy)NSString *street;
@property(nonatomic,copy)NSString *zip;
@property(nonatomic,copy)NSString *coutntrycode;

@end

@interface contactsIM : NSObject
@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *service;

@end
