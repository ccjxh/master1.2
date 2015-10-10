//
//  cityViewController.m
//  master
//
//  Created by jin on 15/5/6.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "cityViewController.h"
#import "headCollectionReusableView.h"

@interface cityViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic)NSMutableArray*dataArray;
@property(nonatomic)NSInteger currentPage;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic)NSArray*AZArray;
@end

@implementation cityViewController
{

    NSMutableArray*_currentArray;//装着已开通城市的数组

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self customNavigation];
    [self CreateFlow];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)customNavigation{

    if (self.type==1) {
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [button addTarget:self action:@selector(certain) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:16];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    }
}

-(void)certain{
    
    NSString*urlString=[self interfaceFromString:interface_updateServicerRegion];
    NSString*str;
    for (NSInteger i=0; i<_currentArray.count; i++) {
        AreaModel*model=_currentArray[i];
        if (model.isselect==YES) {
            if (!str) {
                str=[NSString stringWithFormat:@"%lu",model.id];
            }else{
                str=[NSString stringWithFormat:@"%@,%lu",str,model.id];
            }
        }
    }
    
    
//    [self flowShow];
//    NSDictionary*dict=@{@"regions":str};
//    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
//        NSDictionary*dict=(id)responseObject;
//        [self flowHide];
//       [self.view makeToast:[dict objectForKey:@"msg"] duration:1 position:@"center" Finish:^{
//           if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
//               [self popWithnimation:self.navigationController];
//           }
//       }];
//        
//    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
//        [self flowHide];
//        [self.view makeToast:@"网络异常" duration:1 position:@"center"];
//    }];
}

-(void)initData
{
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    [_dataArray removeAllObjects];
    if (!_currentArray) {
        _currentArray=[[NSMutableArray alloc]init];
    }
    [_currentArray removeAllObjects];
    NSMutableArray*tempArray=[[dataBase share] findWithPid:30000];
    for (NSInteger i=0; i<tempArray.count; i++) {
        AreaModel*model=tempArray[i];
        model.isselect=NO;
        if (self.selectedArray.count!=0) {
           AreaModel*compareModel=self.selectedArray[0];
            if (model.id==compareModel.id) {
                model.isselect=YES;
            }
            
        }
        
        [_currentArray addObject:model];
        
    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat paddingY = 20;
    CGFloat paddingX = 40;
//    layout.sectionInset = UIEdgeInsetsMake(5, paddingX, paddingY, paddingX);
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10,15,10,15);
    self.collectionviwe.collectionViewLayout=layout;
    [self.collectionviwe registerNib:[UINib nibWithNibName:@"cityCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    self.collectionviwe.backgroundColor=COLOR(245, 245, 245, 1);
    [self.collectionviwe registerNib:[UINib nibWithNibName:@"headCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    [_dataArray addObject:@"定位城市"];
    [_dataArray addObject:@"已开通的城市"];
    [_tableview reloadData];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        return [self table:tableView Indexpath:indexPath];
    }
    
    return [self table:tableView WithIndexpath:indexPath];
}

-(UITableViewCell*)table:(UITableView*)table Indexpath:(NSIndexPath*)indexpath{

    UITableViewCell*cell=[table dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle=0;
    UIView*view=(id)[table viewWithTag:30];
    if (view ) {
        [view removeFromSuperview];
    }
    view=[[UIView alloc]initWithFrame:cell.contentView.bounds];
    view.tag=30;
    view.userInteractionEnabled=YES;
    for (NSInteger i=0; i<_currentArray.count; i++) {
        AreaModel*model=_currentArray[i];
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(10+i%3*100, 10+i/3*40, 90, 25)];
        [button setTitle:model.name forState:UIControlStateNormal];
        button.layer.borderColor=[UIColor lightGrayColor].CGColor;
        button.layer.borderWidth=1;
        button.layer.cornerRadius=2;
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:13];
        [button addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
    }
    
    [cell.contentView addSubview:view];
    return cell;

}


-(UITableViewCell*)table:(UITableView*)table WithIndexpath:(NSIndexPath*)indexpath{
    
    UITableViewCell*cell=[table dequeueReusableCellWithIdentifier:@"CELl"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:@"CELL"];
    }
    UIView*view=(id)[table viewWithTag:33];
    if (view ) {
        
        [view removeFromSuperview];
        
    }
    view=[[UIView alloc]initWithFrame:cell.bounds];
    view.userInteractionEnabled=YES;
    view.tag=33;
    if (self.city) {
        cell.textLabel.text=@"";
    UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(10, cell.frame.size.height/2-12, 90, 25)];
    [button setTitle:self.city forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont systemFontOfSize:13];
    button.layer.borderColor=[UIColor lightGrayColor].CGColor;
    button.layer.borderWidth=1;
    button.layer.cornerRadius=3;
    [button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
        
    }else{
        
        cell.textLabel.text=@"当前定位未打开,请稍后重试";
        
    }
    [cell addSubview:view];
    return cell;

}


-(void)selected:(UIButton*)button{

    //选择了
    AreaModel*model1=[[dataBase share]findWithCity:button.titleLabel.text];
    if (self.TBlock) {
        if (self.type==0) {
            self.TBlock(model1);
            [self popWithnimation:self.navigationController];
        }
    }
}

-(NSInteger)accountCity{
    
    NSMutableArray*array=[[dataBase share]findWithPid:30000];
    if (array.count%3==0) {
        return array.count/3*40+20;
    }else{
    
        return (array.count/3+1)*40+20;
    }
}

-(void)select:(UIButton*)button{

    //选择了
    AreaModel*model1=[[dataBase share]findWithCity:button.titleLabel.text];
    
    if (self.TBlock) {
        if (self.type==0) {
            self.TBlock(model1);
            [self popWithnimation:self.navigationController];
        }
    }
}


//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    
//    NSArray*array=@[@"定位的城市",@"已开通的城市"];
//    return array[section];
//    
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section==0) {
//        
//    return 50;
//        
//    }
//    
//    return [self accountCity];
//    
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 30;
//}
//
//-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return _AZArray;
//}
//
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//   
//
//}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 2;
    
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSMutableArray*Array=[[dataBase share]findWithPid:30000];
    if (_dataArray.count!=0) {
        if (section==0) {
            return 1;
        }
        if (section==1) {
            return Array.count;
        }
    }
    
    return 0;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.section==0) {
//        UICollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//        cell.backgroundColor=[UIColor redColor];
//        return cell;
//    }
//    
    
    cityCollectionViewCell*Cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    AreaModel*model=_currentArray[indexPath.row];
    AppDelegate*detelate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    if (indexPath.section==0) {
        if (detelate.city) {
            Cell.name.text=detelate.city;
        }else{
            
        Cell.name.text=@"定位中";
            
        }
        
        Cell.selectImage.hidden=YES;
    }else{
    
        Cell.name.text=model.name;
        if (model.isselect==NO) {
            Cell.selectImage.hidden=YES;
        }else{
            
            Cell.selectImage.hidden=NO;
            
        }
    }
    
    Cell.name.layer.borderColor=COLOR(231, 231, 231, 1).CGColor;
    Cell.name.layer.backgroundColor=[UIColor whiteColor].CGColor;
    Cell.name.layer.borderWidth=1;
    Cell.name.layer.cornerRadius=3;
    return Cell;
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray*array=[[dataBase share]findWithPid:30000];
    AreaModel*model=array[indexPath.row];
    if (self.type==1){
        if (indexPath.section==1) {
            AreaModel*model=_currentArray[indexPath.row];
            if (model.isselect==NO) {
                model.isselect=YES;
            }else{
                
                model.isselect=NO;
            }
            [_currentArray replaceObjectAtIndex:indexPath.row withObject:model];
            [collectionView reloadData];;
            return;
        }
    }
    
    if (self.TBlock) {
        if (self.type==0) {
        if (indexPath.section==0) {
            AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
        if (delegate.city) {
            AreaModel*model1=[[dataBase share]findWithCity:delegate.city];
            self.TBlock(model1);
            [self popWithnimation:self.navigationController];
            return;
        }else{
        
            [self.view makeToast:@"定位中" duration:1 position:@"center"];
            return;
            
            }
        }
        
        if (self.type==0) {
            self.TBlock(model);
            [self popWithnimation:self.navigationController];
            
            }
        }
    }
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    
    
    headCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head" forIndexPath:indexPath];
        NSArray*array=@[@"    GPS定位",@"    已开通的城市"];
    UILabel*label=(id)[collectionView viewWithTag:30+indexPath.section];
    if (label) {
        [label removeFromSuperview];
    }
    label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    label.backgroundColor=[UIColor whiteColor];
    label.textColor=[UIColor lightGrayColor];
    label.font=[UIFont systemFontOfSize:13];
    label.text=array[indexPath.section];
    [view addSubview:label];
        return view;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return CGSizeMake(90, 35);
    }
    if (indexPath.section==1) {
        return CGSizeMake((SCREEN_WIDTH-60)/3, 35);
    }
    return CGSizeZero;
}



-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    
    
    CGSize size={SCREEN_WIDTH,35};
    return size;
}


@end
