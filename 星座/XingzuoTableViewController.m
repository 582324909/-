//
//  XingzuoTableViewController.m
//  星座
//
//  Created by 张伟伟 on 2016/11/21.
//  Copyright © 2016年 张伟伟. All rights reserved.
//

#import "XingzuoTableViewController.h"

#import "AFNetworking.h"

@interface XingzuoTableViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *constellation;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *synthetical;
@property (weak, nonatomic) IBOutlet UILabel *health;
@property (weak, nonatomic) IBOutlet UILabel *love;
@property (weak, nonatomic) IBOutlet UILabel *wealth;
@property (weak, nonatomic) IBOutlet UILabel *work;
@property (weak, nonatomic) IBOutlet UILabel *lucky;
@property (weak, nonatomic) IBOutlet UILabel *match;
@property (weak, nonatomic) IBOutlet UILabel *color;
@property (weak, nonatomic) IBOutlet UITextView *summary;

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation XingzuoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = @[@"",@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座"];
    UIPickerView *xingzuoPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 215, self.view.frame.size.width, 215)];
    xingzuoPicker.delegate = self;
    xingzuoPicker.dataSource = self;
    self.constellation.inputView = xingzuoPicker;
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneBarItemClick)];
    UIBarButtonItem *flexBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolBar.items = @[flexBtnItem,barBtnItem];
    self.constellation.inputAccessoryView = toolBar;
    self.summary.editable = NO;
}

- (void)doneBarItemClick {
    [self.view endEditing:YES];
    [self  searchInfo];
}

-(void)searchInfo
{
    AFHTTPSessionManager *httpSession = [AFHTTPSessionManager manager];
    httpSession.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *url = @"http://web.juhe.cn:8080/constellation/getAll";
    NSDictionary *parameters = [NSDictionary dictionary];
    parameters = @{@"key":@"826231d4617f254699877a38853b7c1b",@"consName":self.constellation.text,@"type":@"today"};
    
    [httpSession GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"成功");
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        self.date.text = dic[@"datetime"];
        self.synthetical.text = dic[@"all"];
        self.health.text = dic[@"health"];
        self.love.text = dic[@"love"];
        self.wealth.text = dic[@"money"];
        self.work.text = dic[@"work"];
        self.lucky.text = [NSString stringWithFormat:@"%@",dic[@"money"]];
        self.match.text = dic[@"QFriend"];
        self.color.text = dic[@"color"];
        self.summary.text = dic[@"summary"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败");
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark-pickerView
// pickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArray.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.dataArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.constellation.text = self.dataArray[row];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.constellation resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
