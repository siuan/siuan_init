//
//  CDBChangeBirthViewController.m
//  CDBestie
//
//  Created by apple on 14-8-4.
//  Copyright (c) 2014年 lifestyle. All rights reserved.
//

#import "CDBChangeBirthViewController.h"
#import "CDBestieDefines.h"
#import "CDBAppDelegate.h"
#import "SVProgressHUD.h"

@interface CDBChangeBirthViewController ()<UITextFieldDelegate>
{
    UIDatePicker *datePicker;
    UITextField *dateTextField;
    NSLocale *datelocale;
    NSString *myBirthdate;

}
@property(nonatomic) int birth;
@end

@implementation CDBChangeBirthViewController
@synthesize birthText;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    birthText.delegate = self;
    [birthText becomeFirstResponder];
    NSLog(@"%@",[USER_DEFAULT objectForKey:@"USERINFO_BIRTH"]);
    //birthText.text = [USER_DEFAULT objectForKey:@"USERINFO_BIRTH"];
    [self initDataPicker];
}


-(IBAction)dismissThisNavi:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(IBAction)saveAndUpload:(id)sender
{
    
    if (![birthText.text isEqualToString:@""]) {
        [SVProgressHUD show];
        //        if ([birthText.text isEqualToString:[USER_DEFAULT stringForKey:<#(NSString *)#>]]) {}
        
        //
        //NSLog(@"%ld",(long)[USER_DEFAULT integerForKey:@"USERINFO_BIRTH"]);
        //NSDictionary * parames = @{@"birthday":@((long)[USER_DEFAULT integerForKey:@"USERINFO_BIRTH"])};
        NSDictionary * parames = @{@"birthday":myBirthdate};
        //nick, signature,sex, birthday, marriage, height
        [[WebSocketManager instance]sendWithAction:@"user.update" parameters:parames callback:^(WSRequest *request, NSDictionary *result) {
            //[USER_DEFAULT setObject:birthText.text forKey:@"USERINFO_BIRTH"];
            [USER_DEFAULT synchronize];
            [SVProgressHUD dismiss];
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"changeSlefNick" object:birthText.text];
            [self  dismissThisNavi:nil];
        }];
        
        /*
        [USER_DEFAULT setObject:[] forKey:@"USERINFO_BIRTH"];
        [USER_DEFAULT synchronize];
        [SVProgressHUD dismiss];
         */
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"changeSlefNick" object:birthText.text];
        [self  dismissThisNavi:nil];
        }
}

-(void)initDataPicker

{
    {
        
        // 記得要設定 delegate
        birthText.delegate = self;
        // 建立 UIDatePicker
        datePicker = [[UIDatePicker alloc]init];
        // 時區的問題請再找其他協助 不是本篇重點
        datelocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
        datePicker.locale = datelocale;
        datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
        datePicker.datePickerMode = UIDatePickerModeDate;
        // 以下這行是重點 (螢光筆畫兩行) 將 UITextField 的 inputView 設定成 UIDatePicker
        // 則原本會跳出鍵盤的地方 就改成選日期了
        birthText.inputView = datePicker ;
        // 建立 UIToolbar
        UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        // 選取日期完成鈕 並給他一個 selector
        UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self
                                                                              action:@selector(birthPick)];
        // 把按鈕加進 UIToolbar
        toolBar.items = [NSArray arrayWithObject:right];
        // 以下這行也是重點 (螢光筆畫兩行)
        // 原本應該是鍵盤上方附帶內容的區塊 改成一個 UIToolbar 並加上完成鈕
        birthText.inputAccessoryView = toolBar;
        
    }
}
-(void) birthPick {
    if ([self.view endEditing:NO]) {
        // 以下幾行是測試用 可以依照自己的需求增減屬性
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy-MM-dd" options:0 locale:datelocale];
        [formatter setDateFormat:dateFormat];
        [formatter setLocale:datelocale];
        // 將選取後的日期 填入 UITextField
        birthText.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
        
        NSTimeInterval dateDiff = [datePicker.date timeIntervalSinceNow];
        NSTimeInterval interval =  [datePicker.date timeIntervalSince1970];
        NSInteger birth = interval;
        myBirthdate = [NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
        int age=trunc(dateDiff/(60*60*24))/365;
        if (age<0) {
            age = abs(age);
        }
        NSLog(@"age = %d",age);
        NSLog(@"birth = %ld",(long)birth);
        self.birth = birth;
        [USER_DEFAULT setInteger:age forKey:@"USERINFO_AGE"];
        [USER_DEFAULT setInteger:birth forKey:@"USERINFO_BIRTH"];
        //[USER_DEFAULT synchronize];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string   // return NO to not change text
{
    if (textField.text.length > 15) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField              // called when 'return' key pressed. return NO to ignore.
{
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
