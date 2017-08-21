volatile PixelArray PA;

// fld: controls the field ( background, outline, or fill )
volatile float[] fld0;
volatile float[] fld1;
volatile float fldProgress;
volatile boolean fldFlag_thread_readyToUpdate = false;
volatile boolean fldFlag_draw_goUpdate = false;
volatile boolean fldFlag_thread_doneUpdating = false;
volatile boolean fldFlag_draw_requestProgress = false;
volatile boolean fldFlag_thread_progressReady = false;

volatile color[] col0;
volatile color[] col1;
volatile boolean colFlg_draw_goRender = false;
volatile boolean colFlg_thread_doneRendering0 = false;
volatile boolean colFlg_thread_doneRendering1 = false;
volatile boolean colFlg_draw_goUpdate = false;
volatile boolean colFlag_thread_doneUpdating0 = true;
volatile boolean colFlag_thread_doneUpdating1 = true;


// resolution helpers
int halfWidth;
int halfHeight;


void setup() {
  size( 800 , 480 );
  halfWidth = width/2;
  halfHeight = height/2;
  
  PA = new PixelArray();
  fld0 = new float[PA.num];
  fld1 = new float[PA.num];
  col0 = new color[PA.num];
  col1 = new color[PA.num];
  for( int i = 0 ; i < PA.num ; i++ ) {
    fld0[i] = 0;
    fld1[i] = 0;
    col0[i] = color(0);
  }
  
  thread( "threadFCalc" );
  while( !fldFlag_thread_readyToUpdate ) {
    // wait until fld data ready
  }
  fldFlag_thread_readyToUpdate = false;
  fldFlag_draw_goUpdate = true;
  while( !fldFlag_thread_doneUpdating ) {
    // wait until done updating
  }
  fldFlag_thread_doneUpdating = false;
  
  while( !fldFlag_thread_readyToUpdate ) {
    // wait until fld data ready
  }
  fldFlag_thread_readyToUpdate = false;
  fldFlag_draw_goUpdate = true;
  while( !fldFlag_thread_doneUpdating ) {
    // wait until done updating
  }
  fldFlag_thread_doneUpdating = false;
  
  thread( "threadCCalc" );
}

float[] bandStart = { 0.4 , 0.5 , 0.6 };
float[] bandWidth = { 0.05 , 0.05 , 0.05 };
int numBands = 3;


boolean logOut = true;
void draw() {
  if( logOut ) { println( "frame: " , frameCount , "  time: " , millis() , "  FRAMESTART" ); }
  
  colFlg_draw_goRender = true;
  if( logOut ) { println( "frame: " , frameCount , "  time: " , millis() , "  RENDERSTART" ); }
  
  loadPixels();
  for( int i = 0 ; i < width*height ; i++ ) {
      pixels[ i ] = col0[ PA.I[i] ];
  }
  updatePixels();
  if( logOut ) { println( "frame: " , frameCount , "  time: " , millis() , "  PIXELSDONE" ); }
  
  while( !colFlg_thread_doneRendering0 ) { 
  }
  colFlg_thread_doneRendering0 = false;
  if( logOut ) { println( "frame: " , frameCount , "  time: " , millis() , "  RENDERDONE" ); }
  colFlg_draw_goUpdate = true;
  if( logOut ) { println( "frame: " , frameCount , "  time: " , millis() , "  PIXEL UPDATE STARTED" ); }
  
  if( fldFlag_thread_readyToUpdate ) {
    fldFlag_thread_readyToUpdate = false;
    fldFlag_draw_goUpdate = true;
    while( !fldFlag_thread_doneUpdating ) {
      // wait until done updating
    }
    fldFlag_thread_doneUpdating = false;
  }
  
  while( !colFlag_thread_doneUpdating0 ) {
  }
  colFlag_thread_doneUpdating0 = false;
  if( logOut ) { println( "frame: " , frameCount , "  time: " , millis() , "  PIXELS UPDATE DONE" ); }
  
  
  
  
  if( frameCount%60 == 0 ) {
    println( "frameRate: " , frameRate );
  }
  
}