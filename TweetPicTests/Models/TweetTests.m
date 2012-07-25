
#import "TweetTests.h"
#import "Tweet.h"

@implementation TweetTests

- (void) testLongestWordInTweet
{
    NSString *tweet = @"a an big word words amalgamation no";
    NSString *tweet2 = @"foo bar baz";
    NSString *tweet3 = @"a cheeseburger dog";
    
    Tweet *t1 = [[Tweet alloc] initWithTweetId:@"1" tweet:tweet];
    Tweet *t2 = [[Tweet alloc] initWithTweetId:@"2" tweet:tweet2];
    Tweet *t3 = [[Tweet alloc] initWithTweetId:@"3" tweet:tweet3];
    
    NSString *result = [t1 longestWordInTweet];
    STAssertTrue([result isEqualToString: @"amalgamation"], @"longest word should be amalgamation");
    
    result = [t2 longestWordInTweet];
    STAssertTrue([result isEqualToString: @"foo"], @"longest word should be foo");
    
    result = [t3 longestWordInTweet];
    STAssertTrue([result isEqualToString: @"cheeseburger"], @"longest word should be cheeseburger");
}

@end
