//
//  NSObject+tool.m
//  master
//
//  Created by jin on 15/8/6.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "NSObject+tool.h"
#import "PhotoBroswerVC.h"
@implementation NSObject (tool)


//技能
-(UITableViewCell*)getSkillCellWithTableview:(UITableView*)tableView  SkillArray:(NSMutableArray*)skillArray{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"CEll"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"CEll"];
    }
    if (skillArray.count==0) {
        cell.detailTextLabel.text=@"  技能";
        cell.detailTextLabel.textColor=[UIColor lightGrayColor];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:16];
        return cell;
    }
    UIView*view=(id)[cell.contentView viewWithTag:31];
    if (view) {
        [view removeFromSuperview];
    }
    
    view=[[UIView alloc]initWithFrame:cell.bounds];
    view.tag=31;
    cell.detailTextLabel.text=@"";
    UILabel*name=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
    name.textColor=[UIColor lightGrayColor];
    name.text=@"专业技能";
    if ([[UIDevice currentDevice].systemVersion integerValue]>=8) {
        name.text=@" 专业技能";
    }
    name.font=[UIFont systemFontOfSize:16];
    [view addSubview:name];
    
    cell.textLabel.textColor=[UIColor lightGrayColor];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    NSInteger orginX = 0;
    for (NSInteger i=0; i<skillArray.count; i++) {
        skillModel*model=skillArray[i];
        NSInteger width=(SCREEN_WIDTH-110-30)/3;
        UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-orginX-30-model.name.length*12-5, 5+i/3*40,model.name.length*12+5, 25)];
        orginX+=model.name.length*12+10;
        if (i!=0&&i%3==0) {
            orginX=0;
        }
        width=label.frame.origin.x+label.frame.size.width+5;
        label.text=model.name;
        label.tag=12;
        label.font=[UIFont systemFontOfSize:12];
        label.layer.borderWidth=1;
        label.numberOfLines=0;
        label.layer.cornerRadius=5;
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=[UIColor lightGrayColor];
        label.layer.backgroundColor=[UIColor whiteColor].CGColor;
        label.layer.borderColor=[UIColor lightGrayColor].CGColor;
        label.layer.borderWidth=1;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        label.enabled=YES;
        label.userInteractionEnabled=NO;
        [view addSubview:label];
        [cell.contentView addSubview:view];
    }
    return cell;
}



//计算技能的高度
-(CGFloat)accountSkillWithAllSkill:(NSMutableArray*)skillArray{
    
    if (skillArray.count==0) {
        return 30;
    }
    else
    {
        if (skillArray.count%3==0) {
            
            return skillArray.count/3*30+5;
        }
        else
        {
            return (skillArray.count/3+1)*30+5;
        }
    }
}


//计算图片高度
-(CGFloat)accountPictureFromArray:(NSMutableArray*)pictureArray{
    
    CGFloat height;
    NSInteger width=(SCREEN_WIDTH-40)/4;
    if (pictureArray.count==0) {
        return 44;
    }
    if (pictureArray.count%4==0) {
        height=pictureArray.count/4*width+20;
    }
    else{
        height=(pictureArray.count/4+1)*width+20;
    }
    return height;
    
}


//网络图片图片展示
-(void)displayPhotosWithIndex:(NSInteger)index Tilte:(NSString*)title describe:(NSString*)describe ShowViewcontroller:(UIViewController*)vc UrlSarray:(NSMutableArray*)UrlArray ImageView:(UIImageView*)imageview{
    
    [PhotoBroswerVC show:vc type:3 index:index photoModelBlock:^NSArray *{
    NSMutableArray*Array=[[NSMutableArray alloc]init];
    NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:Array.count];
    for (NSUInteger i = 0; i< UrlArray.count; i++) {
        
        PhotoModel *pbModel=[[PhotoModel alloc] init];
        pbModel.mid = i + 1;
        pbModel.title =title;
        pbModel.desc = describe;
        pbModel.image_HD_U = UrlArray[i];
        //源frame
//        projectCaseCollectionViewCell*cell=(projectCaseCollectionViewCell*)[collectionView  dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath] ;
//        //            UIImageView *imageV =(UIImageView *) weakSelf.contentView.subviews[i];
        pbModel.sourceImageView = imageview;
        [modelsM addObject:pbModel];
    }
    
        return modelsM;
    }];
}





@end
