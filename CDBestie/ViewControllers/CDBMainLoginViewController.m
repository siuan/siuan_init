//
//  CDBMainLoginViewController.m
//  laixin
//
//  Created by apple on 13-12-26.
//  Copyright (c) 2013年 jijia. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "CDBMainLoginViewController.h"
//#import "LXAPIController.h"
#import "CDBAppDelegate.h"
#import "CDBestieDefines.h"
#import "CDBCompleteUserInfoViewController.h"
#import "SVProgressHUD.h"
#import "DataHelper.h"

#import "MYIntroductionView.h"

#define kNumbersPeriod  @"0123456789"
#define MaxLen 11

@interface CDBMainLoginViewController ()<UITextFieldDelegate>
{
    User *myUserInfo;
}
@end

@implementation CDBMainLoginViewController
@synthesize appName;
@synthesize phoneNumberText;
@synthesize identCodeText;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark  VIEW

- (void)viewDidLoad
{
    [super viewDidLoad];
    [phoneNumberText setDelegate:self];
    [identCodeText setDelegate:self];
    [appName setText:@"川妹妹"];
    [appName sizeToFit];
    UITapGestureRecognizer * tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapges];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //向导页背景上 添加图片的方式 添加向导页(lewcok)
#if (0)
    //读取沙盒数据
    NSUserDefaults * settings1 = [NSUserDefaults standardUserDefaults];
    NSString *key1 = [NSString stringWithFormat:@"is_first"];
    NSString *value = [settings1 objectForKey:key1];
    //if (!value)  //如果没有数据
    {
        //STEP 1 Construct Panels
        MYIntroductionPanel *panel = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"SampleImage1"] description:@"Welcome to MYIntroductionView, your 100 percent customizable interface for introductions and tutorials! Simply add a few classes to your project, and you are ready to go!"];
        
        //You may also add in a title for each panel
        MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"SampleImage2"] title:@"Your Ticket!" description:@"MYIntroductionView is your ticket to a great tutorial or introduction!"];
        
        //STEP 2 Create IntroductionView
        
        /*A standard version*/
        //MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) headerImage:[UIImage imageNamed:@"SampleHeaderImage.png"] panels:@[panel, panel2]];
        
        
        /*A version with no header (ala "Path")*/
        //MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) panels:@[panel, panel2]];
        
        /*A more customized version*/
        MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) headerText:@"欢迎使用来信~" panels:@[panel, panel2,panel] languageDirection:MYLanguageDirectionLeftToRight];
        [introductionView setBackgroundImage:[UIImage imageNamed:@"SampleBackground"]];
        
        
        //Set delegate to self for callbacks (optional)
        introductionView.delegate = self;
        
        //STEP 3: Show introduction view
        [introductionView showInView:self.view];
        
        //写入数据
        NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
        NSString * key = [NSString stringWithFormat:@"is_first"];
        [setting setObject:[NSString stringWithFormat:@"false"] forKey:key];
        [setting synchronize];
    }
#endif
    
    
    //几张图片来形成引导页 判断是否第一次 并做动画效果(lewcok)
    //读取沙盒数据
    NSUserDefaults * settings1 = [NSUserDefaults standardUserDefaults];
    NSString *key1 = [NSString stringWithFormat:@"is_first"];
    NSString *value = [settings1 objectForKey:key1];
    //if (!value)  //如果没有数据 是否显示引导的开关 为测试先关闭(lewcok)
    {
        
        // Do any additional setup after loading the view, typically from a nib.
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds)*3, CGRectGetHeight(self.view.bounds));
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.bounces = NO;
        for (int i=0; i<3; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds)*i, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i+1]];
            if(2  == i){
                
                
                CGRect frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-90, [UIScreen mainScreen].bounds.size.height*11/12-50, 180, 50);
                UIButton *goToMVBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                goToMVBtn.backgroundColor = [UIColor clearColor];
                //[goToMVBtn setTitle:@"进 入 来 信" forState:UIControlStateNormal];
                [goToMVBtn setBackgroundImage:[UIImage imageNamed:@"click_before.png"] forState:UIControlStateNormal];
                //[myBtn setTitle:@"xxx" forState:UIControlStateNormal];
                //[goToMVBtn setBackgroundImage:[UIImage imageNamed:@"click.png"] forState:UIControlStateSelected];
                goToMVBtn.frame = frame;
                [goToMVBtn addTarget:self action:@selector(startLX) forControlEvents:UIControlEventTouchUpInside];
                imageView.userInteractionEnabled=YES;
                [imageView addSubview:goToMVBtn];
                
            }
            
            [scrollView addSubview:imageView];
        }
        /*
         UIImageView *smallImageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, CGRectGetHeight(self.view.bounds)/4, CGRectGetWidth(self.view.bounds)/2, CGRectGetHeight(self.view.bounds)/2)];
         smallImageView.userInteractionEnabled = YES;
         smallImageView.backgroundColor = [UIColor redColor];
         [self.view addSubview:smallImageView];
         
         
         
         smallScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(smallImageView.bounds), CGRectGetHeight(smallImageView.bounds))];
         smallScrollView.scrollEnabled = NO;
         smallScrollView.delegate = self;
         smallScrollView.contentSize = CGSizeMake(CGRectGetWidth(smallImageView.bounds)*3, CGRectGetHeight(smallImageView.bounds));
         smallScrollView.pagingEnabled = YES;
         smallScrollView.bounces = NO;
         for (int i=0; i<3; i++) {
         UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(smallImageView.bounds)*i, 0, CGRectGetWidth(smallImageView.bounds), CGRectGetHeight(smallImageView.bounds))];
         imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i+1]];
         [smallScrollView addSubview:imageView];
         }
         [smallImageView addSubview:smallScrollView];
         */
        [self.view addSubview:scrollView];
        //[self.view bringSubviewToFront:smallImageView];
        
        //写入数据
        NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
        NSString * key = [NSString stringWithFormat:@"is_first"];
        [setting setObject:[NSString stringWithFormat:@"false"] forKey:key];
        [setting synchronize];
    }
    
    
}


-(void)startLX
{
    //XCJMainLoginViewController *controller = [[XCJMainLoginViewController alloc] init];
    //[self presentModalViewController:controller animated:YES];
    
    CATransition * animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 1.0;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];//动画快慢
    animation.type = @"rippleEffect";//水滴效果
    animation.subtype = kCATransitionFade;//褪色效果
    [scrollView.superview.layer addAnimation:animation forKey:@"animation"];
    [scrollView removeFromSuperview];
    /*
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *sessionid = [defaults objectForKey:@"SESSION_ID"];
    if (sessionid) {
        [self dismissViewControllerAnimated:NO completion:^{}];
    }
     */
    //    /** type
    //     *
    //     *  各种动画效果  其中除了'fade', `moveIn', `push' , `reveal' ,其他属于似有的API(我是这么认为
    //
    //     的,可以点进去看下注释).
    //     *  ↑↑↑上面四个可以分别使用'kCATransitionFade', 'kCATransitionMoveIn', 'kCATransitionPush',
    //
    //     'kCATransitionReveal'来调用.
    //     *  @"cube"                     立方体翻滚效果
    //     *  @"moveIn"                   新视图移到旧视图上面
    //     *  @"reveal"                   显露效果(将旧视图移开,显示下面的新视图)
    //     *  @"fade"                     交叉淡化过渡(不支持过渡方向)             (默认为此效果)
    //     *  @"pageCurl"                 向上翻一页
    //     *  @"pageUnCurl"               向下翻一页
    //     *  @"suckEffect"               收缩效果，类似系统最小化窗口时的神奇效果(不支持过渡方向)
    //     *  @"rippleEffect"             滴水效果,(不支持过渡方向)
    //     *  @"oglFlip"                  上下左右翻转效果
    //     *  @"rotate"                   旋转效果
    //     *  @"push"
    //     *  @"cameraIrisHollowOpen"     相机镜头打开效果(不支持过渡方向)
    //     *  @"cameraIrisHollowClose"    相机镜头关上效果(不支持过渡方向)
    //     */
    //
    //    /** type
    //     *
    //     *  kCATransitionFade            交叉淡化过渡
    //     *  kCATransitionMoveIn          新视图移到旧视图上面
    //     *  kCATransitionPush            新视图把旧视图推出去
    //     *  kCATransitionReveal          将旧视图移开,显示下面的新视图
    //     */
    //
    //    animation.type = type;
    //
    //    /** subtype
    //     *
    //     *  各种动画方向
    //     *
    //     *  kCATransitionFromRight;      同字面意思(下同)
    //     *  kCATransitionFromLeft;
    //     *  kCATransitionFromTop;
    //     *  kCATransitionFromBottom;
    //     */
    //
    //    /** subtype
    //     *
    //     *  当type为@"rotate"(旋转)的时候,它也有几个对应的subtype,分别为:
    //     *  90cw    逆时针旋转90°
    //     *  90ccw   顺时针旋转90°
    //     *  180cw   逆时针旋转180°
    //     *  180ccw  顺时针旋转180°
    //     */
    //
    //    /**
    //     *  type与subtype的对应关系(必看),如果对应错误,动画不会显现.
    //     *
    //     *  @see http://iphonedevwiki.net/index.php/CATransition
    //     */
    //
    //    animation.subtype = subType;
    //
    //    /**
    //     *  所有核心动画和特效都是基于CAAnimation,而CAAnimation是作用于CALayer的.所以把动画添加到layer
    //
    //     上.
    //     *  forKey  可以是任意字符串.
    //     */
    //
    
    /*
     
     [UIView animateWithDuration:0.9 animations:^(void) {
     //self.alpha=0.0;
     //此处可做UIView渐变效果以及飞出效果
     [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:scrollView cache:NO];
     } completion:^(BOOL finished) {
     [scrollView removeFromSuperview];
     }];
     
     */
    //[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:scrollView cache:NO];
    //[scrollView removeFromSuperview];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView{
    if (aScrollView == scrollView) {
        CGPoint point = scrollView.contentOffset;
        point.y = point.y*4;
        smallScrollView.contentOffset = CGPointMake(scrollView.contentOffset.x/2, scrollView.contentOffset.y);
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}


#pragma mark - KEYBOARD
- (void)keyboardWillShow:(NSNotification *)notification
{
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    
}


-(void)hideKeyboard
{
    
    if ([phoneNumberText isFirstResponder]) {
        [phoneNumberText resignFirstResponder];
    }
    if ([identCodeText isFirstResponder]) {
        [identCodeText resignFirstResponder];
    }
}



#pragma mark - TEXTFIEL DELEGATE

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    if (textField == phoneNumberText) {
        if (textField.text.length >= 1)
            _phoneNImg.image = [UIImage imageNamed:@"login_user_highlighted_os7"];
        else
            _phoneNImg.image = [UIImage imageNamed:@"login_user_os7"];
        
    }else if (textField == identCodeText)
    {
        if (textField.text.length >= 1)
            _codeImg.image = [UIImage imageNamed:@"login_key_highlighted_os7"];
        else
            _codeImg.image = [UIImage imageNamed:@"login_key_os7"];
    }
    
    NSCharacterSet *cs;
    if(textField == phoneNumberText)
    {
    cs = [[NSCharacterSet characterSetWithCharactersInString:kNumbersPeriod] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];

    if (textField.text.length>=11&&range.length==0) {
        return NO;
    }
        return basicTest;
    }
    /*
    if(textField == identCodeText)
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:kNumbersPeriod] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        
        if (textField.text.length>=4&&range.length==0) {
            return NO;
        }
        return basicTest;
    }
    */
    
    return  YES;
}



-(void) loginwithPhonePwd:(NSString * ) phone pwd:(NSString * ) identCode
{
    [SVProgressHUD show];
    /*
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:phone];

    if (phone.length != 11||!isMatch) {
    */
    if (phone.length != 11) {
        [SVProgressHUD dismiss];
        UIAlertView  * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号码格式不正确" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    /*
    if (identCode.length!=4) {
        [SVProgressHUD dismiss];
        UIAlertView  * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请正确输入的验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
     */
    
    //此处实现登陆跳转功能(lewcok)
    NSString * requestString = [NSString stringWithFormat:@"%@PhoneLogin?phone=%@&code=%@&cryptsession=1",CDBestieURLString,phone,identCode];
    
    
    NSError *error;
    // 数据内容转换为UTF8编码，第二个参数为数据长度 // NSData *requestData = [NSData dataWithBytes:[requestString UTF8String] length:[requestString length]];
    // 请求的URL地址
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
    [request setTimeoutInterval:3.0];
    NSLog(@"%@\n",requestString);
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil]; // 输出返回数据
    if(data){
    NSDictionary *responeDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        
    NSLog(@"%@",responeDic);
    NSString * sessionID = [DataHelper getStringValue:responeDic[@"sessionid"] defaultValue:@""];
   // NSString * serverURL =[NSString stringWithFormat:@"%@?usezlib=1&sessionid=%@&cdata=",[DataHelper getStringValue:responeDic[@"wss"] defaultValue:@""],sessionID] ;
    NSString * serverURL =[NSString stringWithFormat:@"%@",[DataHelper getStringValue:responeDic[@"wss"] defaultValue:@""]] ;
    NSLog(@"sessionID = %@",sessionID);
    NSLog(@"serverURL = %@",serverURL);
        if(sessionID&&![sessionID isEqual:@""]){
            //进入下个页面(lewcok)
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            [defaults setObject:sessionID forKey:@"SESSION_ID"];
            [defaults setObject:phone forKey:@"PHONE_NUMBER"];
            [defaults setObject:serverURL forKey:@"SERVER_URL"];
            
            [[WebSocketManager instance] close];
            [[WebSocketManager instance] open:serverURL withsessionid:sessionID];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(receiveLogin:)
                                                         name:NotifyUserLogin
                                                       object:nil];
            
            

        }else{
            [SVProgressHUD dismiss];
            UIAlertView  * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }
    }
    else{
            //无返回的情况(lewcok)
            UIAlertView  * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录失败,请检查网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
     }
    [SVProgressHUD dismiss];
}

- (void) receiveLogin:(NSNotification *) notification
{
    //User* u=(User*)notification.object;
    myUserInfo = (User*)notification.object;;
    NSLog(@"uid=%lld",myUserInfo.uid);
    
    {
        //CDBAppDelegate *delegate = (CDBAppDelegate *)[UIApplication sharedApplication].delegate;
        //myUserInfo = (UserInfo2*)delegate.myUserInfo;
        NSLog(@"UserInfo=%@",myUserInfo);
        {
            [SVProgressHUD dismiss];
            
            if (myUserInfo.nick) {
                NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                [defaults setObject:myUserInfo.nick forKey:@"USERINFO_NICK"];
                if(myUserInfo.uid)
                {
                    
                    [defaults setInteger:(NSInteger)myUserInfo.uid forKey:@"USERINFO_UID"];
                }
                else
                {
                    [defaults setInteger:0 forKey:@"USERINFO_UID"];
                }
                if(myUserInfo.birthday)
                {
                    [defaults setInteger:myUserInfo.birthday forKey:@"USERINFO_BIRTH"];
                }
                else
                {
                    [defaults setInteger:0 forKey:@"USERINFO_BIRTH"];
                }
                if(myUserInfo.sex)
                {
                    [defaults setInteger:myUserInfo.sex forKey:@"USERINFO_SEX"];
                }
                else
                {
                    [defaults setInteger:0 forKey:@"USERINFO_SEX"];
                }
                if(myUserInfo.signature)
                    
                {
                    [defaults setObject:myUserInfo.signature forKey:@"USERINFO_SIGNATURE"];
                }
                else
                {
                    [defaults setObject:@"" forKey:@"USERINFO_SIGNATURE"];
                }
                if(myUserInfo.headpic)
                {
                    [defaults setObject:myUserInfo.headpic forKey:@"USERINFO_HEADPIC"];
                }
                else
                {
                    [defaults setObject:@"" forKey:@"USERINFO_HEADPIC"];
                }
                
                [defaults synchronize];
                NSLog(@"%@",myUserInfo.nick);
                [SVProgressHUD dismiss];
                [self dismissViewControllerAnimated:NO completion:^{}];
            }
            else
            {
                [SVProgressHUD dismiss];
                [self completeUserInfoview:nil];
            }
        }
    }
    
    
}

-(BOOL)isVaildPhoneN:(NSString*)text
{
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:text];
    return isMatch;
}

#pragma mark CLICK FUCTION

- (IBAction)getCode:(id)sender {
    /*
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:phoneNumberText.text];
    
    if (phoneNumberText.text.length != 11||!isMatch) {
    */
    if (phoneNumberText.text.length != 11) {
        UIAlertView  * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号码格式不正确" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
    //此处实现获取验证码功能(lewcok)
    [self runSequncer:phoneNumberText.text];
    
    }
}

- (void)runSequncer :(NSString * )phone
{
    [SVProgressHUD show];
    NSString * requestString = [NSString stringWithFormat:@"%@/getcode?phone=%@",CDBestieURLString,phoneNumberText.text];

    
    
    NSError *error;
    // 数据内容转换为UTF8编码，第二个参数为数据长度 // NSData *requestData = [NSData dataWithBytes:[requestString UTF8String] length:[requestString length]];
    // 请求的URL地址
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
    [request setTimeoutInterval:3.0];
    NSLog(@"%@\n",requestString);
    // 设置请求方式 //[request setHTTPMethod:@"get"];
    // 设置请求内容 //[request setHTTPBody:requestData];
    // 设置请求头声明 [request setValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
    // 执行请求
    //NSHTTPURLResponse *urlResponse = nil;
    //NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:nil]; // 输出返回数据
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil]; // 输出返回数据
    NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"returnString = %@", returnString);
    //NSLog(@"urlResponse = %@", urlResponse);
    if(data){
        [SVProgressHUD dismiss];
    NSDictionary *messDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
        if(error){
            [SVProgressHUD dismiss];
            UIAlertView  * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取验证码失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        
        }else{
            
            /*
             NSError *error;
             //加载一个NSURL对象
             NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.weather.com.cn/data/101180601.html"]];
             //将请求的url数据放到NSData对象中
             NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
             //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
             NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
             NSDictionary *weatherInfo = [weatherDic objectForKey:@"weatherinfo"];
             txtView.text = [NSString stringWithFormat:@"今天是 %@  %@  %@  的天气状况是：%@  %@ ",[weatherInfo objectForKey:@"date_y"],[weatherInfo objectForKey:@"week"],[weatherInfo objectForKey:@"city"], [weatherInfo objectForKey:@"weather1"], [weatherInfo objectForKey:@"temp1"]];
             NSLog(@"weatherInfo字典里面的内容为--》%@", weatherDic );
             */
            
            //
            if ([messDic objectForKey:@"msg"]) {
                NSLog(@"identCode = %@",[messDic valueForKey:@"msg"]);
                UIAlertView  * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[messDic valueForKey:@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            else{
                
                if (![@"" isEqualToString: returnString]) {
                    UIAlertView  * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码已发送" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else
                {
                    UIAlertView  * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取验证码失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
        
        }
        
    }
    else{
        //无返回的情况(lewcok)
        [SVProgressHUD dismiss];
        UIAlertView  * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取验证码失败,请检查网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    
    }

}

- (IBAction)Login:(id)sender {
    [SVProgressHUD show];
    [self loginwithPhonePwd:phoneNumberText.text pwd:identCodeText.text];
    
}

-(IBAction)completeUserInfoview:(id)sender
{
    CDBCompleteUserInfoViewController * viewContr = [self.storyboard instantiateViewControllerWithIdentifier:@"CDBCompleteUserInfoViewController"];
    [self.navigationController pushViewController:viewContr animated:YES];
    
    
//    CDBCompleteUserInfoViewController * viewContr = [self.storyboard instantiateViewControllerWithIdentifier:@"CDBCompleteUserInfoViewController"];
//    viewContr.navigationItem.leftBarButtonItem.title =@"";
//    [self presentViewController:viewContr animated:YES completion:^{
//        
//    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
