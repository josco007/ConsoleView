//
//  ConsoleView.h
//  iosAuditorAlm
//
//  Created by Noe Miranda on 6/16/15.
//  Copyright (c) 2015 Interceramic. All rights reserved.
//

#import <UIKit/UIKit.h>


/*@protocol ConsoleViewDelegate <NSObject>
-(void)consoleView:(UIView*)pConsoleView Event:(NSInteger)pEvent data:(NSObject*) pData;
@end
 */

@protocol ConsoleViewDelegate <NSObject>

//-(void)consoleView:(UIView*) pConsoleView Event:(NSInteger)pEvent data:(NSObject*) pData;
-(void)consoleView:(UIView*)pConsoleView event:(NSInteger)pEvent data:(NSObject*) pData;

@end

@interface ConsoleView : UIView{
    
    NSMutableArray *logMar;
    //IBOutlet UIScrollView *logScv;
    IBOutlet UITextView *logTxv;
    
    IBOutlet UIButton *cerrarBtn;
    IBOutlet UIButton *clearBtn;
    IBOutlet UIButton *reloadBtn;
    
    UIView *containerView;
    
    BOOL isVisible;
    
    BOOL forceWriteInConsoleView; //unstable
    BOOL writeInConsoleViewIfVisible; //unstable
    
    
    NSMutableArray *customButtonsMar;
    NSArray *customButtonTitleArr;
    IBOutlet UIScrollView *buttonsScv;
    
    NSString * fileLogName;
    
    
    
}

@property (nonatomic, unsafe_unretained) id <ConsoleViewDelegate> delegate;

@property (nonatomic, unsafe_unretained) NSInteger CUSTOM_BUTTON_TOUCH_UP_INSIDE_EVENT ;

+(void)start;
/**
 * Creado por Noe Israel Miranda Franco On 26/jun/2015
 * Imprime en consola y tambien imprime en la vista de la consoleView
 * @note funciona en swift con la ayuda de una extension y una funcion 
         publica que mande a llamar la funcion de la extencion para poderlo llamar identico al NSLog
 * @param pString : el formato de la cadena
 * @param args: los argumentos de la cadena
 */
+(void)ConsoleViewLog:(NSString*)pString args:(va_list)args;

/**
 * Creado por Noe Israel Miranda Franco On 26/jun/2015
 * Imprime en consola y tambien imprime en la vista de la consoleView
 * @note funciona para objective c para que se pueda llamar identico al NSLog
 * @param pString : el formato de la cadena
 * @param args: los argumentos de la cadena
 */
FOUNDATION_EXPORT void ConsoleViewLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);

/**
 * Creado por Noe Israel Miranda Franco On 26/jun/2015
 * Imprime en consola y tambien imprime en la vista de la consoleView
 * @note funciona en swift con la ayuda de una extension y una funcion
 publica que mande a llamar la funcion de la extencion para poderlo llamar identico al NSLog
 * @param pString : el formato de la cadena
 * @param args: los argumentos de la cadena
 */
+(void)ConsoleViewSaveToFileLog:(NSString*)pString args:(va_list)args;

/**
 * Creado por Noe Israel Miranda Franco On 26/jun/2015
 * Imprime en consola y tambien imprime en la vista de la consoleView
 * @note funciona para objective c para que se pueda llamar identico al NSLog
 * @param pString : el formato de la cadena
 * @param args: los argumentos de la cadena
 */
FOUNDATION_EXPORT void ConsoleViewSaveToFileLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);
+(void)setActiveLog:(BOOL)pActiveLog;
+(void)setActiveFileLog:(BOOL) pActiveFileLog;
/**
 *
 * @param pMaxSize: max size of the file log in kilobytes 
 */
+(void)setMaxSizeFileLog:(NSInteger) pMaxSize;
//+(void)setConsoleView:(ConsoleView*)pConsoleView;
+(ConsoleView*)getConsoleView;
+(void)addToView:(UIView*)pView;

+(NSInteger)CUSTOM_BUTTON_TOUCH_UP_INSIDE_EVENT;

+ (void) setCustomButtons:(NSArray*) pButtonsTitles;

+ (void) setFileLogName:(NSString*) pFileLogName;

@end
