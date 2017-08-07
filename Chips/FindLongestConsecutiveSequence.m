
#import <Foundation/Foundation.h>

/*
 * 找出最长连续数字序列
 * 在本例中应当输出 2 3 4 5 6
 */

int main(int argc, char *argv[]) {
	@autoreleasepool {
		NSArray<NSNumber *> *valueArray = @[@21,@4,@3,@2,@8,@22,@47,@23,@24,@5,@6];
		
		NSMutableDictionary<NSNumber *,NSValue *> *rangeMap = [NSMutableDictionary dictionary];
		
		NSUInteger currentMaxLength = 0;
		NSNumber *maxLengthNumber = nil;
		
		for (NSInteger i = 0 ; i < valueArray.count ; i++) {			
			NSInteger val = valueArray[i].integerValue;
			
			NSInteger minValue = val;
			NSInteger maxValue = val;
			
			NSValue *valueForSub = [rangeMap objectForKey:@(val-1)];
			NSValue *valueForAdd = [rangeMap objectForKey:@(val+1)];
			
			if (valueForSub) {
				minValue = valueForSub.pointValue.x;
			}
			
			if (valueForAdd) {
				maxValue = valueForAdd.pointValue.y;
			}
			
			NSValue *currentRange = [NSValue valueWithPoint:CGPointMake(minValue, maxValue)];
			[rangeMap setObject:currentRange forKey:@(minValue)];
			[rangeMap setObject:currentRange forKey:@(maxValue)];
			
			NSUInteger currentLength = maxValue - minValue;
			if (currentLength > currentMaxLength) {
				currentMaxLength = currentLength;
				maxLengthNumber = @(maxValue);
			}
		}
		
		NSString *numberSequence = [NSString string];
		CGPoint maxRange = [rangeMap objectForKey:maxLengthNumber].pointValue;
		for (NSInteger i = maxRange.x ; i <= maxRange.y ; i++) {
			numberSequence = [numberSequence stringByAppendingString:[NSString stringWithFormat:@"%@ ",@(i).stringValue]];
		}
		NSLog(@"max length = %@ , and the number sequence is : %@",@(currentMaxLength+1),numberSequence);
	}
}
