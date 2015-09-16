//
//  myServiceView.m
//  master
//
//  Created by jin on 15/9/14.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "myServiceView.h"
#import "startTimeandcompensationTableViewCell.h"

@implementation myServiceView
{
    UITableView*_tableview;
    myserviceDataSouce*_dataSource;
}
-(instancetype)initWithDatasource:(myserviceDataSouce *)dataSource{

    if (self=[super init]) {
        _dataSource=dataSource;
        [self createUI];
    }
    
    return self;
}


-(void)createUI{

    _tableview=[[UITableView alloc]init];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    [self addSubview:_tableview];
    NSArray*constraint=[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_tableview]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableview)];
    NSArray*constraint1=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_tableview]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableview)];
    [self addConstraints:constraint];
    [self addConstraints:constraint1];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

        return _dataSource.modelArray.count;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;

}


@end
