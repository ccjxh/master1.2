//
//  mySelfMessageTableViewCell.m
//  master
//
//  Created by jin on 15/9/9.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "mySelfMessageTableViewCell.h"

@implementation mySelfMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)reloadData{

    
    NSString*temp=((EMTextMessageBody*)self.model.messageBodies.firstObject).text;
    NSDate*date=[[NSDate alloc]initWithTimeIntervalSince1970:(self.model.timestamp-1)/1000];
    NSDateFormatter*forrmater=[[NSDateFormatter alloc]init];
    [forrmater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.date.text=[forrmater stringFromDate:date];
   
     self.backImahe.image= [[UIImage imageNamed:@"bubbleSomeone.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14];
    if (temp.length<=13) {
        
        self.imageWidth.constant=temp.length*15+25;
        self.contentWidth.constant=self.imageWidth.constant-10;
        
    }else{
        
        self.imageWidth.constant=13*15+25;
        self.contentWidth.constant=self.imageWidth.constant-10;
        self.backHeight.constant=[self accountStringHeightFromString:temp Width:13*15+15]+10;
        self.contentHeight.constant=self.backHeight.constant;
        
    }
    
     self.content.text=temp;
}


@end