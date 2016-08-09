//
//  ViewController.m
//  DkTongxunlu
//
//  Created by 党坤 on 16/8/9.
//  Copyright © 2016年 党坤. All rights reserved.
//

#import "ViewController.h"
#import "KzPhoneBookVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clickButton.frame = CGRectMake(100, 100, 100, 50);
    [clickButton setTitle:@"通讯录" forState:UIControlStateNormal];
    [clickButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [clickButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clickButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buttonClick
{
    KzPhoneBookVC *contact = [[KzPhoneBookVC alloc] init];
    [self presentViewController:contact animated:YES completion:nil];
}
@end
