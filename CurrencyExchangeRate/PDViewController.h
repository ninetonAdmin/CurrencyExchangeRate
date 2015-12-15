
#import <UIKit/UIKit.h>

@interface PDViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (strong,nonatomic) NSDictionary *names;
@property (strong,nonatomic) NSMutableDictionary *mutableNames;
@property (strong,nonatomic) NSMutableArray *mutableKeys;
//可变字典和可变数组，用于存储显示的数据，而不可变的字典用于存储从文件中读取的数据

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UISearchBar *search;

-(void)resetSearch;
//重置搜索，即恢复到没有输入关键字的状态
-(void)handleSearchForTerm:(NSString *)searchTerm;
//处理搜索，即把不包含searchTerm的值从可变数组中删除

@end