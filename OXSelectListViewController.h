
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SLReturnBlock) (NSDictionary *blockDic);

@interface OXSelectListViewController : UIViewController

@property(nonatomic, copy) SLReturnBlock returnBlock;

@property(nonatomic, assign) BOOL isShowImg;
@property(nonatomic, strong) NSString* urlStr;
@property(nonatomic, strong) NSArray* cellDArr;


@end

NS_ASSUME_NONNULL_END
