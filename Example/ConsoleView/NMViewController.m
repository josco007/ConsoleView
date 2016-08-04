//
//  NMViewController.m
//  ConsoleView
//
//  Created by josco007 on 08/04/2016.
//  Copyright (c) 2016 josco007. All rights reserved.
//

#import "NMViewController.h"



@interface NMViewController ()

@end

@implementation NMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    ConsoleViewLog(@"Not printed"); // this will not be printed because ConsoleView is not started yet
    
    [ConsoleView start];
    ConsoleViewLog(@"Not printed becuase by default ConsoleView is diabled");
    [ConsoleView setActiveLog:YES]; // print logs
    [ConsoleView setActiveFileLog:YES];  // save logs in sandbox on a file named ConsoleViewFileLog by default or you can set this name with the method "setFileLogName"
    [ConsoleView setTesterMode:YES];
    [ConsoleView forceWriteInConsoleView:NO]; //Unstable working on it
    [ConsoleView writeInConsoleViewIfVisible:NO]; //Unstable wornig on it
    
    
    

    
    ConsoleViewLog(@"printed!!!! %@ number %d", @"hi ",3);
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //if tester mode is enabled and consoleview has been started and the user touch the dispalay with 5 fingers
    if ([ConsoleView getTesterMode] && [ConsoleView isStarted] && [[event allTouches] count] == 5){
        //show floating view with our log
        [ConsoleView addToView:self.view];
    }
    
}


@end
