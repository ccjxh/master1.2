//
//  otherMessageTableViewCell.m
//  master
//
//  Created by jin on 15/9/8.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "otherMessageTableViewCell.h"

@implementation otherMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)reloadData{

    NSDate*date=[[NSDate alloc]initWithTimeIntervalSinceNow:self.model.timestamp];
    NSDateFormatter*forrmater=[[NSDateFormatter alloc]init];
    [forrmater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.date.text=[forrmater stringFromDate:date];
    self.content.text=((EMTextMessageBody*)self.model.messageBodies.firstObject).text;

}


@end
