//
//  KzContactsModel.m
//  KzInside
//
//  Created by 党坤 on 16/8/5.
//  Copyright © 2016年 党坤. All rights reserved.
//

#import "KzContactsModel.h"
#import "NSString+Utility.h"

@implementation KzContactsModel

-(void)setFirstName:(NSString *)firstName
{
    _firstName = [self checkIsBlack:firstName];
}

-(void)setLastName:(NSString *)lastName
{
    _lastName = [self checkIsBlack:lastName];
}

-(void)setMiddlename:(NSString *)middlename
{
    _middlename = [self checkIsBlack:middlename];
}

-(void)setNickname:(NSString *)nickname
{
    _nickname = [self checkIsBlack:nickname];
}

-(void)setOrganization:(NSString *)organization
{
    _organization = [self checkIsBlack:organization];
}

-(NSString *)name
{
    if(![[NSString stringWithFormat:@"%@%@%@%@",self.lastName,self.firstName,self.middlename,self.nickname] isEqualToString:@""]){
        return [NSString stringWithFormat:@"%@%@%@%@",self.lastName,self.firstName,self.middlename,self.nickname];
    }else
    {
        return [NSString stringWithFormat:@"%@",self.organization];
    }
}

-(NSString *)checkIsBlack:(NSString *)content
{
    if ([NSString isBlankString:content]) {
        return @"";
    }else
    {
        return content;
    }
}

@end



@implementation contactsAddress

@end

@implementation contactsIM

@end
