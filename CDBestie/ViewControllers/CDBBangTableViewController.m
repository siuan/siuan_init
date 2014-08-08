//
//  CDBBangTableViewController.m
//  CDBestie
//
//  Created by apple on 14-8-5.
//  Copyright (c) 2014年 lifestyle. All rights reserved.
//

#import "CDBBangTableViewController.h"
#import "CDBLoginNaviController.h"
#import "DZWebBrowser.h"
#import "UINavigationSample.h"
#import "CDBBangCell.h"
#import "CDBAppDelegate.h"
#import "CDBestieDefines.h"
#import "tools.h"
#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"
#import "ACDBEndorseInfoController.h"

#import "AFHTTPRequestOperationManager.h"
#define GOODS_HOTEL_NEW @"http://202.85.215.157:8888/LifeStyleCenter/uidIntercept/hotelNew.do?sessionid="


@interface CDBBangTableViewController ()
{
    //用来接收实例化 view
    UIView *myMenu;
    NSMutableArray *friend_list;
    
}
@property (readwrite)  BOOL show;
@property (nonatomic,weak) UIImageView *titleLabImage;
@property (nonatomic,weak) UILabel *titlelab;
@property (nonatomic,weak) UILabel *levellbl;
@end

@implementation CDBBangTableViewController
@synthesize titlelab;
@synthesize titleLabImage;
@synthesize levellbl;

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
    

    // Do any additional setup after loading the view.
    
    [self initHomeData];
    
    
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
    if (!friend_list) {
        [self initHomeData];
    }
    else
    {
        [self.tableView reloadData];
    }
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    
    //titleLabImage.hidden = YES;
   // titlelab.hidden =YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    //titleLabImage.hidden = YES;
    //titlelab.hidden =YES;
    
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
        if ([friend_list count]<10) {
            return [friend_list count];
        }
        else
            return 10;
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
    return 80.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ACDBEndorseInfoController  * navi = [self.storyboard instantiateViewControllerWithIdentifier:@"ACDBEndorseInfoController"];
    navi.userUid = [[[friend_list objectAtIndex:indexPath.row] objectForKey:@"uid"] longLongValue];
    //hotel.url = [NSURL URLWithString:@"http://www.baidu.com/"];
    [self.navigationController pushViewController:navi animated:YES];
    
    
    
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
    
#endif
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    NSString *CDBBangCellIdentifier = [NSString stringWithFormat:@"CDBBangCell%@", [[friend_list objectAtIndex:indexPath.row] objectForKey:@"uid"]];//以indexPath来唯一确定cell
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; //出列可重用的cell
    NSLog(@"CDBBangCellIdentifier = %@",CDBBangCellIdentifier);
    CDBBangCell *cell = [tableView dequeueReusableCellWithIdentifier:CDBBangCellIdentifier];
    */
    
    CDBBangCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CDBBangCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[CDBBangCell alloc] init];
    }
    
    cell.celluid = [[[friend_list objectAtIndex:indexPath.row] objectForKey:@"uid"] longLongValue];
    
    // Configure the cell...
    NSString* cell_uid = [[friend_list objectAtIndex:indexPath.row] objectForKey:@"uid"];
    NSLog(@"cell_uid = %@",cell_uid);
    NSDictionary * parames = @{@"uid":cell_uid};
    
    [[WebSocketManager instance]sendWithAction:@"user.info2" parameters:parames callback:^(WSRequest *request, NSDictionary *result)
     {
        
         NSLog(@"result = %@",result);
         //在传入某对象前弄个标识符(需要是它的属性), 如这里的celluid,然后在回调回来后判断前后是否一致,来解决错乱问题(lewcok)
         if ([[request.parm valueForKey:@"uid"] longLongValue]!=cell.celluid) {
             return;
         }
         //遮罩截圆
         [cell.userIcon.layer setCornerRadius:CGRectGetHeight([cell.userIcon bounds]) / 2];
         cell.userIcon.layer.masksToBounds = YES;
         cell.iconLayer.hidden =YES;
          //UIImageView * imageIcon1 = (UIImageView *)[cell.contentView viewWithTag:6];
         // [imageIcon1.layer setCornerRadius:CGRectGetHeight([imageIcon bounds]) / 2];
         // imageIcon1.layer.masksToBounds = YES;
         // imageIcon1.hidden=YES;
         
         
         
         
         UserInfo2 *userInfo =[[UserInfo2 alloc]initWithJson:result];
         cell.userNick.text = userInfo.user.nick;
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
                              sizeWithFont:[UIFont systemFontOfSize:18.0f]
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
         CGRect frame = cell.userNick.frame;
         cell.userLevel.frame =CGRectMake(frame.origin.x+frame.size.width+5, cell.userLevel.frame.origin.y, cell.userLevel.frame.size.width, cell.userLevel.frame.size.height);
         
         NSArray *views = [cell.userLevel subviews];
         for(UIView* view in views)
         {
             [view removeFromSuperview];
         }
         
         
         CGRect levelFrame = cell.userLevel.frame;
         if (indexPath.row != 0) {
             
             levellbl.frame = levelFrame;
             //levellbl.backgroundColor = [UIColor clearColor];
             levellbl.textColor = [UIColor whiteColor];
             levellbl.text = [NSString stringWithFormat:@"LV%d",indexPath.row];
             levellbl.textAlignment = NSTextAlignmentCenter;
             [cell addSubview:levellbl];
         }
         else
         {
             cell.userLevel.image = [UIImage imageNamed:@"daiyan_liebiao_lingjiicon"] ;
             levellbl.frame = levelFrame;
             UILabel *levellbl = [[UILabel alloc]initWithFrame:levelFrame];
             //levellbl.backgroundColor = [UIColor clearColor];
             levellbl.textColor = [UIColor redColor];
             levellbl.text = @"LV0";
             levellbl.textAlignment = NSTextAlignmentCenter;
             [cell addSubview:levellbl];
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
