//
//  messageView.m
//  master
//
//  Created by jin on 15/9/8.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "messageView.h"
#import "otherMessageTableViewCell.h"

@implementation messageView

-(instancetype)initWithFrame:(CGRect)frame{

    if (self=[super initWithFrame:frame]) {
        
        [self createTableview];
        
    }
    
    return self;

}

-(void)createTableview{

    self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.tableview.separatorStyle=0;
    [self addSubview:self.tableview];

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return _dataArray.count;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    otherMessageTableViewCell*Cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!Cell) {
       Cell=[[[NSBundle mainBundle]loadNibNamed:@"otherMessageTableViewCell" owner:nil options:nil]lastObject];
    }
    Cell.selectionStyle=0;
    EMMessage*message=_dataArray[indexPath.section];
    Cell.model=message;
    [Cell reloadData];
    return Cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    return 60;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    label.backgroundColor=self.tableview.backgroundColor;
    return label;

}


@end
