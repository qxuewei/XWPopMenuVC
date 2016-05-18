//
//  OneViewController.m
//  XWPopMenuVCDemo
//
//  Created by 邱学伟 on 16/5/17.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

#import "OneViewController.h"

@interface OneViewController ()

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor redColor]];
    
    //添加取消按钮->
    [self addCancelBtn];
}

//添加取消按钮->
-(void)addCancelBtn{
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelBtn setFrame:CGRectMake(20, 20, 40, 30)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.view addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
}
//取消按钮点击方法
-(void)cancelClick{
    [self finishPublish];
}


#pragma mark - 完成发布
//完成发布
-(void)finishPublish{
    //2.block传值
    if (self.mDismissBlock != nil) {
        self.mDismissBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//block声明方法
-(void)toDissmissSelf:(dismissBlock)block{
    self.mDismissBlock = block;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
