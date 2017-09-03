//
//  Pi.h
//  Pi-BrainTeaser
//
//  Created by Fangxiang Wang on 9/23/15.
//  Copyright © 2015 Fangxiang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pi : NSObject
@property (strong, nonatomic) NSString *value;

-(NSString *)choosePiAtIndex: (NSInteger) index;
-(NSInteger) piLength;
@end
