
#import "TweetRequest.h"

@implementation TweetRequest

@synthesize active;
@synthesize request;

- (void) start
{
    [self startWithSearchTerm:nil];
}

- (void) startWithSearchTerm:(NSString *)searchTerm
{
    if(searchTerm == nil || [searchTerm length] == 0)
    {
        return;
    }
    
    active = YES;
    
    NSMutableString *baseURL = [NSMutableString stringWithString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"TwitterBaseURL"]];
    NSString *path = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"TwitterPath"];
    NSString *term = [searchTerm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *searchString = [NSString stringWithFormat: path, term];
    [baseURL appendString: searchString];
    
    NSURL *url = [NSURL URLWithString: baseURL];
    
    request = [[TWRequest alloc] initWithURL: url
                                  parameters: nil 
                               requestMethod: TWRequestMethodGET];
    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        active = NO;
        
        if ([urlResponse statusCode] == 200) 
        {
            NSError *error;        
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData 
                                                                 options:0 
                                                                   error:&error];
            NSLog(@"Twitter response: %@", json); 
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(request:didSucceed:)])
            {
                [self.delegate request:self didSucceed:json];                    
            }
        }
        else
        {
            NSLog(@"Twitter error, HTTP response: %i", [urlResponse statusCode]);
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(request:didFailWithError:)])
            {
                [self.delegate request:self didFailWithError:error];                    
            }
        }
    }];
}

@end


