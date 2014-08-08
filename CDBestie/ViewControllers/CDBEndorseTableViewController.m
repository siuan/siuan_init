//
//  CDBEndorseTableViewController.m
//  CDBestie
//
//  Created by apple on 14-8-1.
//  Copyright (c) 2014年 lifestyle. All rights reserved.
//

#import "CDBEndorseTableViewController.h"
#import "CDBLoginNaviController.h"
#import "CDBCompleteUserInfoViewController.h"
#import "CDBplusMenuView.h"
#import "DZWebBrowser.h"
#import "UINavigationSample.h"
#import "CDBChangeUserInfoController.h"
#import "CDBEndorseCell.h"
#import "CDBAppDelegate.h"
#import "CDBestieDefines.h"
#import "tools.h"
#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"
#import "CDBBangNaviController.h"
#import "CDBBangTableViewController.h"
#import "CDBEndorseInfoController.h"
#import "ACDBEndorseInfoController.h"

//#import "AFHTTPRequestOperationManager.h"
#define GOODS_HOTEL_NEW @"http://202.85.215.157:8888/LifeStyleCenter/uidIntercept/hotelNew.do?sessionid="


@interface CDBEndorseTableViewController ()
{
    //用来接收实例化 view
    UIView *myMenu;
    NSMutableArray *friend_list;
    UILabel *levellbl;
    NSMutableArray *navNick_list;
    
}
@property (readwrite)  BOOL show;
@property (nonatomic,weak) UIImageView *titleLabImage;
@property (nonatomic,weak) UILabel *titlelab;
@end

@implementation CDBEndorseTableViewController
@synthesize titlelab;
@synthesize titleLabImage;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    //暂时隐藏tabbar(lewcok)
    //self.tabBarController.tabBar.hidden=YES;
    //[self.navigationController.toolbar removeFromSuperview];
    //self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height + 44);
    //self.tableView.scrollEnabled = NO;
    //添加rightbutton(lewcok)
    
    if (![self.title isEqual:@"排行榜"]) {
        CGSize navSize = CGSizeMake(20 , 20);
        UIImage *menuImage = [self scaleToSize:[UIImage imageNamed:@"composeIcon"] size:navSize];
        ;
        //UIBarButtonItem * myInfobar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"composeIcon"] style:UIBarButtonItemStyleDone target:self action:@selector(myInfobarClick)];
        UIImage *searchImage = [self scaleToSize:[UIImage imageNamed:@"composeIcon"] size:navSize];
        ;
        
        //改变 rightBarButtonItem 形状
        UIBarButtonItem * menubar = [[UIBarButtonItem alloc] initWithImage:menuImage style:UIBarButtonItemStyleDone target:self action:@selector(menubarClick)];
        UIBarButtonItem * mySearchbar = [[UIBarButtonItem alloc] initWithImage:searchImage style:UIBarButtonItemStyleDone target:self action:@selector(mySearchbarClick)];
        self.navigationItem.rightBarButtonItems = @[menubar,mySearchbar];
        
        
        
        
        //UIBarButtonItem * myIconbar = [[UIBarButtonItem alloc] initWithImage:searchImage style:UIBarButtonItemStyleDone target:self action:@selector(mySearchbarClick)];
        //self.navigationItem.leftBarButtonItems = @[myIconbar];
        
        //导航条中间图片
        UIImageView *tempLabImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"daiyan_logo"]];
        titleLabImage = tempLabImage;
        UILabel *templab = [[UILabel alloc]init];
        titlelab = templab;
        //self.navigationItem.titleView = titleLabImage;
        UINavigationBar *bar = [self.navigationController navigationBar];
        titleLabImage.frame = CGRectMake(20, bar.frame.size.height-15, 25, 25);
        NSLog(@"%@",NSStringFromCGRect(titleLabImage.frame));
        titlelab.frame = CGRectMake(20+30, bar.frame.size.height-15, 100, 30);
        //NSLog(@"%@",NSStringFromCGRect(titleLabImage.frame));
        [titlelab setText:@"代言人"];
        [titlelab setTextColor:[UIColor whiteColor]];
        [self.navigationController.view addSubview:titleLabImage];
        [self.navigationController.view addSubview:titlelab];
        [super viewDidLoad];
        //self.title = @"代言人";
        
        
        
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString *sessionid = [defaults objectForKey:@"SESSION_ID"];
        NSString *user_nick = [defaults objectForKey:@"USERINFO_NICK"];
        //NSString *serverURL = [defaults objectForKey:@"SERVER_URL"];
        //打印出sessionid
        NSLog(@"sessionid = %@",sessionid);
        NSLog(@"nick = %@",user_nick);
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (!sessionid) {
                [self OpenLoginview:nil];
            }else{
                if(!user_nick)
                {
                    [self completeUserInfoview:nil];
                }
                
                [self initHomeData];
                
            }
        });

    }
        // Do any additional setup after loading the view.
    
    if([self.title isEqual:@"排行榜"])
    {
    [self initHomeData];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.show = NO;
    //暂时隐藏tabbar(lewcok)
    self.tabBarController.tabBar.hidden=YES;
    //[self.navigationController.toolbar removeFromSuperview];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height + 44);
    titleLabImage.hidden = NO;
    titlelab.hidden = NO;
    //if (!friend_list) {
        [self initHomeData];
    //}
    //else
    //{
    //    [self.tableView reloadData];
    //}
}

-(void)viewDidDisappear:(BOOL)animated
{

        //titleLabImage.hidden = YES;
        //titlelab.hidden =YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    titleLabImage.hidden = YES;
    titlelab.hidden =YES;
    
}

-(void)initHomeData
{
    //user.friend_list(uid,pos=0<开始位置>,count=50<数量>)某个用户的好友列表，pos和count用来翻页
//    NSDictionary * parames = @{@"uid":[USER_DEFAULT objectForKey:@"USERINFO_UID"],@"pos":@0,@"count":@50};
// 
//  [[WebSocketManager instance]sendWithAction:@"user.friend_list" parameters:parames callback:^(WSRequest *request, NSDictionary *result)
//    {
//        friend_list = [result objectForKey:@"friend_id"];
//    }];
    
    
    
    [SVProgressHUD show];
    NSDictionary * parames = @{@"uid":[USER_DEFAULT objectForKey:@"USERINFO_UID"],@"pos":@0,@"count":@1000};
    [[WebSocketManager instance]sendWithAction:@"user.friend_list" parameters:parames callback:^(WSRequest *request, NSDictionary *result){
        if(request.error_code!=0)
        {
            [SVProgressHUD dismiss];
            //_picHint.hidden = NO;
            //_picHint.text = @"加载失败,请检查网络";
            return;
        }
        friend_list = result[@"friend_id"];
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
    }];
}


-(IBAction)OpenLoginview:(id)sender
{
    UINavigationController * CDBLoginNaviController =  [self.storyboard instantiateViewControllerWithIdentifier:@"CDBLoginNaviController"];
    [self presentViewController:CDBLoginNaviController animated:NO completion:nil];
}

-(IBAction)completeUserInfoview:(id)sender
{
    CDBCompleteUserInfoViewController * viewContr = [self.storyboard instantiateViewControllerWithIdentifier:@"CDBCompleteUserInfoViewController"];
    viewContr.navigationItem.leftBarButtonItem.title =@"";
    [self presentViewController:viewContr animated:YES completion:^{
        
    }];
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(newsize);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


- (void)menubarClick
{
    //    NSLog(@"消息点击响应");
    //    CDBChangeUserInfoController *navi = [self.storyboard instantiateViewControllerWithIdentifier:@"CDBChangeUserInfoController"];
    //    navi.title = @"个人资料";
    //    [self.navigationController pushViewController:navi animated:YES];
    //    CDBplusMenuTabelViewController *navi = [self.storyboard instantiateViewControllerWithIdentifier:@"CDBplusMenuTabelViewController"];
    //    navi.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-160, 65, 160, 282);
    //
    //    [self.navigationController.view addSubview:navi.view];
    
    
    //Add the customView to the current view
    if (self.show == NO) {

        if (!myMenu) {
        UIViewController *customView = [self.storyboard instantiateViewControllerWithIdentifier:@"CDBplusMenuViewController"];
        
        CDBplusMenuView *clientview=(CDBplusMenuView*)customView.view;
        
        //UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(25, 65, 100, 50)]; //<- change to where you want it to show.
        //NSLog(@"%f",self.navigationController.navigationBar.frame.size.height);
            NSLog(@"%f",self.navigationController.navigationBar.frame.size.height);
        customView.view.frame = CGRectMake(0,self.navigationController.navigationBar.frame.size.height+20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-44);
        //Set the customView properties
            myMenu = customView.view ;
        customView.view.alpha = 0.0;
        //customView.view.layer.cornerRadius = 5;
        customView.view.layer.borderWidth = 0.5f;
        customView.view.layer.masksToBounds = YES;
        customView.view.tag = 99;
            //添加到最上层 (lewcok)
        [[[UIApplication sharedApplication].delegate window] addSubview:myMenu];
        //[self.view bringSubviewToFront:customView.view];

//        CALayer *backLayer = [CALayer layer];
//        backLayer.backgroundColor = [UIColor orangeColor].CGColor;
//        backLayer.bounds = CGRectMake(10, 10, 1004, 728); //设置layer的区域
//        backLayer.position = CGPointMake(0, 768/2-10); //设置layer坐标
//        [customView.view.layer addSublayer:backLayer];
        
        
        
        //UIWindow * window = [[UIApplication sharedApplication].keyWindow ];
        //[[[UIApplication sharedApplication].delegate window] bringSubviewToFront:customView.view];
        //Display the customView with animation
        [UIView animateWithDuration:0.4 animations:^{
            [customView.view setAlpha:1.0];
        } completion:^(BOOL finished) {}];
        self.show =YES;
        //self.view.backgroundColor = [UIColor clearColor];
        // Do any additional setup after loading the view.
//            UITapGestureRecognizer
//            UIPinchGestureRecognizer
//            UIRotationGestureRecognizer
//            UISwipeGestureRecognizer
//            UIPanGestureRecognizer
//            UILongPressGestureRecognizer
            //touchdown 检测到后关闭menubar()
             [clientview.btn1 addTarget:self action:@selector(hiddenMenu) forControlEvents:UIControlEventTouchDown];
            [clientview.btn2 addTarget:self action:@selector(hiddenMenu) forControlEvents:UIControlEventTouchDown];
            [clientview.btn3 addTarget:self action:@selector(hiddenMenu) forControlEvents:UIControlEventTouchDown];
        //UITapGestureRecognizer * tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenMenu)];
           // [customView.view addGestureRecognizer:tapges];
//            UISwipeGestureRecognizer * swipes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenMenu)];
//            [customView.view addGestureRecognizer:swipes];
//            UIPinchGestureRecognizer * pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenMenu)];
//            [customView.view addGestureRecognizer:pinch];
//            UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenMenu)];
//            [customView.view addGestureRecognizer:pan];
//            UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenMenu)];
//            [customView.view addGestureRecognizer:pan];
            
            
        [clientview.myBtn setBackgroundImage:[UIImage imageNamed:@"top_list_geren.png"] forState:UIControlStateNormal];
        //[myBtn setTitle:@"xxx" forState:UIControlStateNormal];
        [clientview.myBtn setBackgroundImage:[UIImage imageNamed:@"top_list_geren_selected.png"] forState:UIControlStateSelected];
        [clientview.myBtn addTarget:self action:@selector(myInfoShow:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [clientview.bangBtn setBackgroundImage:[UIImage imageNamed:@"top_list_paihang.png"] forState:UIControlStateNormal];
        [clientview.bangBtn setBackgroundImage:[UIImage imageNamed:@"top_list_paihang_selected.png"] forState:UIControlStateSelected];
        [clientview.bangBtn addTarget:self action:@selector(bangInfoShow:) forControlEvents:UIControlEventTouchUpInside];
        
        //UIButton *myBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        //myBtn = (UIButton *)[self.view viewWithTag:1];
        
        //[myBtn setBackgroundImage:[UIImage imageNamed:@"top_list_beijin_dianji.png"] forState:UIControlStateNormal];
        //[abtn setBackgroundImage:[UIImage imageNamed:@"title.png"] forState:UIControlStateNormal];
        
        //[abtn setTitle:@"xxx" forState:UIControlStateNormal];
        
    }else
    {
        self.show = YES;
    }
        
    }
    else
    {
        

        if (myMenu) {
            [myMenu removeFromSuperview];
            myMenu = nil;
            self.show = NO;
        }
        
    }
    
}
-(void)mySearchbarClick
{
    CDBChangeUserInfoController *navi = [self.storyboard instantiateViewControllerWithIdentifier:@"CDBChangeUserInfoController"];
    navi.title = @"个人资料";
    [self hiddenMenu];
    //[self presentViewController:navi animated:YES completion:nil];
    
}

- (IBAction)myInfoShow:(id)sender {
    
    CDBChangeUserInfoController *navi = [self.storyboard instantiateViewControllerWithIdentifier:@"CDBChangeUserInfoController"];
    navi.title = @"个人资料";
    [self hiddenMenu];
    [self.navigationController pushViewController:navi animated:YES];
}

- (IBAction)bangInfoShow:(id)sender {
    
    CDBBangTableViewController *conss = [self.storyboard instantiateViewControllerWithIdentifier:@"CDBBangTableViewController"];
    conss.title = @"排行榜";
    [self hiddenMenu];
    [self.navigationController pushViewController:conss animated:YES];
    //[self presentViewController:conss animated:YES completion:^{}];
    /*
    CDBEndorseTableViewController *navi = [self.storyboard instantiateViewControllerWithIdentifier:@"CDBEndorseTableViewController"];
    navi.title = @"排行榜";
    //navi.navigationItem.rightBarButtonItem = @[];
    navi.titlelab.hidden = YES;
    navi.titleLabImage.hidden = YES;
    
    [self hiddenMenu];
    [self.navigationController pushViewController:navi animated:YES];
    */
    /*
    [self presentViewController:conss animated:YES completion:^{
        
    }];
    */
}


- (void)hiddenMenu
{
    if (myMenu) {
        [myMenu removeFromSuperview];
        myMenu = nil;
        self.show = NO;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (friend_list) {
        return [friend_list count];
    }
    return 0;
    
}

- (CGFloat)tableView:(__unused UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *nowCell = [self.tableView cellForRowAtIndexPath:indexPath];
    //通过匹配圈子名控制高度达到只显示某些圈子的效果(lewcok)
    /*
     NSDictionary *dic = [self.CircleArray objectAtIndex:indexPath.row];
     if(![[dic valueForKey:@"name"]  isEqual: @"乐百汇"])
     {
     return 0;
     }
     */
    return 120.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ACDBEndorseInfoController  * navi = [self.storyboard instantiateViewControllerWithIdentifier:@"ACDBEndorseInfoController"];
    navi.userUid = [[[friend_list objectAtIndex:indexPath.row] objectForKey:@"uid"] longLongValue];
    CDBEndorseCell *cell =(CDBEndorseCell*) [self.tableView cellForRowAtIndexPath:indexPath];
    navi.title = cell.userNick.text;
    //navi.title = [navNick_list objectAtIndex:indexPath.row];
    //hotel.url = [NSURL URLWithString:@"http://www.baidu.com/"];
    [self.navigationController pushViewController:navi animated:YES];
    
    /*
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CDBEndorseInfoController  * navi = [self.storyboard instantiateViewControllerWithIdentifier:@"CDBEndorseInfoController"];
    //hotel.url = [NSURL URLWithString:@"http://www.baidu.com/"];
    [self.navigationController pushViewController:navi animated:YES];
    
    */
    
    
#if (0)
    {
        /*
         LXCircleBuyOtherViewController  * hotel = [self.storyboard instantiateViewControllerWithIdentifier:@"LXCircleBuyOtherViewController"];
         hotel.url = [NSURL URLWithString:@"http://www.baidu.com/"];
         [self.navigationController pushViewController:hotel animated:YES];
         */
        
        
        
        //DZWebBrowser *webBrowser = [[DZWebBrowser alloc] initWebBrowserWithURL:[NSURL URLWithString:GOODS_HOTEL]];
        DZWebBrowser *webBrowser = [[DZWebBrowser alloc] initWebBrowserWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",GOODS_HOTEL_NEW,[[NSUserDefaults standardUserDefaults] objectForKey:@"SESSION_ID"]]]];
        //DZWebBrowser *webBrowser = [[DZWebBrowser alloc] initWebBrowserWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
        webBrowser.showProgress = YES;
        // webBrowser.allowSharing = YES;
        webBrowser.allowOrder = YES;
        webBrowser.allowtoolbar = NO;

        
        //
        UINavigationSample *webBrowserNC = [self.storyboard instantiateViewControllerWithIdentifier:@"UINavigationSample"];
        [webBrowserNC pushViewController:webBrowser animated:NO];
        
        //[[UINavigationSample alloc] initWithRootViewController:webBrowser];
        [self presentViewController:webBrowserNC animated:YES completion:NULL];
        
        
        
        //[self.navigationController pushViewController:webBrowser animated:YES];
        
    }
#endif
    
    //NSDictionary *dic = [self.CircleArray objectAtIndex:indexPath.row];
    //NSDictionary *dic = [self.CircleArray objectAtIndex:indexPath.row];


    
    
    /*
     XCJSelfPhotoViewController *XCJSelfPhotoViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"XCJSelfPhotoViewController"];
     //circleInfoViewController.post = _activities[indexPath.row];
     XCJSelfPhotoViewController.hidesBottomBarWhenPushed = YES;
     
     //NSDictionary *dic = [self.CircleArray objectAtIndex:indexPath.row];
     XCJSelfPhotoViewController.title = [[self.CircleArray objectAtIndex:indexPath.row] valueForKey:@"name"];
     [self.navigationController pushViewController:XCJSelfPhotoViewController animated:YES];
     */
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    CDBEndorseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CDBEndorseCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[CDBEndorseCell alloc] init];
    }
    cell.celluid = [[[friend_list objectAtIndex:indexPath.row] objectForKey:@"uid"] longLongValue];
    // Configure the cell...
    NSString* cell_uid = [[friend_list objectAtIndex:indexPath.row] objectForKey:@"uid"];
    NSLog(@"cell_uid = %@",cell_uid);
    NSDictionary * parames = @{@"uid":cell_uid};
    
    [[WebSocketManager instance]sendWithAction:@"user.info2" parameters:parames callback:^(WSRequest *request, NSDictionary *result)
     {
         //在传入某对象前弄个标识符(需要是它的属性), 如这里的celluid,然后在回调回来后判断前后是否一致,来解决错乱问题(lewcok)
         if ([[request.parm valueForKey:@"uid"] longLongValue]!=cell.celluid) {
             return;
         }
         NSLog(@"result = %@",result);
         
         //遮罩截圆
         [cell.userIcon.layer setCornerRadius:CGRectGetHeight([cell.userIcon bounds]) / 2];
         cell.userIcon.layer.masksToBounds = YES;
         cell.iconLayer.hidden =YES;
        // UIImageView * imageIcon1 = (UIImageView *)[cell.contentView viewWithTag:6];
        // [imageIcon1.layer setCornerRadius:CGRectGetHeight([imageIcon bounds]) / 2];
        // imageIcon1.layer.masksToBounds = YES;
        // imageIcon1.hidden=YES;
         
        
         
         
         UserInfo2 *userInfo =[[UserInfo2 alloc]initWithJson:result];
         cell.userNick.text = userInfo.user.nick;
         //NSMutableArray *navTemp = [[NSMutableArray alloc]init];
         //[navTemp addObjectsFromArray: navNick_list];
         //[navTemp addObject:userInfo.user.nick];
         //navNick_list = navTemp ;
         //NSLog(@"navNick_list = %@",navNick_list);
         NSString *imageString = [NSString stringWithFormat:@"%@\?imageView2/1/w/%i/h/%i",userInfo.user.headpic,(int)cell.userIcon.frame.size.width,(int)cell.userIcon.frame.size.height];
         NSURL *imageURL = [NSURL URLWithString:imageString];
         [cell.userIcon setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"left_view_avatar_avatar"]];
         
         NSString *user_SEX;
         //int user_AGE;
         NSString *user_JOB;
        // NSString *user_BIRTH;
         if (userInfo.user.sex == 1) {
             user_SEX = @"男";
         }
         else
         {
             user_SEX =@"女";
         }
         
         user_JOB = userInfo.user.job;
         if (!user_JOB) {
             user_JOB = @"保密";
         }
         
         NSTimeInterval birth = userInfo.user.birthday;
         NSLog(@"birth = %f",birth);

         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
         [dateFormatter setDateFormat:@"yyyy-MM-dd"];
         NSDate *date = [NSDate dateWithTimeIntervalSince1970:birth];
         
         NSTimeInterval dateDiff = [date timeIntervalSinceNow];
         
         int age=trunc(dateDiff/(60*60*24))/365;
         if (age<0) {
             age = abs(age);
         }
         NSLog(@"age = %d",age);
         NSLog(@"birth = %ld",(long)birth);
         NSString *infoString = [NSString stringWithFormat:@"%@ | %@ | %d岁",user_SEX,user_JOB,age];
         //cell.userInfo.text = infoString;
         
         
         CGSize StringSize = [infoString
                     sizeWithFont:[UIFont systemFontOfSize:15.0f]
                          constrainedToSize:cell.userNick.frame.size
                          lineBreakMode:cell.userNick.lineBreakMode];

         //Adjust the size of the UILable
         
         
         cell.userNick.frame = CGRectMake(cell.userNick.frame.origin.x,
                      cell.userNick.frame.origin.y,
                      StringSize.width,
                      StringSize.height);
         cell.userInfo.text = infoString;
         [cell.userNick sizeToFit];
         [cell.userInfo sizeToFit];
         
//         NSArray *views = [cell.userLevel subviews];
//         NSLog(@"%@",views);
//         for(UIView* view in views)
//         {
//             [view removeFromSuperview];
//         }
         //[levellbl removeFromSuperview];
         cell.userLevel.userInteractionEnabled = NO;
         int value = arc4random()%99;
         if (value == 0) {
             [cell.userLevel setBackgroundImage:[UIImage imageNamed:@"daiyan_liebiao_lingjiicon"] forState:UIControlStateNormal];
          [cell.userLevel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
         }
         else
         {
             [cell.userLevel setBackgroundImage:[UIImage imageNamed:@"daiyan_liebiao_dengjiicon"] forState:UIControlStateNormal];
             [cell.userLevel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
         }
         
         CGRect frame = cell.userNick.frame;
         cell.userLevel.frame =CGRectMake(frame.origin.x+frame.size.width+5, cell.userLevel.frame.origin.y, cell.userLevel.frame.size.width, cell.userLevel.frame.size.height);
         //cell.userLevel.titleLabel.text = [NSString stringWithFormat:@"LV%d",value];
         [cell.userLevel setTitle:[NSString stringWithFormat:@"LV%d",value] forState:UIControlStateNormal];
         NSLog(@"levelText = %@",[NSString stringWithFormat:@"LV%d",value]);
         [cell.userLevel.titleLabel sizeToFit];
         cell.userLevel.titleLabel.textAlignment = NSTextAlignmentCenter;
         
         /*
         if (indexPath.row != 0) {
             CGRect levelFrame = cell.userLevel.frame;
             levellbl.frame = CGRectMake(0, 0, levelFrame.size.width, levelFrame.size.height);
             //levellbl.backgroundColor = [UIColor clearColor];
             levellbl.textColor = [UIColor whiteColor];
             levellbl.text = [NSString stringWithFormat:@"LV%d",indexPath.row];
             levellbl.textAlignment = NSTextAlignmentCenter;
             [cell.userLevel addSubview:levellbl];
         }
         else
         {
             cell.userLevel = [UIImage imageNamed:@"daiyan_liebiao_lingjiicon"] ;
             CGRect levelFrame = cell.userLevel.frame;
             levellbl.frame = CGRectMake(0, 0, levelFrame.size.width, levelFrame.size.height);
             //levellbl.backgroundColor = [UIColor clearColor];
             levellbl.textColor = [UIColor redColor];
             levellbl.text = @"LV0";
             levellbl.textAlignment = NSTextAlignmentCenter;
             [cell.userLevel addSubview:levellbl];
         }
          */
     }];
    //通过这种方式去重 未测试(lewcok)
    //cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
