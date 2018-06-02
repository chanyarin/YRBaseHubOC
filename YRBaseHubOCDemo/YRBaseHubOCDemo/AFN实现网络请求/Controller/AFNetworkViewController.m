//
//  AFNetworkViewController.m
//  YRBaseHubOCDemo
//
//  Created by hwkj on 2018/6/2.
//  Copyright © 2018年 Yarin. All rights reserved.
//

#import "AFNetworkViewController.h"
#import "XXGKBannerRequest.h"

@interface AFNetworkViewController ()

@end

@implementation AFNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)testNetwork:(UIButton *)sender {
    XXGKBannerRequest *request = [[XXGKBannerRequest alloc] init];
    [request requestWithSuccess:^(NSInteger errCode, NSDictionary *responseDict, id model) {
        
    } failure:^(NSError *error) {
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
