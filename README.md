# XWPopMenuVC
弹出动画,发布动画,tabbar弹出,发布按钮弹出选项,类似闲鱼发布按钮动画

项目演示gif动图:
<br>演示效果</br>
![](https://github.com/qxuewei/XWPopMenuVC/raw/master/GIF/XWPopMenuVCDemoGIF.gif)  

使用方法:
1.在发布点击按钮集成操作:
<code><pre>
    XWPopMenuController *vc = [[XWPopMenuController alloc]init];

    //虚化背景
    UIImage *image = [UIImage imageWithCaputureView:self.view];

    vc.backImg = image;

    [self presentViewController:vc animated:NO completion:nil];
</code></pre>

2.每个二级界面实现返回block方法
<code><pre>
    //2.block传值  typedef void(^returnBlock)();
    typedef void(^dismissBlock) ();

    //block
    //block声明属性
    @property (nonatomic, copy) dismissBlock mDismissBlock;
    //block声明方法
    -(void)toDissmissSelf:(dismissBlock)block;
</code></pre>

3.在二级界面返回时
<code><pre>
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
</code></pre>
