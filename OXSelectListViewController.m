#import "OXSelectListViewController.h"

@interface OXSelectListViewController (){
    UITableView *selectTableview;
    NSMutableArray *cellDataArr;
    NSMutableArray *syTitleArray;//索引名称列表
    NSMutableArray *syIndexArray;//索引位置
    UISearchBar *oxSearchBar;
}

@end

@implementation OXSelectListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initData];
//    [self setUI];
}

-(void)initData{
    cellDataArr = [NSMutableArray new];
    syTitleArray = [NSMutableArray new];
    syIndexArray = [NSMutableArray new];
    
    [self AFNGetData];
}

//获取网络数据
-(void)AFNGetData{
    //乱序原数据
    dArr = @[@{@"id":@"1",@"name":@"忆江南",@"img":@""},
             @{@"id":@"2",@"name":@"长相思",@"img":@""},
             @{@"id":@"3",@"name":@"渔歌子",@"img":@""},
             @{@"id":@"4",@"name":@"虞美人",@"img":@""},
             @{@"id":@"5",@"name":@"定风波",@"img":@""},
             @{@"id":@"6",@"name":@"水调歌头",@"img":@""},
             @{@"id":@"7",@"name":@"清平乐",@"img":@""},
             @{@"id":@"8",@"name":@"点绛唇",@"img":@""},
             @{@"id":@"9",@"name":@"相见欢",@"img":@""},
             @{@"id":@"10",@"name":@"996",@"img":@""},
             @{@"id":@"11",@"name":@"ICU",@"img":@""},
             @{@"id":@"12",@"name":@"孙悟空",@"img":@""},
             @{@"id":@"13",@"name":@"鲁智深",@"img":@""},
             @{@"id":@"14",@"name":@"曹阿瞒",@"img":@""},
             @{@"id":@"15",@"name":@"林黛玉",@"img":@""},
             @{@"id":@"12",@"name":@"孙悟空2",@"img":@""},
             @{@"id":@"13",@"name":@"鲁智深2",@"img":@""},
             @{@"id":@"14",@"name":@"曹阿瞒2",@"img":@""},
             @{@"id":@"15",@"name":@"林黛玉2",@"img":@""},
    ];
    [self initAFNData:dArr];
//    [selectTableview reloadData];
    
    //排序后结果
    NSLog(@"%@",cellDataArr);
    
}

-(void)initAFNData:(NSArray*)dArr{
    syIndexArray = [NSMutableArray new];
    cellDataArr = [NSMutableArray arrayWithArray:dArr];
    //cellDataArr 排序
    cellDataArr = [self SortPinYin:cellDataArr];
    
    //syTitleArray 去重 分组
    for (int i = 0; i<cellDataArr.count; i++) {
        NSDictionary *dic = cellDataArr[i];
        NSString*syStr = [dic[@"pinYin"] substringWithRange:NSMakeRange(0, 1)];
        
        if (![syTitleArray containsObject:syStr]) {
            [syTitleArray addObject:syStr];
            [syIndexArray addObject:@(i)];//记录"组头"下标
        }
    }
}

-(NSMutableArray*)SortPinYin:(NSArray*)oldArr{
    //中文排序。
    NSMutableArray *NewArray=[NSMutableArray array];

    for(int i=0;i<[oldArr count];i++){
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:oldArr[i]];
        NSString *name = dic[@"name"];
        if(name==nil){
            name=@"";
        }
        if(![name isEqualToString:@""]){
            NSString *pinYinResult=[NSString string];
            //循环取每个汉字
            for(int j=0;j<name.length;j++){
                NSString *charjStr = [name substringWithRange:NSMakeRange(j, 1)];
                NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%@",[self pinyinFirstLetter:charjStr]] uppercaseString];
                pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            
            dic[@"pinYin"]=pinYinResult;
            
        }else{
            dic[@"pinYin"]=@"";
        }
        [NewArray addObject:dic];
    }
    
    //开始排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [NewArray sortUsingDescriptors:sortDescriptors];
    
    return NewArray;
}

//获取首字母
- (NSString *) pinyinFirstLetter:(NSString*)sourceString {
    NSMutableString *source = [sourceString mutableCopy];
    if (sourceString.length>0) {
        CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);//去声调
        sourceString = [[source substringToIndex:1] uppercaseString];
    }
    return sourceString;
}


//#pragma mark-UITableViewDelegate,UITableViewDataSource

//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString* cellname = @"mycell";
//    UITableViewCell* cell = [tableView
//                             dequeueReusableCellWithIdentifier:cellname];
//    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellname];
//    [cell setExclusiveTouch:YES];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    if (cellDataArr.count>0){
//        NSDictionary *dic = cellDataArr[indexPath.row];
//        cell.textLabel.text = dic[@"name"];
//    }
//
//    if (nil == cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellname];
//    }
//    return cell;
//}


//MARK:索引
//-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return syTitleArray;
//}

//-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
//    for (UIView *view in [tableView subviews]) {
//        if ([view isKindOfClass:[NSClassFromString(@"UITableViewIndex") class]]) {
//            // 设置字体大小
//            [view setValue:Font(16) forKey:@"_font"];
//            //设置view的大小
//            view.bounds = CGRectMake(0, 0, 120, 30);
//            //单单设置其中一个是无效的,宽度改不了
//        }
//    }
//}

#pragma mark - 索引列点击事件

//-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    NSString *name = syTitleArray[index];
//    NSInteger sjIndex = [syIndexArray[index] integerValue];
//    if (name.length>0) {
//        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:sjIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    }
//
//    MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:[[UIApplication sharedApplication].windows lastObject]];
//    HUD.contentColor = [UIColor whiteColor];
//    HUD.bezelView.color = [UIColor lightGrayColor];
//    HUD.mode = MBProgressHUDModeText;
//    HUD.userInteractionEnabled = NO;
//    HUD.label.text = syTitleArray[index];
//    HUD.minSize = CGSizeMake(120, 120);
//    HUD.square = YES;
//    HUD.removeFromSuperViewOnHide = YES;
//    [self.view addSubview:HUD];
//    [HUD showAnimated:YES];
//    [HUD hideAnimated:YES afterDelay:1.0];
//
//    return index;
//}

@end
