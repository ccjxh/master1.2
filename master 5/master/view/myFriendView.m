//
//  myFriendView.m
//  master
//
//  Created by jin on 15/9/6.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "myFriendView.h"

@implementation myFriendView

-(instancetype)initWithFrame:(CGRect)frame{

    if (self=[super initWithFrame:frame]) {
        [self createUI];
        
    }
    
    return self;

}


-(void)createUI{

    self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.tableview.dataSource=self;
    self.tableview.delegate=self;
    [self addSubview:self.tableview];

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    NSLog(@"%lu个好友",_dataArray.count);
    return _dataArray.count;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell*Cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!Cell) {
        Cell=[[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
    }
    EMBuddy*body=_dataArray[indexPath.section];
    Cell.textLabel.text=body.username;
    return Cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.friendDidSelect) {
        self.friendDidSelect(indexPath);
    }

}

@end
