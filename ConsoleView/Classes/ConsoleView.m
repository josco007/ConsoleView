//
//  ConsoleView.m
//  iosAuditorAlm
//
//  Created by Noe Miranda on 6/16/15.
//  Copyright (c) 2015 Interceramic. All rights reserved.
//

#import "ConsoleView.h"


@implementation ConsoleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/




-(id)init{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        // Custom initialization
        [self commonInit];
        
    }
    return self;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void)commonInit{
    
    
    containerView = [[[NSBundle bundleForClass:ConsoleView.self] loadNibNamed:@"ConsoleView" owner:self options:nil] lastObject];
    
    [self setFrame:CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height)];
    [self addSubview:containerView];
    
}



+(void)start{
    
    consoleView = [[ConsoleView alloc] init];
    consoleView->fileLogName = @"ConsoleViewFileLog";
    
    consoleView->logMar = [[NSMutableArray alloc] init];
    
    //agrega los eventos a los botones
    [consoleView->cerrarBtn addTarget:consoleView action:@selector(cerrarBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [consoleView->clearBtn addTarget:consoleView action:@selector(clearBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    consoleView->customButtonsMar = [[NSMutableArray alloc] init];
    consoleView->customButtonTitleArr = [[NSArray alloc] init];
    
    consoleView->testerMode = false;
    
    consoleView->isStarted = true;
    
}

+(void)setFileLogName:(NSString *)pFileLogName{
    consoleView->fileLogName = pFileLogName;
}


#pragma mark - buttons events
-(void)cerrarBtnTouchUpInside:(id)sender{
    [self removeFromSuperview];
}

-(void)customBtnTouchUpInside:(id)sender{
    
    UIButton * button = (UIButton*) sender;
    
    if (consoleView->_delegate != nil){
        [consoleView->_delegate consoleView:consoleView event:[ConsoleView CUSTOM_BUTTON_TOUCH_UP_INSIDE_EVENT] data:[button titleLabel].text];
    }
}

-(void)clearBtnTouchUpInside:(id)sender{
    logMar = [[NSMutableArray alloc] init];
    
    //[self reloadTestScrollView];
    [self cleanTxv];

}
- (IBAction)reloadBtnTouchUpInside:(id)sender {
    [self reload];
}

/*
-(void)reloadTestScrollView{
    
    //limpiar los scrollviews
    for(UIView *subview in [logScv subviews]) {
        if ([subview isKindOfClass:[UILabel class]] ) {
            [subview removeFromSuperview];
        }
    }
    
    int y = 0;
    for (int i= 0; i<[logMar count]; i++) {
        UILabel *vlTestLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, 2000, 20)];
        [vlTestLabel setText:[NSString stringWithFormat:@"%d - %@",i,[logMar objectAtIndex:i]]];
        [vlTestLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        [logScv addSubview:vlTestLabel];
        
        y += 20;
    }
    
    [logScv setContentSize:CGSizeMake(2000, y)];

}
*/

-(void)cleanTxv{
    
    [logTxv setText:@""];
  
}



-(void)addLine:(NSString*)pLine{
    

    
    [logTxv setText:[NSString stringWithFormat:@"%@\n%@",logTxv.text, pLine]];
    
    if(consoleView->logTxv.text.length > 0 ) {
        NSRange bottom = NSMakeRange(consoleView->logTxv.text.length -1, 1);
        [consoleView->logTxv scrollRangeToVisible:bottom];
    }
}

+(NSString*)getFileLogPath{
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", consoleView->fileLogName, @".txt"]];
    
    return fileName;
}

+(void) writeToLogFile:(NSString*)content{
    content = [NSString stringWithFormat:@"%@\n",content];
    
    //get the documents directory:
    NSString *fileName = [self getFileLogPath];
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:fileName];
    if (fileHandle){
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle closeFile];
    }
    else{
        [content writeToFile:fileName
                  atomically:NO
                    encoding:NSStringEncodingConversionAllowLossy
                       error:nil];
    }
}

+(void) depureFileLog{
    NSData* data = [NSData dataWithContentsOfFile:[self getFileLogPath] options:NSDataReadingUncached error:NULL];
    
    //depure if is necessary
    if ((data.length / 1024.0) > maxSizeFileLog) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:[self getFileLogPath] error:&error];
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        [self writeToLogFile:[NSString stringWithFormat:@"%@ : depurated", [dateFormatter stringFromDate:[NSDate date]]]] ;
    }
}
static BOOL activeLog;
static BOOL activeFileLog;
static float maxSizeFileLog = 50000.0; // 50 mb default size



static NSInteger CUSTOM_BUTTON_TOUCH_UP_INSIDE_EVENT = 1;

+(NSInteger)CUSTOM_BUTTON_TOUCH_UP_INSIDE_EVENT{
    return CUSTOM_BUTTON_TOUCH_UP_INSIDE_EVENT;
}

//LOG para que funcione en swift con ayuda de la extension
+(void)ConsoleViewLog:(NSString*)pString args:(va_list)args{
    if (activeLog) {
        NSLogv(pString, args);
        va_end(args);
        
        //[consoleView reloadTestScrollView];
        //this is unstable
      
        if (([consoleView window] != nil && consoleView.superview != nil && consoleView->isVisible && consoleView != nil && consoleView-> writeInConsoleViewIfVisible)
            || consoleView -> forceWriteInConsoleView){
                [NSThread sleepForTimeInterval:.02];
                dispatch_async(dispatch_get_main_queue(), ^{
        
                    
                    if ([consoleView->logMar count] > 1000) {
                        [consoleView cleanTxv];
                    }
                    
                    [consoleView addLine:[[NSString alloc] initWithFormat:pString arguments:args]];
  
                });
                
        }
        
        
        if ([consoleView->logMar count] > 1000) {
            consoleView->logMar = [[NSMutableArray alloc] init];
        }
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

        
        [consoleView->logMar addObject:[[NSString alloc] initWithFormat:[NSString stringWithFormat:@"%@ - %@",[dateFormatter stringFromDate:[NSDate date]],pString]  arguments:args]];
       
       
        
    }
    
    
}
//funciona en objective c 
void ConsoleViewLog(NSString *format, ...){
  
       if (activeLog) {
        va_list args;
        va_start(args, format);
        NSLogv(format, args);
        va_end(args);
        
           
       
        //[consoleView reloadTestScrollView];
        //this is unstable
           
           if (([consoleView window] != nil && consoleView.superview != nil && consoleView->isVisible && consoleView != nil && consoleView-> writeInConsoleViewIfVisible)
               || consoleView -> forceWriteInConsoleView){
               
                   va_start(args,format) ;
                   //[NSThread sleepForTimeInterval:.02];
                   //dispatch_async(dispatch_get_main_queue(), ^{
                    
                       if ([consoleView->logMar count] > 1000) {
                           [consoleView cleanTxv];
                       }
                       
                       
                       [consoleView addLine:[[NSString alloc] initWithFormat:format arguments:args]];
                  
                   //});
                   va_end(args) ;
               }
           
           
           
           if ([consoleView->logMar count] > 1000) {
               consoleView->logMar = [[NSMutableArray alloc] init];
               //[consoleView cleanTxv];
           }
           
           va_start(args,format) ;
           NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
           [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
           
           
           [consoleView->logMar addObject:[[NSString alloc] initWithFormat:[NSString stringWithFormat:@"%@ - %@",[dateFormatter stringFromDate:[NSDate date]],format] arguments:args]];
           va_end(args) ;
       }
    
}

//LOG para que funcione en swift con ayuda de la extension
+(void)ConsoleViewSaveToFileLog:(NSString*)pString args:(va_list)args {
    if (activeFileLog) {
        
        [self depureFileLog]; //depure file if is necessary
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        [self writeToLogFile:[NSString stringWithFormat:@"%@ : %@", [dateFormatter stringFromDate:[NSDate date]],[[NSString alloc] initWithFormat:pString arguments:args]]] ;
        
        /*
        if (pShowInConsole) {
            NSLogv(pString, args);
            va_end(args);
            if ([consoleView->logMar count] > 1000000) {
                consoleView->logMar = [[NSMutableArray alloc] init];
                [consoleView cleanTxv];
            }
            
            [consoleView->logMar addObject:[[NSString alloc] initWithFormat:pString arguments:args]];
            
            //[consoleView reloadTestScrollView];
            
            [consoleView addLine:[[NSString alloc] initWithFormat:pString arguments:args]];
        }
         */
    }
    
    
}
//funciona en objective c
void ConsoleViewSaveToFileLog(NSString *format, ... ){
    
    if (activeFileLog) {
        
        [ConsoleView depureFileLog]; //depure file if is necessary
        
        va_list args;
        va_start(args, format);
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        [ConsoleView writeToLogFile:[NSString stringWithFormat:@"%@ : %@",[dateFormatter stringFromDate:[NSDate date]] ,[[NSString alloc] initWithFormat:format arguments:args]]];
        va_end(args);
        
        /*
        if (pShowInConsole) {
            va_list args;
            va_start(args, format);
            NSLogv(format, args);
            va_end(args);
            
            
            if ([consoleView->logMar count] > 1000000) {
                consoleView->logMar = [[NSMutableArray alloc] init];
                [consoleView cleanTxv];
            }
            
            va_start(args,format) ;
            [consoleView->logMar addObject:[[NSString alloc] initWithFormat:format arguments:args]];
            va_end(args) ;
            //[consoleView reloadTestScrollView];
            
            va_start(args,format) ;
            [consoleView addLine:[[NSString alloc] initWithFormat:format arguments:args]];
            va_end(args) ;
        }
         */
    }
    
}

+(BOOL)isStarted{
    
    return consoleView->isStarted;
    
}

+(void)forceWriteInConsoleView:(BOOL)pForceWriteInConsoleView{ //unstable
   consoleView->forceWriteInConsoleView =  pForceWriteInConsoleView;
}

+(void) writeInConsoleViewIfVisible:(BOOL)pWriteInConsoleViewIfVisible{ //unstable
    consoleView->writeInConsoleViewIfVisible = pWriteInConsoleViewIfVisible;
}

+(void)setActiveLog:(BOOL)pActiveLog{
    activeLog = pActiveLog;
}

+(void)setActiveFileLog:(BOOL) pActiveFileLog{
    activeFileLog = pActiveFileLog;
}

+(void)setMaxSizeFileLog:(float) pMaxSize{
    maxSizeFileLog = pMaxSize;
}
+(void)setTesterMode:(BOOL)pTesterMode{
    consoleView->testerMode = pTesterMode;
}

+(BOOL)getTesterMode{
    
    return consoleView->testerMode;
}

static ConsoleView *consoleView;


+(ConsoleView*)getConsoleView{
    return consoleView;
}


+(void)addToView:(UIView *)pView{
   
    if (consoleView->isVisible && pView == [consoleView superview]){
        
        return;
    }
    
    [pView addSubview:consoleView];
    
    [consoleView reload];
    [self addCustomButtons];
    

}

-(void)reload{
    [consoleView->logTxv setText:@"Loading.."];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
    dispatch_async (downloadQueue, ^{
        
        // do our long running process here
        [NSThread sleepForTimeInterval:.02];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [consoleView cleanTxv];
            for (NSString* log in consoleView->logMar ){
                [consoleView addLine:log];
            }

            consoleView->isVisible = true;
            
        });
        
    });
}


- (void)didMoveToSuperview;
{
    [super didMoveToSuperview];
    
    if (!self.superview) {
        isVisible = false;
    }
}

+ (void) setCustomButtons:(NSArray*) pButtonsTitles{
    
    [self removeCustomButtons];
    
    consoleView->customButtonTitleArr = pButtonsTitles;
    
}

+(void) addCustomButtons{
    
    CGFloat separator = 5;
    
    CGRect frame = CGRectMake(consoleView->reloadBtn.frame.size.width + consoleView->reloadBtn.frame.origin.x + separator, consoleView->reloadBtn.frame.origin.y, 100, 30);
    
    CGFloat plusToContentSizeWidth = 0;
    
    for (NSString * buttonTitle in consoleView->customButtonTitleArr) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:frame];
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        button.titleLabel.font = consoleView->cerrarBtn.titleLabel.font;
        
        [button addTarget:consoleView action:@selector(customBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        [consoleView->buttonsScv addSubview:button];
        [consoleView->customButtonsMar addObject:button];
        frame =  CGRectMake(button.frame.size.width + button.frame.origin.x + separator, button.frame.origin.y, 100, 30);
        
        plusToContentSizeWidth += 100 + separator;
    }
    
    CGFloat staticButtonsSumSize = consoleView->cerrarBtn.frame.size.width + consoleView->clearBtn.frame.size.width + consoleView->reloadBtn.frame.size.width + 10;
    
    [consoleView->buttonsScv setContentSize:CGSizeMake(staticButtonsSumSize + plusToContentSizeWidth, 0)];
}

+ (void) removeCustomButtons{
    for (UIButton* button in consoleView->customButtonsMar) {
        [button removeFromSuperview];
    }
    
    consoleView->customButtonsMar = [[NSMutableArray alloc] init];
    consoleView->customButtonTitleArr = [[NSArray alloc] init];
}


#pragma mark - tocuhes delegates
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *aTouch = [touches anyObject];
    CGPoint location = [aTouch locationInView:self.superview];
    [UIView beginAnimations:@"Dragging A DraggableView" context:nil];
    self.frame = CGRectMake(location.x, location.y,
                                 self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
}





@end
