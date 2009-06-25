//
//  ExpressionParser.m
//  IPhoneMath24
//
//  Created by Rongde Yang on 6/25/09.
//  Copyright 2009 Jawasoft. All rights reserved.
//

#import "ExpressionParser.h"

#define NONE			0
#define DELIMITER		1
#define VARIABLE		2
#define NUMBER			3


#define EOE				@"\0" 

@implementation ExpressionParser

- (int)evaluate:(NSString *)expStr{
	int result;
	exp = expStr;
	expIdx = 0;
	[self getToken];
	if([currentToken isEqualToString:EOE]){
		[NSException raise:@"No Expression Present" format:@"No Expression Present"];
	}
	
	result = [self evalAddSubtract];
	
	if(![currentToken isEqualToString:EOE]){
		[NSException raise:@"Syntax Error" format:@"Syntax Error"];
	}
	
	return result;
}

- (int)evalAddSubtract{
	NSString *op;
	int result;
	int partialResult;
	
	result = [self evalUnaryAddSub];
	
	while ([(op = currentToken) isEqualToString:@"+"]
		|| [op isEqualToString:@"-"]) {
		[self getToken];
		partialResult = [self evalTimeDiv];
		if([op isEqualToString:@"-"]) {
			result = result - partialResult;
		}else{
			result = result + partialResult;
		
		}
	}
	[op release];
	return result;
}


- (int)evalTimeDiv{
	NSString *op;
	int result;
	int partialResult;
	
	result = [self evalExponent];
	
	while ([(op = currentToken) isEqualToString:@"*"]
		   || [op isEqualToString:@"/"] || [op isEqualToString:@"%"]) {
		[self getToken];
		partialResult = [self evalExponent];
		if([op isEqualToString:@"*"]) {
			result = result * partialResult;
		}else if([op isEqualToString:@"/"]){
			if(partialResult == 0){
				[NSException raise:@"Division by Zero" format:@"Division by Zero"];
			}
			result = result / partialResult;
		}else{
			if(partialResult == 0){
				[NSException raise:@"Division by Zero" format:@"Division by Zero"];
			}
			result = result % partialResult;
		}
	}
	[op release];
	return result;
}


- (int)evalExponent{
	int result,partialResult, ex, t;
	result = [self evalBracket];
	if([currentToken isEqualToString:@"^"]){
		[self getToken];
		partialResult = [self evalExponent];
		ex = result;
		if(partialResult == 0){
			result = 1;
		}else{
			for (t= partialResult -1; t>0; t--) {
				result = result * ex;
			}
		}
	}
	
	return result;
}

- (int)evalUnaryAddSub{
	int result;
	NSString *op = @"";
	if((tokType == DELIMITER) && [currentToken isEqualToString:@"+"]
	   || [currentToken isEqualToString:@"-"]){
		op = currentToken;
		[self getToken];
	}
	result = [self evalTimeDiv];
	if([op isEqualToString:@"-"]){
		result = result * (-1);
	}
	
	[op release];
	return result;
}


- (int)evalBracket{
	int result;
	
	if([currentToken isEqualToString:@"("]){
		[self getToken];
		result = [self evalAddSubtract];
		if(![currentToken isEqualToString:@")"]){
			[NSException raise:@"Unbalanced Parentheses" format:@"Unbalanced Parentheses"];
		}
		[self getToken];
	}else{
		result = [self atom];
	}
	return result;
}

- (int)atom{
	int result = 0;
	
	if(tokType == NUMBER){
		result = [currentToken intValue];
		[self getToken];
	}else{
		[NSException raise:@"Syntax Error" format:@"Syntax Error"];
	}
	return result;
}

- (void)getToken{
	tokType = NONE;
	
	if(expIdx == [exp length]){
		currentToken = EOE;
		return;
	} 
	int length = [exp length];
	while (expIdx < length && [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[exp characterAtIndex:expIdx]]  ) {
		++expIdx;
	}
			
	if(expIdx == [exp length]){
		currentToken = EOE;
		return;
	}
	
	if([self isDelim:[exp characterAtIndex:expIdx]]){
		
		currentToken = [NSString stringWithFormat:@"%c",[exp characterAtIndex:expIdx]];
		expIdx ++;
		tokType = DELIMITER;
	}else if([[NSCharacterSet decimalDigitCharacterSet] characterIsMember: [exp characterAtIndex:expIdx]]){
		
		int startIdx = expIdx;
		while (![self isDelim:[exp characterAtIndex:expIdx]]) {
			
			currentToken = [[exp substringToIndex:expIdx+1] substringFromIndex:startIdx];
			expIdx ++;
			if(expIdx >= [exp length]){
				break;
			}
		}
		tokType = NUMBER;
		
	}else{
		currentToken = EOE;
		return;
	}
	
}

- (BOOL)isDelim:(unichar)c{
	return [[NSString stringWithString: @" +-*/^()%"] rangeOfString:[NSString stringWithFormat:@"%c",c]].length>0;		
}
@end
