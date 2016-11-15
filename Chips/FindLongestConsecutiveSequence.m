#import <Foundation/Foundation.h>

int main(int argc, char *argv[]) {
	@autoreleasepool {
		NSArray<NSNumber *> *valueArray = @[@(31),@(6),@(32),@(1),@(3),@(2)];
		
		NSMutableDictionary<NSNumber *,NSValue *> *map = [NSMutableDictionary dictionary];
		
		NSUInteger length = 0;
		NSNumber *key = nil;
		
		for (NSInteger i = 0 ; i < valueArray.count ; i++) {			
			NSInteger val = valueArray[i].integerValue;
			
			NSInteger minValue = val;
			NSInteger maxValue = val;
			
			NSValue *valueForSub = [map objectForKey:@(val-1)];
			NSValue *valueForAdd = [map objectForKey:@(val+1)];
			
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
				[map setObject:[NSValue valueWithPoint:currentRange] forKey:@(val-1)];
			}

			if (valueForAdd) {
				[map setObject:[NSValue valueWithPoint:currentRange] forKey:@(val+1)];
			}
			
			[map setObject:[NSValue valueWithPoint:currentRange] forKey:@(val)];
			
			NSUInteger currentLength = maxValue - minValue;
			if (currentLength > length) {
				length = currentLength;
				key = @(val);
			}
			
			if ((i+1) >= valueArray.count) {
				NSString *numberSequence = [NSString string];
				CGPoint maxRange = [map objectForKey:key].pointValue;
				for (NSInteger i = maxRange.x ; i <= maxRange.y ; i++) {
					numberSequence = [numberSequence stringByAppendingString:@(i).stringValue];
					numberSequence = [numberSequence stringByAppendingString:@" "];
				}
				NSLog(@"max length = %@ , and the number sequence is : %@",@(length+1),numberSequence);
			}
		}
	}
}