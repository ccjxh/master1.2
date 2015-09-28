//
//  secondAreaViewController.m
//  master
//
//  Created by jin on 15/9/22.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "secondAreaViewController.h"
#import "proviceSelectedViewController.h"
@interface secondAreaViewController ()

@end

@implementation secondAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"市区选择";
    self.automaticallyAdjustsScrollViewInsets=NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)request{

    [self flowShow];
    NSString*urlString=[self interfaceFromString:interface_allCityList];
    NSDictionary*dict=@{@"provinceId":[NSString stringWithFormat:@"%lu",self.model.id]};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        NSArray*array=[dict objectForKey:@"entities"];
        for (NSInteger i=0; i<array.count; i++) {
            NSDictionary*inforDict=array[i];
            AreaModel*model=[[AreaModel alloc]init];
            [model setValuesForKeysWithDictionary:[inforDict objectForKey:@"dataCatalog"]];
            [_dataArray addObject:model];
        }
        [self.tableview reloadData];
        [self flowHide];
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
       
        [self flowHide];

    }];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString*urlString=[self interfaceFromString:interface_updateServicerRegion];
    //regions
    NSMutableArray*array=[self.selectArray lastObject];
    AreaModel*model=_dataArray[indexPath.section];
    [array addObject:model];
    [self.selectArray replaceObjectAtIndex:self.selectArray.count-1 withObject:array];
    NSString*valueString;
    if (self.selectArray.count!=1) {
    for (NSInteger i=0; i<self.selectArray.count; i++) {
        NSArray*tempArray=self.selectArray[i];
        for (NSInteger j=1; j<tempArray.count; j++) {
            AreaModel*tempModel=tempArray[j];
            if (i==0&&j==1) {
                valueString=[NSString stringWithFormat:@"%lu",tempModel.id];
            }else{
                
                valueString=[NSString stringWithFormat:@"%@,%lu",valueString,tempModel.id];
            }
         }
      }
        
    }else{
    
        valueString=[NSString stringWithFormat:@"%lu",model.id];
    }
    NSDictionary*dict=@{@"regions":valueString};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
       [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center" Finish:^{
           
           for (UIViewController*vc in self.navigationController.viewControllers) {
               if ([vc isKindOfClass:[proviceSelectedViewController class]]==YES) {
                   [self.navigationController popToViewController:vc animated:YES];
               }
           }
           
       }];
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
    
}

@end
