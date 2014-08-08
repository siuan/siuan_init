//
//  CDBEndorseInfoController.m
//  CDBestie
//
//  Created by apple on 14-8-5.
//  Copyright (c) 2014年 lifestyle. All rights reserved.
//

#import "ACDBEndorseInfoController.h"
#import "GoodsCell.h"
#import "userInfoCell.h"
#import "DbonusCell.h"
#import "XbonusCell.h"
#import "ablmCell.h"
#import "CDBAppDelegate.h"
#import "CDBestieDefines.h"
#import "tools.h"
#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"
#import "DZWebBrowser.h"
#import "UINavigationSample.h"
#import "CDBSelfPhotoViewController.h"

//#import "AFHTTPRequestOperationManager.h"
#define GOODS_HOTEL_NEW @"http://202.85.215.157:8888/LifeStyleCenter/uidIntercept/hotelNew.do?sessionid="
#define GOODS_WINE_NEW @"http://202.85.215.157:8888/LifeStyleCenter/uidIntercept/wineNew.do?sessionid="
#define GOODS_TRAVEL_NEW @"http://202.85.215.157:8888/LifeStyleCenter/uidIntercept/travelNew.do?sessionid="
#define GOODS_CAVALRY_NEW @"http://202.85.215.157:8888/LifeStyleCenter/uidIntercept/cavalryNew.do?sessionid="
#define GOODS_LEBAIHUI_NEW @"http://202.85.215.157:8888/LifeStyleCenter/uidIntercept/lebaihui.do?sessionid="

@interface ACDBEndorseInfoController ()
{
    UserInfo2 *userInfo;
    NSMutableArray * AblmdataSource;
    NSArray * UrlArray;
}
@end

@implementation ACDBEndorseInfoController
@synthesize  Image_userIcon;
@synthesize  Label_nick;
@synthesize  label_info;
@synthesize  levelBtn;
@synthesize  Label_daiyanjifen;
@synthesize  Label_xiaofeijifen;
@synthesize  firPic;
@synthesize  secPic;
@synthesize  thrPic;
@synthesize  goodsIcon;
@synthesize  goodsName;
@synthesize  goodsInfo;
@synthesize userUid;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{   [SVProgressHUD show];
    [super viewDidLoad];
    UrlArray = @[GOODS_LEBAIHUI_NEW,GOODS_HOTEL_NEW,GOODS_WINE_NEW,GOODS_TRAVEL_NEW,GOODS_CAVALRY_NEW];
    /*
    [self.tableView registerClass :[GoodsCell class] forCellReuseIdentifier:@"GoodsCell"];
    [self.tableView registerClass :[userInfoCell class] forCellReuseIdentifier:@"userInfoCell"];
    [self.tableView registerClass :[DbonusCell class] forCellReuseIdentifier:@"DbonusCell"];
    [self.tableView registerClass :[XbonusCell class] forCellReuseIdentifier:@"XbonusCell"];
    [self.tableView registerClass :[ablmCell class] forCellReuseIdentifier:@"ablmCell"];
    */
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    [Image_userIcon setImage: [UIImage imageNamed:@"left_view_avatar_avatar"]];
//    Label_nick.text = @"齐天大圣";
//    label_info.text = @"美女 | 女神 | 17岁";
//    [levelBtn setTitle:@"LV99" forState:UIControlStateNormal];
//    Label_daiyanjifen.text = @"9999999";
//    Label_xiaofeijifen.text = @"100000001";

     NSDictionary * parames = @{@"uid":@(self.userUid)};
    [[WebSocketManager instance]sendWithAction:@"user.info2" parameters:parames callback:^(WSRequest *request, NSDictionary *result)
     {
         
        
         [self initAlbm];
         NSLog(@"result = %@",result);
         userInfo = [[UserInfo2 alloc]initWithJson:result];
         [self.tableView reloadData];
     }];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //static cell 只能先设置多,然后返回部分,不能设置少了反而要很多 也就是说只能截断,不能动态增加.(lewcok)
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSLog(@"%ld",(long)section);
    if (section == 0) {
        return 4;
    }
    else
    {
        return [UrlArray count];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 37.5f;
    }
    else{
        return 27.5f;
    }

}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    if (section == 0) {
        return @"个人资料";
    }
    else{
        return @"代言产品";
    }
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
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                return 75.0f;
                break;
            case 1:
                return 39.0f;
                break;
            case 2:
                return 39.0f;
                break;
            default:
                return 58.5f;
                break;
        }
        
    }
    return 94.5f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[GoodsCell alloc] init];
    }
    return cell;
     */
    
    
    GoodsCell *cell;
    if (indexPath.section == 1) {
        
         cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsCell" forIndexPath:indexPath];
        
        // Configure the cell...

        if (cell == nil) {
            cell = [[GoodsCell alloc] init];
        }
        [cell.Icon setImage: [UIImage imageNamed:@"left_view_avatar_avatar"]];
        cell.name.text = @"莱福思科技有限公司";
        cell.Introduction.text =@"成都市武侯区锦绣路1号保利中心c座304";
        //[cell.name sizeToFit];
        //[cell.Introduction sizeToFit];
        
    }
    else
    {
        switch (indexPath.row) {
            case 0:
            {

                userInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userInfoCell" forIndexPath:indexPath];
                if (cell == nil) {
                    cell = [[userInfoCell alloc] init];
                }
                
//                UIImageView *temp =[[UIImageView alloc]init];
//                temp = (UIImageView*)[cell.contentView viewWithTag:1001] ;
//                //(UIImageView*)userLayerIcon = (UIImageView*)[cell.contentView viewWithTag:1002];
//                UILabel *userNick =[[UILabel alloc]init];
//                userNick = (UILabel*)[cell.contentView viewWithTag:1003];
//                //userLevel = (UIButton*)[cell.contentView viewWithTag:1004];
//                UILabel *userInfo =[[UILabel alloc]init];
//                userInfo = (UILabel*)[cell.contentView viewWithTag:1005];
                
                
                [cell.userIcon.layer setCornerRadius:CGRectGetHeight([cell.userIcon bounds]) / 2];
                cell.userIcon.layer.masksToBounds = YES;
                cell.userLayerIcon.hidden =YES;
                
                cell.userNickname.text = userInfo.user.nick;
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
                                     constrainedToSize:cell.userNickname.frame.size
                                     lineBreakMode:cell.userNickname.lineBreakMode];
                
                //Adjust the size of the UILable
                
                
                cell.userNickname.frame = CGRectMake(cell.userNickname.frame.origin.x,
                                                 cell.userNickname.frame.origin.y,
                                                 StringSize.width,
                                                 StringSize.height);
                cell.userInfo.text = infoString;
                [cell.userNickname sizeToFit];
                [cell.userInfo sizeToFit];
                //for test (static data) (lewcok)
                
//                cell.userIcon.image = [UIImage imageNamed:@"left_view_avatar_avatar"];
//                cell.userNickname.text = userInfo2.user.nick;
//                cell.userInfo.text = @"女 | 模特 | 18岁";
                
                
                [cell.userLevel setTitle:@"LV99" forState:UIControlStateNormal];
                [cell.userNickname sizeToFit];
                CGRect frame = cell.userNickname.frame;
                cell.userLevel.frame =CGRectMake(frame.origin.x+frame.size.width+5, cell.userLevel.frame.origin.y, cell.userLevel.frame.size.width, cell.userLevel.frame.size.height);
                
                //cell.userLevel.titleLabel.text = [NSString stringWithFormat:@"LV%d",value];
               // [cell.userLevel setTitle:[NSString stringWithFormat:@"LV%d",value] forState:UIControlStateNormal];
               // NSLog(@"levelText = %@",[NSString stringWithFormat:@"LV%d",value]);
                
                [cell.userLevel.titleLabel sizeToFit];
                cell.userLevel.titleLabel.textAlignment = NSTextAlignmentCenter;

                return cell;
            }
                break;
            case 1:
            {
                DbonusCell *cell;
                cell = [tableView dequeueReusableCellWithIdentifier:@"DbonusCell" forIndexPath:indexPath];
                if (cell == nil) {
                    cell = [[DbonusCell alloc] init];
                }
                cell.Dbonus.text = @"99999999";
                 //cell.Dbonus.textAlignment = NSTextAlignmentRight;
                //[cell.Dbonus sizeToFit];
                return cell;
            }
                break;
            case 2:
            {
                XbonusCell *cell;
                cell = [tableView dequeueReusableCellWithIdentifier:@"XbonusCell" forIndexPath:indexPath];
                if (cell == nil) {
                    cell = [[XbonusCell alloc] init];
                }
                cell.Xbonus.text = @"99999999";
                //cell.Xbonus.textAlignment = NSTextAlignmentRight;
                //[cell.Xbonus sizeToFit];
                return cell;
            }
                break;
            case 3:
            {
                ablmCell *cell;
                cell = [tableView dequeueReusableCellWithIdentifier:@"ablmCell" forIndexPath:indexPath];
                if (cell == nil) {
                    cell = [[ablmCell alloc] init];
                }
                
                
                if ([AblmdataSource count]> 0) {
 
                    
                    NSLog(@"%@",AblmdataSource);
                    
                    //cell.firPic.hidden = NO;
                    NSString *imageString = [NSString stringWithFormat:@"%@\?imageView2/1/w/%i/h/%i",[AblmdataSource[0] objectForKey:@"picture"],(int)cell.firPic.frame.size.width,(int)cell.firPic.frame.size.height];
                    NSURL *imageURL = [NSURL URLWithString:imageString];
                    
                    [cell.firPic setImageWithURL:imageURL];
                    
                    
                    if( [AblmdataSource count] >1)
                    {
                        //cell.secPic.hidden = NO;
                        NSString *imageString1 = [NSString stringWithFormat:@"%@\?imageView2/1/w/%i/h/%i",[AblmdataSource[1] objectForKey:@"picture"],(int)cell.secPic.frame.size.width,(int)cell.secPic.frame.size.height];
                        NSURL *imageURL1 = [NSURL URLWithString:imageString1];
                        NSLog(@"imageURL1 = %@",imageURL1);
                        //[imageIcon setImageWithURL:imageURL];
                        [cell.secPic setImageWithURL:imageURL1];
                        
                        
                        //[_secPic setImageWithURL:[NSURL URLWithString:@"http://laixinle.qiniudn.com/FmYaXQZdSASBZZgPe_jmnaObO_Ar?imageView2/1/w/60/h/60"]];
                        
                        //[self.Image_userIcon setImageWithURL:[NSURL URLWithString:@"http://laixinle.qiniudn.com/Fl28_HZ20UM32obcwmlIU80YwiG9?imageView2/1/w/60/h/60"]];
                        
                        
                    }
                    if( [AblmdataSource count] > 2)
                    {
                        cell.thirPic.hidden = NO;
                        NSString *imageString2 = [NSString stringWithFormat:@"%@\?imageView2/1/w/%i/h/%i",[AblmdataSource[2] objectForKey:@"picture"],(int)cell.thirPic.frame.size.width,(int)cell.thirPic.frame.size.height];
                        NSURL *imageURL2 = [NSURL URLWithString:imageString2];
                        //[imageIcon setImageWithURL:imageURL];
                        [cell.thirPic setImageWithURL:imageURL2];
                    }
                    
                }else{
                    //[self hiddenPic];
                   // _picHint.hidden = NO;
                    //_picHint.text = @"相册为空";
                   
                    //[self showErrorText:@"没有私密照片"];
                }
                
                
                
                return cell;
            }
                break;
        }
        
    }
    
    return cell;
}

-(void)initAlbm
{

    
    //NSString * priKey = [NSString stringWithFormat:@"PrivatePhotoList_%@",[defaults objectForKey:@"USERINFO_UID"]];
    NSDictionary * parames = @{@"uid":@(self.userUid),@"count":@"4"};
    [[WebSocketManager instance]sendWithAction:@"album.read" parameters:parames callback:^(WSRequest *request, NSDictionary *result) {
        [SVProgressHUD dismiss];
        NSLog(@"error_code = %d",request.error_code);
        NSLog(@"error = %@",request.error);
        if(request.error_code!=0)
        {
            [SVProgressHUD dismiss];
            //_picHint.hidden = NO;
            //_picHint.text = @"加载失败,请检查网络";
            return;
        }
        
        NSLog(@"%@",result);
        NSArray * medias = result[@"medias"];
        //[self hiddenPic];
        if ([medias count]> 0) {
            //_picHint.hidden = YES;
            
            // [[EGOCache globalCache] setPlist:[medias mutableCopy] forKey:priKey withTimeoutInterval:60*5];
            AblmdataSource = [NSMutableArray arrayWithArray:medias];
            
            NSLog(@"%@",AblmdataSource);
            [self.tableView reloadData];
        
    }
    }];
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
                CDBSelfPhotoViewController * viewss = [self.storyboard instantiateViewControllerWithIdentifier:@"CDBSelfPhotoViewController"];
                viewss.privateUID = self.userUid;
                [self.navigationController pushViewController:viewss animated:YES];
        }
        
    }
    if (indexPath.section == 1) {
        {
            /*
             LXCircleBuyOtherViewController  * hotel = [self.storyboard instantiateViewControllerWithIdentifier:@"LXCircleBuyOtherViewController"];
             hotel.url = [NSURL URLWithString:@"http://www.baidu.com/"];
             [self.navigationController pushViewController:hotel animated:YES];
             */
            
            
            
            //DZWebBrowser *webBrowser = [[DZWebBrowser alloc] initWebBrowserWithURL:[NSURL URLWithString:GOODS_HOTEL]];
            DZWebBrowser *webBrowser = [[DZWebBrowser alloc] initWebBrowserWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UrlArray[indexPath.row],[[NSUserDefaults standardUserDefaults] objectForKey:@"SESSION_ID"]]]];
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
    }
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
