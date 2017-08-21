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
volatile boolean colFlg_draw_goRender = false;
volatile boolean colFlg_thread_doneRendering = false;
volatile boolean colFlg_draw_goUpdate = false;
volatile boolean colFlag_thread_doneUpdating = true;


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

void draw() {
  
  colFlg_draw_goRender = true;
  
  loadPixels();
  for( int i = 0 ; i < PA.num ; i++ ) {
    for( int p = 0 ; p < PA.P[i].np ; p++ ) {
      int x = PA.P[i].xp[p];
      int y = PA.P[i].yp[p];
      pixels[ x + y*width ] = col0[i];
      //println( col0[i] );
    }
  }
  updatePixels();
  
  while( !colFlg_thread_doneRendering ) { 
  }
  colFlg_thread_doneRendering = false;
  colFlg_draw_goUpdate = true;
  
  if( fldFlag_thread_readyToUpdate ) {
    fldFlag_thread_readyToUpdate = false;
    fldFlag_draw_goUpdate = true;
    while( !fldFlag_thread_doneUpdating ) {
      // wait until done updating
    }
    fldFlag_thread_doneUpdating = false;
  }
  
  while( !colFlag_thread_doneUpdating ) {
  }
  colFlag_thread_doneUpdating = false;
  
  
  
}