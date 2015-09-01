//
//  findWorkDetailViewController.m
//  master
//
//  Created by jin on 15/8/26.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "findWorkDetailViewController.h"
#import "findWorkDetail.h"
@interface findWorkDetailViewController ()

@end

@implementation findWorkDetailViewController
{
    findWorkDetailModel*detailModel;
    findWorkDetail*view;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self CreateFlow];
    [self requestInformation];
    
    
            // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


-(void)initUI{

    view=[[findWorkDetail alloc]init];
    if (!self.title) {
        
        self.title=@"招工详情";

    }
    __weak typeof(self)WeSelf=self;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    view.deleBlock=^(NSInteger ID){
    
        [WeSelf requestTokenWithID:ID];
    
    };
    view.type=self.type;
    view.reportBlock=^{
        
        [WeSelf report];
    
    };
    self.view=view;
   
}


-(void)report{

    opinionViewController*opinion=[[opinionViewController alloc]initWithNibName:@"opinionViewController" bundle:nil];
    opinion.title=@"举报";
    opinion.limitCount=200;
    opinion.type=1;
    opinion.contentBlock=^(NSString*content){
    
        NSString*urlString=[self interfaceFromString:interface_reportInfo];
        NSDictionary*dict=@{@"problem":content,@"checkUser.id":[NSString stringWithFormat:@"%lu",self.id]};
        [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary*dict=(NSDictionary*)responseObject;
            if ([[dict objectForKey:@"rspCode"] intValue]==200) {
                [self.view makeToast:@"提交成功" duration:1 position:@"center"];
            }else{
                [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center"];
            }
            
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            
           
            [self.view makeToast:@"网络异常" duration:1 position:@"center"];
        }];
    };
    
    [self pushWinthAnimation:self.navigationController Viewcontroller:opinion];

}


-(void)deleWithID:(NSInteger)ID{

    NSString*urlString=[self interfaceFromString:interface_delePublic];
    NSDictionary*dict=@{@"token":self.token,@"id":[NSString stringWithFormat:@"%lu",ID]};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        [self flowHide];
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
        [self.view makeToast:@"删除成功" duration:1 position:@"center" Finish:^{
            
            if (self.removeBlock) {
                self.removeBlock(ID);
            }
            
            [self popWithnimation:self.navigationController];
        }];
        
        }else{
            
            NSString*str=[[dict objectForKey:@"msg"] componentsSeparatedByString:@" "][0];
            [self.view makeToast:[NSString stringWithFormat:@"网络异常%@",str] duration:1 position:@"center"];
            
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
        [self flowHide];
        [self.view makeToast:@"网络异常" duration:1 position:@"center"];
        
    }];

}


-(void)requestInformation{
    
    [self flowShow];
   
    NSString*urlstring=[self interfaceFromString:interface_findWorkDetail];
    NSDictionary*dict=@{@"id":[NSString stringWithFormat:@"%lu",self.id]};
    
    [[httpManager share]POST:urlstring parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        [self flowHide];
        
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            NSDictionary*inforDict=[[dict objectForKey:@"entity"] objectForKey:@"project"];
            detailModel=[[findWorkDetailModel alloc]init];
            [detailModel setValuesForKeysWithDictionary:inforDict];
            view.model=detailModel;
            [view.tableview reloadData];
            
        }else{
        
            NSString*temp=[[dict objectForKey:@"msg"]componentsSeparatedByString:@"."][0];
            
            [self.view makeToast:[NSString stringWithFormat:@"出现异常%@",temp] duration:1 position:@"center"];
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
        
        [self flowHide];
        [self.view makeToast:@"网络异常" duration:1 position:@"center"];
        
    }];

}


-(void)requestTokenWithID:(NSInteger)ID{
    
    NSString*urlString=[self interfaceFromString:interface_token];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        self.token= [[dict objectForKey:@"properties"] objectForKey:@"token"];
        [self deleWithID:ID];
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
    
}


@end
