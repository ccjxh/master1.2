//
//  myIntegralListView.m
//  master
//
//  Created by jin on 15/9/28.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "myIntegralListView.h"
#import "myIntegralListCellTableViewCell.h"
#import "myIntrgalListModel.h"
#import "IntegralDetailTableViewHeaderCell.h"

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

    _tableview=[[SLExpandableTableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.backgroundColor=COLOR(237, 238, 240, 1);
    _tableview.separatorStyle=0;
    [self addSubview:_tableview];
    [_tableview registerClass:[IntegralDetailTableViewHeaderCell class] forCellReuseIdentifier:@"SuperCell"];
    [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SubCell"];

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

//    if ([[_showDict objectForKey:[NSString stringWithFormat:@"%lu",section]] integerValue]==0) {
//        
//        return 1;
//    }else{
//    
//        return 2;
//    
//    }
    return 2;

}


//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//
//
//    return 40;
//
//}
//
//
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
//    myIntrgalListModel*model=_dataArray[section];
//    [button setTitle:model.type forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    button.titleLabel.font=[UIFont systemFontOfSize:16];
//    button.tag=section;
//    button.titleLabel.textAlignment=NSTextAlignmentLeft;
//    [button addTarget:self action:@selector(show:) forControlEvents:UIControlEventTouchUpInside];
//    return button;
//
//}


-(void)show:(UIButton*)button{

    if (self.changeDictValue) {
        self.changeDictValue(button.tag);
    }

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    myIntrgalListModel*model=_dataArray[indexPath.section];
    static NSString *cellIdentifier = @"SubCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = COLOR(237, 238, 240, 1);
//    IntegralLogEntity *entity = _dataSource[indexPath.section];
    cell.textLabel.text = [NSString stringWithFormat:@"%@:%@",model.type,model.readme];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.textColor = COLOR(109, 109, 109, 1);
    return cell;

}

-(void)reloadData{

    [_tableview reloadData];
    
}


#pragma mark - SLExpandableTableViewDatasource

- (BOOL)tableView:(SLExpandableTableView *)tableView canExpandSection:(NSInteger)section
{
    return YES;
}

- (BOOL)tableView:(SLExpandableTableView *)tableView needsToDownloadDataForExpandableSection:(NSInteger)section
{
    return NO;
}

- (UITableViewCell<UIExpandingTableViewCell> *)tableView:(SLExpandableTableView *)tableView expandingCellForSection:(NSInteger)section
{
    myIntrgalListModel*model=_dataArray[section];
    static NSString *CellIdentifier = @"SuperCell";
    IntegralDetailTableViewHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[IntegralDetailTableViewHeaderCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.date=model.createTime;
    cell.count=[NSString stringWithFormat:@"%lu积分",model.value];
    cell.expandable = YES;
    cell.selectionStyle=0;
    return cell;

    
}

#pragma mark - SLExpandableTableViewDelegate

- (void)tableView:(SLExpandableTableView *)tableView downloadDataForExpandableSection:(NSInteger)section
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.expandableSections addIndex:section];
        [tableView expandSection:section animated:YES];
    });
}

- (void)tableView:(SLExpandableTableView *)tableView didCollapseSection:(NSUInteger)section animated:(BOOL)animated
{
//    [self.expandableSections removeIndex:section];
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    myIntrgalListModel*model=_dataArray[indexPath.section];
    if (indexPath.row == 0) {   //父cell高
        return 44;
    }else{                      //子cell高
//        IntegralLogEntity *entity = _dataSource[indexPath.section];
//        NSString *word = entity.describe;
//        DDLogVerbose(@"word:%@", word);
        CGSize size = [model.readme sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(tableView.frame.size.width - 40, INT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        return MAX(size.height, 44);
        
        
    }
}


#pragma mark - UITableViewDataSource

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return self.sectionsArray.count;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    NSArray *dataArray = self.sectionsArray[section];
//    return dataArray.count + 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    NSArray *dataArray = self.sectionsArray[indexPath.section];
//    cell.textLabel.text = dataArray[indexPath.row - 1];
//    
//    return cell;
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
//        [self.sectionsArray removeObjectAtIndex:indexPath.section];
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



@end
