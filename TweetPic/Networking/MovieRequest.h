
#import <Foundation/Foundation.h>
#import "Request.h"

@class SimpleRESTRequest;

@interface MovieRequest : Request

@property (nonatomic, strong) SimpleRESTRequest *request;

@end
