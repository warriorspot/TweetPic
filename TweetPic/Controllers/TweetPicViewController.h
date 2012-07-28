
#import <UIKit/UIKit.h>

@interface TweetPicViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) IBOutlet UISearchBar *tweetSearchBar;
@property (nonatomic, assign) IBOutlet UITableView *tweetPicTableView;
@property (nonatomic, assign) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, assign) IBOutlet UILabel *tweetPicCountLabel;
@property (nonatomic, strong) NSMutableArray *tweetPics;

@end

extern NSString * const DidEnterSearchTermNotification;
extern NSString * const SearchTermKey;
