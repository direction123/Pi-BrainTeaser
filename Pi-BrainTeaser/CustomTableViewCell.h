//
//  CustomTableViewCell.h
//  Pi-BrainTeaser
//
//  Created by Fangxiang Wang on 9/26/15.
//  Copyright © 2015 Fangxiang Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *swipableUIView;
@property (weak, nonatomic) IBOutlet UIButton *cellShareButton;

@end
