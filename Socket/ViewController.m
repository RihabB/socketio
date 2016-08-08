//
//  ViewController.m
//  Socket
//
//  Created by opc on 27/07/2016.
//  Copyright © 2016 opc. All rights reserved.
//

#import "ViewController.h"
#import "Socket-Swift.h"

@interface ViewController ()

@end

@implementation ViewController

int up = 1;
int upRight = 2;
int right = 3;
int downRight =4;
int down=5;
int downLeft =6;
int left =7;
int upLeft =8;

SocketIOClient*  s=nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver: self
                           selector: @selector (onStickChanged:)
                               name: @"StickChanged"
                             object: nil];

    
     NSURL* url = [[NSURL alloc] initWithString:@"http://10.54.234.55:3000/"];
    
    
    //[socket sendEvent:@"chat" withData:@"hello"];
    s = [[SocketIOClient alloc] initWithSocketURL:url options:@{@"log": @YES, @"forcePolling": @YES}];

    [s on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected");
    }];
    
//    [socket emit:@"chat" withItems:@[@"heyy"]];

    
    [s on:@"message" callback:^(NSArray* data, SocketAckEmitter* ack) {
        
        [s emit:@"chat" withItems:@[@"heyy"]];
   

    }];
    
    [s connect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray*)ButtonList
{
    if (!_ButtonList) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ButtonOrder" ofType:@"plist"];
        _ButtonList = [[NSArray alloc]initWithContentsOfFile:plistPath];
    }
    return _ButtonList;
}
- (void)startExamine
{
    self.motionManager = [[CMMotionManager alloc]init];
    self.motionManager.accelerometerUpdateInterval = 0.01;
    if ([self.motionManager isAccelerometerAvailable]){
        NSLog(@"Accelerometer is available.");
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        CMAccelerometerHandler handler = ^(CMAccelerometerData *accelerometerData, NSError *error){
            float dx = accelerometerData.acceleration.x,
            dy = accelerometerData.acceleration.y,
            dz = accelerometerData.acceleration.z;
            NSLog(@"x:%g y:%g z:%g",dx,dy,dz);
        };
        [self.motionManager startAccelerometerUpdatesToQueue: queue
                                                 withHandler: handler];
    }
}



- (void)onStickChanged:(id)notification
{
    NSDictionary *dict = [notification userInfo];
    NSValue *vdir = [dict valueForKey:@"dir"];
    CGPoint dir = [vdir CGPointValue];
    NSLog(@"%g %g",dir.x,dir.y);
    _x.text =[NSString stringWithFormat:@"%f",dir.x];
    _y.text =[NSString stringWithFormat:@"%f",dir.y];
    
     
    [s on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket connected");
    }];

    
    
    if ((dir.x==0)&&(dir.y==0))
    {_direction.text=@"Center";}
    
    else if ((dir.x>0.866025) && (fabs(dir.y)<0.5))
    {_direction.text=@"Right";
        
        [s emit:@"chat" withItems:@[@"3"]];
         

    }
    else if ((dir.x<0.866025) && (dir.x>0.5) && (dir.y<0.866025) && (dir.y>0.5))
    {_direction.text=@"Down Right";
        
            [s emit:@"chat" withItems:@[@"4"]];
        
    }
    
    else if ((dir.x<0.866025) && (dir.x>0.5) && (dir.y>-0.866025) && (dir.y<-0.5))
    {_direction.text=@"Up Right";
            [s emit:@"chat" withItems:@[@"2"]];
        
    }
    
    else if ((dir.x<-0.866025) && (fabs(dir.y)<0.5))
    {_direction.text=@"Left";
       
            [s emit:@"chat" withItems:@[@"7"]];

    }
    
    else if ((dir.x>-0.866025) && (dir.x<-0.5) && (dir.y<0.866025) && (dir.y>0.5))
    {_direction.text=@"Down Left";
       
            [s emit:@"chat" withItems:@[@"6"]];
        
    }
    
    else if ((dir.x>-0.866025) && (dir.x<-0.5) && (dir.y>-0.866025) && (dir.y<-0.5))
    {_direction.text=@"Up Left";
                   [s emit:@"chat" withItems:@[@"8"]];
            
      
    }
    
    else if ((fabs(dir.x)<0.5) && (dir.y>0.5))
    {_direction.text=@"Down";
        
            [s emit:@"chat" withItems:@[@"5"]];
            
     
    }
    
    else
    {_direction.text=@"Up";
     [s emit:@"chat" withItems:@[@"1"]];
            
    }
    
}




- (IBAction)buttonTouchEnd:(UIButton*)sender forEvent:(UIEvent *)event
{
    
}

- (IBAction)buttonClick:(UIButton*)sender
{
    if (sender.tag==3) {
        if (self.connected==0){
            self.connected = 1;
        }
        else{
            //
            self.connected = 0;
        }
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

@end

