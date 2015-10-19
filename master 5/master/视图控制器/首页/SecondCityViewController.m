//
//  SecondCityViewController.m
//  master
//
//  Created by jin on 15/10/16.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "SecondCityViewController.h"
#import "findMasterViewController.h"
#import "thirdResignViewController.h"
@interface SecondCityViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SecondCityViewController
{
    NSMutableArray*_dataArray;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"市区选择";
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self request];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)request{

    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    [self flowShow];
    NSString*urlString=[self interfaceFromString:interface_allCityList];
    NSDictionary*dict=@{@"provinceId":[NSString stringWithFormat:@"%lu",self.model.id]};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        [self flowHide];
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
        NSArray*array=[dict objectForKey:@"entities"];
            for (NSInteger i=0; i<array.count; i++) {
                NSDictionary*inforDict=array[i];
                AreaModel*model=[[AreaModel alloc]init];
                [model setValuesForKeysWithDictionary:[inforDict objectForKey:@"dataCatalog"]];
                [_dataArray addObject:model];
            }
            
            [[dataBase share]addCityToDataBase:array Pid:self.model.id];
            [_tableview reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        [self flowHide];

    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell*Cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!Cell) {
        Cell=[[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
    }
    AreaModel*model=_dataArray[indexPath.row];
    Cell.textLabel.text=model.name;
    Cell.textLabel.font=[UIFont systemFontOfSize:15];
    return Cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.count==2) {
        
        AreaModel*model=_dataArray[indexPath.row];
        NSDictionary*dict=@{@"model":model};
        NSNotification*notication=[[NSNotification alloc]initWithName:@"placeChange" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter]postNotification:notication];
        for (UIViewController*viewcontroller in self.navigationController.viewControllers) {
            if ([viewcontroller isKindOfClass:[findMasterViewController class]]==YES) {
                
                [self.navigationController popToViewController:viewcontroller animated:YES];
                
            }
        }
        
    }
    
    if (self.count==3) {
        AreaModel*model=_dataArray[indexPath.row];
        thirdResignViewController*tvc=[[thirdResignViewController alloc]initWithNibName:@"thirdResignViewController" bundle:nil];
        tvc.model=model;
        [self pushWinthAnimation:self.navigationController Viewcontroller:tvc];
        //三层的暂未实现
    }


}

@end
