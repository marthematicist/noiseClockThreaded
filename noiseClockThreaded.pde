volatile PixelArray PA;

// fld: controls the field ( background, outline, or fill )
volatile float[] fld0;
volatile float[] fld1;
volatile float fldProgress;
volatile boolean fldFlag_thread_readyToUpdate = false;
volatile boolean fldFlag_draw_goUpdate = false;
volatile boolean fldFlag_thread_updating = false;
volatile boolean fldFlag_thread_doneUpdating = false;
volatile boolean fldFlag_draw_requestProgress = false;
volatile boolean fldFlag_thread_progressReady = false;


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
  for( int i = 0 ; i < PA.num ; i++ ) {
    fld0[i] = 0;
    fld1[i] = 0;
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
}

float[] bandStart = { 0.4 , 0.5 , 0.6 };
float[] bandWidth = { 0.05 , 0.05 , 0.05 };
int numBands = 3;

void draw() {
  // request fld progress
  fldFlag_draw_requestProgress = true;
  while( !fldFlag_thread_progressReady ) {
    // wait until progress is ready
  }
  float prog = fldProgress;
  fldFlag_thread_progressReady = false;
  
  color bgColor = color( 0 , 0 , 0 );
  color outlineColor = color( 255 , 255 , 255 );
  
  
  loadPixels();
  for( int i = 0 ; i < PA.num ; i++ ) {
    float fldVal = lerp( fld0[i] , fld1[i] , prog );
    color c = bgColor;
    for( int b = 0 ; b < numBands ; b++ ) {
      if( fldVal >= bandStart[b] && fldVal <= (bandStart[b]+bandWidth[b]) ) {
        c = outlineColor;
      }
    }
    for( int p = 0 ; p < PA.P[i].np ; p++ ) {
      int x = PA.P[i].xp[p];
      int y = PA.P[i].yp[p];
      //println( x , y );
      pixels[ x + y*width ] = c;
    }
  }
  updatePixels();
  
  if( fldFlag_thread_readyToUpdate ) {
    fldFlag_thread_readyToUpdate = false;
    fldFlag_draw_goUpdate = true;
    while( !fldFlag_thread_doneUpdating ) {
      // wait until done updating
    }
    fldFlag_thread_doneUpdating = false;
  }
  
  
}