//
//  ViewController.m
//  PageRequest
//
//  Created by chenao on 17/3/28.
//  Copyright © 2017年 chenao. All rights reserved.
//

#import "ViewController.h"
#import "PageRequest.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[PageRequest pageRequestWithIdentifier:NSStringFromClass([self class]) startPage:0 perPage:10 requestBlock:^(NSInteger pageNo, NSInteger perPage, CompleteBlock  _Nonnull completeBlock) {
            //列表请求方法
    } completeBlock:^(BOOL success, NSString * _Nonnull msg, NSArray * _Nonnull requestData) {
            //请求结果回调
    }] requestPage];
}

- (void)refreshData {
    [PageRequest resetPageWithIdentifier:NSStringFromClass([self class])];
}

- (void)loadMoreData {
    [PageRequest requestPageWithIdentifier:NSStringFromClass([self class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
