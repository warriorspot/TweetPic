
#import "TweetPicManagerTests.h"
#import "TweetPicManager.h"
#import "TweetPicManager+Private.h"

@implementation TweetPicManagerTests

- (void) testLongestWordInTweet
{
    NSString *tweet = @"a an big word words amalgamation no";
    NSString *tweet2 = @"foo bar baz";
    NSString *tweet3 = @"a cheeseburger dog";
    
    TweetPicManager *manager = [[TweetPicManager alloc] init];
    
    NSString *result = [manager longestWordInTweet:nil];
    STAssertNil(result, @"should return nil for nil argument");
    
    result = [manager longestWordInTweet:@""];
    STAssertNil(result, @"should return nil for 0 length string");
    
    result = [manager longestWordInTweet: tweet];
    STAssertTrue([result isEqualToString: @"amalgamation"], @"longest word should be amalgamation");
    
    result = [manager longestWordInTweet: tweet2];
    STAssertTrue([result isEqualToString: @"foo"], @"longest word should be foo");
    
    result = [manager longestWordInTweet: tweet3];
    STAssertTrue([result isEqualToString: @"cheeseburger"], @"longest word should be cheeseburger");
    
    
}

@end
