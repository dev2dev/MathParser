#import <Foundation/Foundation.h>
#import "ExpressionParser.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	ExpressionParser *parser = [[ExpressionParser alloc] init];
	NSLog(@"The result is:%i",[parser evaluate:@"2+7"]);
	NSLog(@"The result is:%i",[parser evaluate:@"9-0"]);
	NSLog(@"The result is:%i",[parser evaluate:@"10-1"]);
	NSLog(@"The result is:%i",[parser evaluate:@"(2+7)"]);
	NSLog(@"The result is:%i",[parser evaluate:@"(10-1)"]);
	NSLog(@"The result is:%i",[parser evaluate:@"3*3"]);
	NSLog(@"The result is:%i",[parser evaluate:@"(3*3)"]);
	NSLog(@"The result is:%i",[parser evaluate:@"18/2"]);
	NSLog(@"The result is:%i",[parser evaluate:@"19%10"]);
	NSLog(@"The result is:%i",[parser evaluate:@"3^2"]);
	NSLog(@"The result is:%i",[parser evaluate:@"-(-3^2)"]);
	NSLog(@"The result is:%i",[parser evaluate:@"1+4*2"]);
	NSLog(@"The result is:%i",[parser evaluate:@"(1+2)*3"]);

	
	[parser release];
    [pool drain];
    return 0;
}
