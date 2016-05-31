//
//  ViewController.m
//  AStar
//
//  Created by zjdd on 16/5/30.
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import "ViewController.h"

typedef NS_ENUM(NSInteger, DDSquareType) {
    DDSquareTypeDefault = 0,
    DDSquareTypeWall    = 1,
    DDSquareTypeStart   = 2,
    DDSquareTypeEnd     = 3,
};

@interface DDSquare : UIView

@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) DDSquareType squareType;

+ (DDSquare *)squareWithPoint:(CGPoint)point squareLength:(NSInteger)squareLength squareType:(DDSquareType)squareType;

@end

@implementation DDSquare

+ (DDSquare *)squareWithPoint:(CGPoint)point squareLength:(NSInteger)squareLength squareType:(DDSquareType)squareType {
    
    UIColor *bgColor = [UIColor purpleColor];
    
    switch (squareType) {
        case DDSquareTypeDefault:
        {
            bgColor = [UIColor whiteColor];
        }
            break;
        case DDSquareTypeWall:
        {
            bgColor = [UIColor darkGrayColor];
        }
            break;
        case DDSquareTypeStart:
        {
            bgColor = [UIColor redColor];
        }
            break;
        case DDSquareTypeEnd:
        {
            bgColor = [UIColor greenColor];
        }
            break;
    }
    
    DDSquare *square = [[DDSquare alloc] initWithFrame:CGRectMake((point.x * squareLength),(point.y * squareLength), squareLength, squareLength)];
    square.backgroundColor = bgColor;
    square.layer.borderWidth = 0.5;
    square.layer.borderColor = [UIColor lightGrayColor].CGColor;
    square.point = point;
    square.squareType = squareType;
    return square;
}

@end

@interface ViewController ()

@property (nonatomic, strong) NSMutableDictionary *squares;

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;

@property (nonatomic, strong) NSMutableArray *roads;
@property (nonatomic, strong) NSMutableArray *impassableSquares;

@end

#define SquareKey(x,y) ([NSString stringWithFormat:@"%d_%d",(int)x,(int)y])

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self initMap];
    
    [self search];
}

- (void)search {
    if (CGPointEqualToPoint(self.startPoint, self.endPoint)) {
        NSLog(@"呵呵");
        return;
    }
    
    self.roads = [NSMutableArray array];
    
    DDSquare *startSquare = self.squares[SquareKey(self.startPoint.x, self.startPoint.y)];
    
    if (!startSquare) {
        NSLog(@"呵呵");
        return;
    }
    
    [self.roads addObject:startSquare];
    
    BOOL success = [self findNextStep:startSquare];
    
    if (success) {
        NSLog(@"success");
        [self walkWithStepIndex:0];
    } else {
        NSLog(@"failure");
    }
}

- (BOOL)findNextStep:(DDSquare *)square {
    
    //以防万一
    if (!square) {
        return NO;
    }
    
    //如果当前这个方块已经是终点 则直接结束
    if (square.squareType == DDSquareTypeEnd) {
        return YES;
    }
    
    //寻找可能的下一步
    NSMutableArray *possibleSteps = [self possibleStepsWithSquare:square];
    
    //如果当前没有下一步 则把当前方块加到无效方块中 结束
    if (!possibleSteps.count) {
        [self.impassableSquares addObject:square];
        return NO;
    }
    
    //遍历可能的下一步
    for (DDSquare *nextStep in possibleSteps) {
        
        //先认为当前这步可以
        [self.roads addObject:nextStep];
        
        //如果找到了路径 直接返回
        BOOL success = [self findNextStep:nextStep];
        
        if (success) {
            return YES;
        } else {
            //这步不可以 删除
            [self.roads removeLastObject];
            //顺便把这个走不通的下一步也算为无效
            [self.impassableSquares addObject:nextStep];
        }
    }
    
    return NO;
}

- (NSMutableArray *)possibleStepsWithSquare:(DDSquare *)square {
    if ((square.squareType == DDSquareTypeWall) || (square.squareType == DDSquareTypeEnd)) {
        return nil;
    }
    
    DDSquare *left  = [self.squares objectForKey:SquareKey(square.point.x - 1, square.point.y)];
    DDSquare *up    = [self.squares objectForKey:SquareKey(square.point.x, square.point.y - 1)];
    DDSquare *right = [self.squares objectForKey:SquareKey(square.point.x + 1, square.point.y)];
    DDSquare *down  = [self.squares objectForKey:SquareKey(square.point.x, square.point.y + 1)];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    if ([self isValidateStep:left])     {[arr addObject:left];}
    if ([self isValidateStep:up])       {[arr addObject:up];}
    if ([self isValidateStep:right])    {[arr addObject:right];}
    if ([self isValidateStep:down])     {[arr addObject:down];}
    
    if (arr.count) {
        
        [arr sortUsingComparator:^NSComparisonResult(DDSquare *obj1, DDSquare *obj2) {
            if ([self estimatedStepsWithSquare:obj1] < [self estimatedStepsWithSquare:obj2]) {
                return NSOrderedAscending;
            }
            return NSOrderedDescending;
        }];
        
        return arr;
    }
    
    return nil;
}

- (BOOL)isValidateStep:(DDSquare *)square {
    if (square && ![self.roads containsObject:square] && ![self.impassableSquares containsObject:square]) {
        return YES;
    }
    return NO;
}

- (NSInteger)estimatedStepsWithSquare:(DDSquare *)square {
    NSInteger xSteps = labs((NSInteger)(self.endPoint.x - square.point.x));
    NSInteger ySteps = labs((NSInteger)(self.endPoint.y - square.point.y));
    return xSteps + ySteps;
}

#pragma mark - Init Map

- (void)initMap {
    
    NSArray *map = @[
                     @[@1,@1,@1,@1,@1,@1,@1,@1,@1,@1,@1,@1],
                     @[@1,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@1],
                     @[@1,@2,@0,@1,@0,@1,@1,@1,@1,@1,@1,@1],
                     @[@1,@0,@0,@1,@0,@1,@0,@0,@0,@0,@0,@1],
                     @[@1,@0,@0,@1,@0,@1,@1,@0,@0,@1,@3,@1],
                     @[@1,@0,@0,@1,@0,@0,@1,@0,@0,@1,@0,@1],
                     @[@1,@0,@0,@1,@1,@1,@1,@0,@0,@1,@0,@1],
                     @[@1,@0,@0,@1,@0,@0,@0,@0,@0,@1,@0,@1],
                     @[@1,@0,@0,@0,@0,@0,@0,@1,@1,@1,@0,@1],
                     @[@1,@0,@0,@0,@0,@0,@0,@1,@0,@0,@0,@1],
                     @[@1,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@1],
                     @[@1,@1,@1,@1,@1,@1,@1,@1,@1,@1,@1,@1],
                     ];
    
    NSInteger rowCount = map.count;
    NSInteger squareLength = (NSInteger)([UIScreen mainScreen].bounds.size.width / (rowCount + 4));
    
    UIView *mapView = [[UIView alloc] initWithFrame:CGRectMake(squareLength * 2, squareLength * 2, squareLength * rowCount, squareLength * rowCount)];
    [self.view addSubview:mapView];
    
    self.squares = [NSMutableDictionary dictionary];
    self.impassableSquares = [NSMutableArray array];
    
    for (int y = 0; y < map.count; y++) {
        NSArray *row = map[y];
        for (int x = 0; x < row.count; x++) {
            NSNumber *squareTypeNumber = row[x];
            DDSquareType squareType = squareTypeNumber.integerValue;
            
            switch (squareType) {
                case DDSquareTypeStart:
                {
                    self.startPoint = CGPointMake(x, y);
                }
                    break;
                case DDSquareTypeEnd:
                {
                    self.endPoint = CGPointMake(x, y);
                }
                    break;
                default:
                    break;
            }
            
            DDSquare *square = [DDSquare squareWithPoint:CGPointMake(x, y) squareLength:squareLength squareType:squareType];
            [mapView addSubview:square];
            
            [self.squares setObject:square forKey:SquareKey(x, y)];
            
            if (squareType == DDSquareTypeWall) {
                [self.impassableSquares addObject:square];
            }
        }
    }
}

#pragma mark - Walk

- (void)walkWithStepIndex:(NSInteger)index {
    if (index < 0 || index >= self.roads.count) {
        return;
    }
    
    DDSquare *square = self.roads[index];
    [UIView animateWithDuration:0.1
                          delay:0.1
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         square.backgroundColor = [UIColor lightGrayColor];
                     }
                     completion:^(BOOL finished) {
                         [self walkWithStepIndex:index+1];
                     }];
}

@end
