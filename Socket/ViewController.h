//
//  ViewController.h
//  Socket
//
//  Created by opc on 27/07/2016.
//  Copyright © 2016 opc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>


@interface ViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) CMMotionManager *motionManager;
@property (nonatomic) BOOL connected;
@property (strong, nonatomic) NSArray *ButtonList;


@property (weak, nonatomic) IBOutlet UILabel *x;
@property (weak, nonatomic) IBOutlet UILabel *y;
@property (weak, nonatomic) IBOutlet UILabel *direction;

@end

