//
//  ViewController.h
//  How to Parse HTML on iOS
//
//  Created by Mark MaMian on 2016/10/6.
//  Copyright © 2016年 Mark MaMian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *objects;
@property (strong, nonatomic) NSMutableArray *contributors;
@end

