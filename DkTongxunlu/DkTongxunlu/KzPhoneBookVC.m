//
//  KzPhoneBookVC.m
//  KzInside
//
//  Created by 党坤 on 16/8/5.
//  Copyright © 2016年 党坤. All rights reserved.
//

#import "KzPhoneBookVC.h"
#import "KzContactsModel.h"
#import "KzHanziManager.h"

@interface KzPhoneBookVC ()<UITableViewDelegate,UITableViewDataSource>
{
    //手机联系人数组列表
    NSMutableArray *PhoneList;
    //排序后的数组
    NSMutableArray *resultList;
    //音标数组
    NSMutableArray *contactsFirstTicList;
}

@end

@implementation KzPhoneBookVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableview];
    
    PhoneList = [NSMutableArray array];
    contactsFirstTicList = [NSMutableArray array];
    resultList = [NSMutableArray array];
   
    PhoneList = [KzHanziManager initAddressBook:self];//排序后的联系人数组  一个数组
    contactsFirstTicList = [KzHanziManager returnPinyinFirstLetter:PhoneList];//拼音首字母数组
    resultList = [KzHanziManager returnSortResult:PhoneList];//按拼音首字母分块的有序数组
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)initTableview
{
    UITableView *tableview = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
}

#pragma mark-tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[resultList objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"str";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 28, 28)];
    imageview.tag = 11;
    [cell.contentView addSubview:imageview];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, 200, 15)];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:13.0];
    nameLabel.tag = 12;
    [cell.contentView addSubview:nameLabel];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 22, 200, 15)];
    phoneLabel.textColor = [UIColor lightGrayColor];
    phoneLabel.tag = 13;
    phoneLabel.font = [UIFont systemFontOfSize:12.0];
    [cell.contentView addSubview:phoneLabel];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return resultList.count;
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return contactsFirstTicList;
}

#pragma mark-tableview delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    KzContactsModel  *contacts = [[resultList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    for (UIView *childView in cell.contentView.subviews) {
        if(childView.tag == 11)
        {//头像
            UIImageView *imageview = (UIImageView *)childView;
            imageview.image = [UIImage imageWithData:contacts.image];
        }
        if(childView.tag == 12)
        {//名字
            UILabel *nameLabel = (UILabel *)childView;
            nameLabel.text = contacts.name;
        }
        if(childView.tag == 13)
        {//电话号码
            UILabel *phoneLabel = (UILabel *)childView;
            phoneLabel.text = [contacts.phone objectAtIndex:0];
        }
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(contactsFirstTicList.count !=0){
        UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
        headview.backgroundColor = [UIColor groupTableViewBackgroundColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 20)];
        titleLabel.text = [contactsFirstTicList objectAtIndex:section];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:13.0];
        [headview addSubview:titleLabel];
        return headview;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    KzContactsModel *contacts = [[resultList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@\n%@",contacts.name,[contacts.phone objectAtIndex:0]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

@end
