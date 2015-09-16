//
//  startTimeandcompensationTableViewCell.m
//  master
//
//  Created by jin on 15/9/16.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "startTimeandcompensationTableViewCell.h"

@implementation startTimeandcompensationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setContentWithModel:(NSString*)content{

    self.textview.text=content;
    self.textviewHeight.constant=[self heightForTextView:self.textview WithText:content];

}
@end
