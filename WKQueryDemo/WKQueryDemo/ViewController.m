//
//  ViewController.m
//  WKQueryDemo
//
//  Created by walker on 2018/12/29.
//  Copyright © 2018 walker. All rights reserved.
//

#import "ViewController.h"
#import "WKQuery.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    /*查询*/
    QUERY.create(@"",@{}).where(@"").equal(@(1),YES).w_and(@"").equal(@"",YES).length(-1).client(12);
    /*更新*/
    QUERY.create(@"",@{}).where(@"pk").equal(@{},YES).upsert(@"").setValue(@"").client(12);
    /*插入*/
    QUERY.create(@"",@{}).where(@"").equal(@"",YES).insert(@"",@"").client(12);
}


@end
