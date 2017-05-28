
#import <Foundation/Foundation.h>

/*
 * 找出最长连续数字序列
 * 在本例中应当输出 5 6 7 8 9
 */

int main(int argc, char *argv[]) {
	@autoreleasepool {
		NSArray<NSNumber *> *valueArray = @[@(31),@(6),@(32),@(1),@(3),@(2),@(5),@(9),@(12),@(8),@(19),@(7)];
		
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
				CGPoint pointForSub = valueForSub.pointValue;
				
				if (pointForSub.x < minValue) {
					minValue = pointForSub.x;
				}
				
				if (pointForSub.y > maxValue) {
					maxValue = pointForSub.y;
				}
			}
			
			if (valueForAdd) {
				CGPoint pointForAdd = valueForAdd.pointValue;
				
				if (pointForAdd.x < minValue) {
					minValue = pointForAdd.x;
				}
				
				if (pointForAdd.y > maxValue) {
					maxValue = pointForAdd.y;
				}
			}
			
			CGPoint currentRange = CGPointMake(minValue, maxValue);
			
			if (valueForSub) {
				[rangeMap setObject:[NSValue valueWithPoint:currentRange] forKey:@(val-1)];
			}

			if (valueForAdd) {
				[rangeMap setObject:[NSValue valueWithPoint:currentRange] forKey:@(val+1)];
			}
			
			[rangeMap setObject:[NSValue valueWithPoint:currentRange] forKey:@(val)];
			
			NSUInteger currentLength = maxValue - minValue;
			if (currentLength > currentMaxLength) {
				currentMaxLength = currentLength;
				maxLengthNumber = @(val);
			}
			
			if ((i+1) >= valueArray.count) {
				NSString *numberSequence = [NSString string];
				CGPoint maxRange = [rangeMap objectForKey:maxLengthNumber].pointValue;
				for (NSInteger i = maxRange.x ; i <= maxRange.y ; i++) {
					numberSequence = [numberSequence stringByAppendingString:[NSString stringWithFormat:@"%@ ",@(i).stringValue]];
				}
				NSLog(@"max length = %@ , and the number sequence is : %@",@(currentMaxLength+1),numberSequence);
			}
		}
	}
}
