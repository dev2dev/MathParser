//
//  ExpressionParser.h
//  IPhoneMath24
//
//  Created by Rongde Yang on 6/25/09.
//  Copyright 2009 Jawasoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ExpressionParser : NSObject {
@private
	
	NSString *exp;
	NSString *currentToken;
	int expIdx;
	int tokType;
}
- (int)evaluate:(NSString *)expStr;
@end
