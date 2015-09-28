//
//  myIntegralListView.m
//  master
//
//  Created by jin on 15/9/28.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "myIntegralListView.h"
#import "myIntegralListCellTableViewCell.h"

@implementation myIntegralListView
{
    
    NSMutableDictionary*_dict;//保存section是否展开的字典

}

-(id)initWithFrame:(CGRect)frame{

    if (self=[super initWithFrame:frame]) {
        
        [self createUI];
        
    }

    return self;
}


-(void)createUI{

    _tableview=[[UITableView alloc]initWithFrame:self.bounds];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    [self addSubview:_tableview];
//    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_tableview).with.offset=64;
//        make.left.equalTo(_tableview).with.offset=0;
//        make.right.equalTo(_tableview).with.offset=0;
//        make.bottom.equalTo(_tableview).with.offset=0;
//    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if (_dataArray) {
        
        return _dataArray.count;
    }
    return 0;

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if ([[_showDict objectForKey:[NSString stringWithFormat:@"%lu",section]] integerValue]==0) {
        
        return 0;
    }else{
    
        return 1;
    
    }

}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{


    return 40;

}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    [button setTitle:@"积分" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:16];
    button.tag=section;
    [button addTarget:self action:@selector(show:) forControlEvents:UIControlEventTouchUpInside];
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH, 1)];
    view.backgroundColor=[UIColor lightGrayColor];
    [button addSubview:view];
    return button;

}


-(void)show:(UIButton*)button{

    NSLog(@"%lu",button.tag);
    
    
    if (self.changeDictValue) {
        self.changeDictValue(button.tag);
    }

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    myIntegralListCellTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"myIntegralListCellTableViewCell" owner:nil options:nil]lastObject];
    }
    cell.content=@"sdfdsfdsfdsfdsf";
    [cell reloadData];
    return cell;

}

-(void)reloadData{

    [_tableview reloadData];
    
}


@end
