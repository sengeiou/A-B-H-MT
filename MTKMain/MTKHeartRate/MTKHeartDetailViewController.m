//
//  MTKHeartDetailViewController.m
//  MTK
//
//  Created by 有限公司 深圳市 on 16/6/15.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "MTKHeartDetailViewController.h"

@interface MTKHeartDetailViewController ()
{
    NSMutableArray *hisHrArr;
}
@end

@implementation MTKHeartDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [self initializeMethod];
    [self createUI];
}

//加载dal对象
-(MTKSqliteData *)sqliData
{
    if(!_sqliData)
    {
        _sqliData=[[MTKSqliteData alloc]init];
    }
    return _sqliData;
}

#pragma mark *******初始化
- (void)initializeMethod{
    [self readHRdate];
}

#pragma mark *******创建UI
- (void)createUI{
    self.hisTabView.delegate = self;
    self.hisTabView.dataSource = self;
    self.hearLab.hrStr = [[hisHrArr firstObject] objectForKey:@"HEART"]?[[hisHrArr firstObject] objectForKey:@"HEART"]:@"0";
    self.hrLab.text = self.hearLab.hrStr;
    if (self.hrLab.text.intValue < 60) {
        self.hrLab.textColor = [UIColor colorWithRed:47/255.0 green:145/255.0 blue:206/255.0 alpha:1];
    }
    else if (self.hrLab.text.intValue >= 60 && self.hrLab.text.intValue <= 100){
        self.hrLab.textColor = [UIColor colorWithRed:86/255.0 green:170/255.0 blue:48/255.0 alpha:1];
    }
    else{
        self.hrLab.textColor = [UIColor colorWithRed:241/255.0 green:20/255.0 blue:73/255.0 alpha:1];
    }

    self.surveyLab.text = MtkLocalizedString(@"hearRate_monitor");
    self.normLab.text = MtkLocalizedString(@"hearRate_norm");
    self.hisLab.text = MtkLocalizedString(@"hearRate_his");
    self.timeLab.text = MtkLocalizedString(@"hearRate_date");
    self.heTexLab.text = MtkLocalizedString(@"hearRate_bpm");
    self.typeLab.text = MtkLocalizedString(@"hearRate_status");
    [self.hearLab setNeedsLayout];
}

- (void)updateUI{
   [self initializeMethod];
    [self createUI];
}

- (void)readHRdate{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
     hisHrArr = [self.sqliData scarchHisHeartWitchDate:[formatter stringFromDate:self.date] userID:[MTKArchiveTool getUserInfo].userID];
}

#pragma mark *******UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MTKHRHisTableViewCell *cell = (MTKHRHisTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"HISTARYCELL"];
    cell.timeLab.text = [NSString stringWithFormat:@"%@ %@",[self appendString:[[hisHrArr objectAtIndex:(indexPath.row )] objectForKey:@"DATE"] withStr:@"/"],[self appendString:[hisHrArr[indexPath.row ] objectForKey:@"TIME"] withStr:@":"]];
    NSString *hr = [hisHrArr[indexPath.row ] objectForKey:@"HEART"];
    cell.hrLab.text = hr;
    if (hr.intValue < 60) {
        cell.sypeLab.text = MtkLocalizedString(@"hearReat_slow");
        cell.sypeLab.textColor = [UIColor colorWithRed:47/255.0 green:145/255.0 blue:206/255.0 alpha:1];
        cell.hrLab.textColor = [UIColor colorWithRed:47/255.0 green:145/255.0 blue:206/255.0 alpha:1];
    }
    else if (hr.intValue >= 60 && hr.intValue <= 100){
         cell.sypeLab.text = MtkLocalizedString(@"hearReat_normal");
         cell.sypeLab.textColor = [UIColor colorWithRed:86/255.0 green:170/255.0 blue:48/255.0 alpha:1];
        cell.hrLab.textColor = [UIColor colorWithRed:86/255.0 green:170/255.0 blue:48/255.0 alpha:1];
    }
    else{
         cell.sypeLab.text = MtkLocalizedString(@"hearReat_High");
         cell.sypeLab.textColor = [UIColor colorWithRed:241/255.0 green:20/255.0 blue:73/255.0 alpha:1];
        cell.hrLab.textColor = [UIColor colorWithRed:241/255.0 green:20/255.0 blue:73/255.0 alpha:1];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return hisHrArr.count;
}


- (NSMutableString *)appendString:(NSString *)str withStr:(NSString *)string{
    //拼接字符串
    NSMutableString *addString = [NSMutableString string];
    for (int i = 0; i < ([string isEqualToString:@"/"] ? 3 : str.length); i ++) {
        NSLog(@"%@  %d",[str substringWithRange:NSMakeRange(i, 2)],[string isEqualToString:@"/"] ? 3 : str.length);
        if (i == 0 && [string isEqualToString:@"/"]) {
             [addString appendString:[str substringWithRange:NSMakeRange(i, 4)]];
        }
        else if (i != 0 && [string isEqualToString:@"/"]){
            [addString appendString:[str substringWithRange:NSMakeRange(i*2+2, 2)]];
        }
        else if([string isEqualToString:@":"]){
            [addString appendString:[str substringWithRange:NSMakeRange(i, 2)]];
            i++;
        }
        if (i < ([string isEqualToString:@"/"] ? 2 : 4)) {
            [addString appendString:string];
        }
    }
    return  addString;
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
