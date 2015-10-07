//
//  MyShareViewController.m
//  master
//
//  Created by jin on 15/9/28.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "MyShareViewController.h"
#import "myShareView.h"

@interface MyShareViewController ()

@end

@implementation MyShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的分享";
    self.view=[[myShareView alloc]initWithFrame:self.view.bounds];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
