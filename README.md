# 中文排序
后台数据没分组，排序，UI需要索引。手动排序
``` Object-C
//主要代码
-(NSMutableArray*)SortPinYin:(NSArray*)oldArr{
    //中文排序。
    NSMutableArray *NewArray=[NSMutableArray array];

    for(int i=0;i<[oldArr count];i++){
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:oldArr[i]];
        NSString *name = dic[@"name"];//设置需要排序的字段名
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

//使用
/**
*NSMutableArray *syTitleArray;//索引名称列表
*NSMutableArray *syIndexArray;//索引位置
*/

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

```

