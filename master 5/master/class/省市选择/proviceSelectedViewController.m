//
//  proviceSelectedViewController.m
//  master
//
//  Created by jin on 15/9/22.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "proviceSelectedViewController.h"
#import "selectedCityinforView.h"
#import "firstAreaViewController.h"
#import "openCityManagerViewController.h"

@interface proviceSelectedViewController ()

@end

@implementation proviceSelectedViewController
{
    
    NSMutableArray*_dataArray;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"城市管理";
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self initData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData{

    if (!_dataArray) {
        
        _dataArray=[[NSMutableArray alloc]initWithObjects:@"新增开通",@"管理", nil];
        
    }
    
    [_tableview reloadData];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{


    return _dataArray.count;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell*Cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!Cell) {
        Cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell"];
    }
    Cell.textLabel.text=_dataArray[indexPath.section];
    Cell.textLabel.textAlignment=NSTextAlignmentCenter;
    Cell.textLabel.font=[UIFont systemFontOfSize:16];
    return Cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==0) {
        //新增
        firstAreaViewController*fvc=[[firstAreaViewController alloc]initWithNibName:@"firstAreaViewController" bundle:nil];
        fvc.selectArray=self.selectArray;
        [self pushWinthAnimation:self.navigationController Viewcontroller:fvc];
        
    }
    
    if (indexPath.section==1) {
        
        //管理
        openCityManagerViewController*ovc=[[openCityManagerViewController alloc]initWithNibName:@"openCityManagerViewController" bundle:nil];
        ovc.dataArray=self.selectArray;
        [self pushWinthAnimation:self.navigationController Viewcontroller:ovc];

    }

}


@end
