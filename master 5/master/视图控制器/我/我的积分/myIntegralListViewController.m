//
//  myIntegralListViewController.m
//  master
//
//  Created by jin on 15/9/28.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "myIntegralListViewController.h"
#import "myIntegralListView.h"

@interface myIntegralListViewController ()

@end

@implementation myIntegralListViewController
{

    myIntegralListView*_listView;
    NSMutableDictionary*_dict;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的积分";
    [self createUI];
    [self request];
    [self CreateFlow];
    // Do any additional setup after loading the view.
}

-(void)createUI{

    _listView=[[myIntegralListView alloc]initWithFrame:self.view.bounds];
    __weak typeof(NSMutableDictionary*)weakDict=_dict;
    __weak typeof (myIntegralListView*)weakListview=_listView;
    _listView.changeDictValue=^(NSInteger index){
    
        if ([[weakDict objectForKey:[NSString stringWithFormat:@"%lu",index]]integerValue]==0) {
            [weakDict setObject:@"1" forKey:[NSString stringWithFormat:@"%lu",index]];
        }else{
        
            [weakDict setObject:@"0" forKey:[NSString stringWithFormat:@"%lu",index]];

        }
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:index];
        [weakListview.tableview reloadData];
    };
    self.view=_listView;
}


//网络请求
-(void)request{

    NSMutableArray*Array=[[NSMutableArray alloc]initWithObjects:@"fdsf",@"ffsdf", nil];
    _listView.dataArray=Array;
    _dict=[[NSMutableDictionary alloc]init];
    for ( NSInteger i=0; i<Array.count; i++) {
        [_dict setObject:@"0" forKey:[NSString stringWithFormat:@"%lu",i]];
    }
    _listView.showDict=_dict;
    [_listView reloadData];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
