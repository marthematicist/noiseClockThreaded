volatile PixelArray PA;

// fld: controls the field ( background, outline, or fill )
volatile float[] fld0;
volatile float[] fld1;
volatile float[] hue0;
volatile float[] hue1;
volatile float[] sat0;
volatile float[] sat1;
volatile float[] bri0;
volatile float[] bri1;
volatile float fldProgress = 0;
volatile float currentProgress = 0;
volatile boolean fldFlag_thread_readyToUpdate = false;
volatile boolean fldFlag_draw_goUpdate = false;
volatile boolean fldFlag_thread_doneUpdating = false;
volatile boolean fldFlag_draw_requestProgress = false;
volatile boolean fldFlag_thread_progressReady = false;

volatile color[] col0;
int num0;
volatile color[] col1;
int num1;
volatile boolean colFlg_draw_goRender0 = false;
volatile boolean colFlg_draw_goRender1 = false;
volatile boolean colFlg_thread_Rendering0 = false;
volatile boolean colFlg_thread_Rendering1 = false;
volatile boolean colFlg_thread_doneRendering0 = false;
volatile boolean colFlg_thread_doneRendering1 = false;
volatile boolean colFlg_draw_goUpdate0 = false;
volatile boolean colFlg_draw_goUpdate1 = false;
volatile boolean colFlag_thread_Updating0 = false;
volatile boolean colFlag_thread_Updating1 = false;
volatile boolean colFlag_thread_doneUpdating0 = false;
volatile boolean colFlag_thread_doneUpdating1 = false;
volatile boolean colFlag_thread_loopComplete0 = false;
volatile boolean colFlag_thread_loopComplete1 = false;


// resolution helpers
int halfWidth;
int halfHeight;

PGraphics pg;

// clock constants
float outerRadius;
float sBandCenter;
float sBandWidth;
float mBandCenter;
float mBandWidth;
float hBandCenter;
float hBandWidth;
float borderWidth;
float radAmt;
int millisOffset; 

void setup() {
  size( 800 , 480 );
  halfWidth = width/2;
  halfHeight = height/2;
  background(bgColor);
  noFill();
  stroke(255);
  strokeWeight( 5);
  millisOffset = hour()%12*60*60*1000 + minute()*60*1000 + second()*1000 - millis();
  
  
  outerRadius = 0.5*width - 10;
  
  
  
  hBandCenter = 0.150*height;
  hBandWidth = 15;
  mBandCenter = 0.300*height;
  mBandWidth = 15;
  sBandCenter = 0.450*height;
  sBandWidth = 15;
  borderWidth = 2;
  radAmt = 3;
  
  pg = createGraphics( width , height );
  pg.beginDraw();
  pg.clear();
  pg.noFill();
  pg.strokeWeight(2*borderWidth);
  pg.stroke(bgColor);
  pg.ellipse( 0.5*width , 0.5*height , 2*outerRadius , 2*outerRadius );
  pg.stroke(outlineColor);
  pg.ellipse( 0.5*width , 0.5*height , 2*outerRadius-3 , 2*outerRadius-3 );
  
  pg.stroke(bandColor);
  pg.strokeWeight(hBandWidth-0.5*borderWidth);
  pg.ellipse( 0.5*width , 0.5*height , 2*(hBandCenter) , 2*(hBandCenter) );
  pg.stroke(outlineColor);
  pg.strokeWeight(borderWidth);
  pg.ellipse( 0.5*width , 0.5*height , 2*(hBandCenter - 0.5*hBandWidth) , 2*(hBandCenter - 0.5*hBandWidth) );
  pg.ellipse( 0.5*width , 0.5*height , 2*(hBandCenter + 0.5*hBandWidth) , 2*(hBandCenter + 0.5*hBandWidth) );

  
  
  pg.stroke(bandColor);
  pg.strokeWeight(mBandWidth-0.5*borderWidth);
  pg.ellipse( 0.5*width , 0.5*height , 2*(mBandCenter) , 2*(mBandCenter) );
  pg.stroke(outlineColor);
  pg.strokeWeight(borderWidth);
  pg.ellipse( 0.5*width , 0.5*height , 2*(mBandCenter - 0.5*mBandWidth) , 2*(mBandCenter - 0.5*mBandWidth) );
  pg.ellipse( 0.5*width , 0.5*height , 2*(mBandCenter + 0.5*mBandWidth) , 2*(mBandCenter + 0.5*mBandWidth) );

  
  pg.stroke(bandColor);
  pg.strokeWeight(sBandWidth-0.5*borderWidth);
  pg.ellipse( 0.5*width , 0.5*height , 2*(sBandCenter) , 2*(sBandCenter) );
  pg.stroke(outlineColor);
  pg.strokeWeight(borderWidth);
  pg.ellipse( 0.5*width , 0.5*height , 2*(sBandCenter - 0.5*sBandWidth) , 2*(sBandCenter - 0.5*sBandWidth) );
  pg.ellipse( 0.5*width , 0.5*height , 2*(sBandCenter + 0.5*sBandWidth) , 2*(sBandCenter + 0.5*sBandWidth) );
  pg.strokeWeight(borderWidth*2);
  pg.line( 0.12*width , 0.5*borderWidth , 0.88*width , 0.5*borderWidth );
  pg.line( 0.12*width , height-0.5*borderWidth , 0.88*width , height-0.5*borderWidth );

  
  pg.endDraw();
  
  PA = new PixelArray();
  fld0 = new float[PA.num];
  fld1 = new float[PA.num];
  hue0 = new float[PA.num];
  hue1 = new float[PA.num];
  sat0 = new float[PA.num];
  sat1 = new float[PA.num];
  bri0 = new float[PA.num];
  bri1 = new float[PA.num];
  for( int i = 0 ; i < PA.num ; i++ ) {
    fld0[i] = 0;
    fld1[i] = 0;
    hue0[i] = 0;
    hue1[i] = 0;
    sat0[i] = 0;
    sat1[i] = 0;
    bri0[i] = 0;
    bri1[i] = 0;
  }
  num0 = PA.num/2;
  num1 = PA.num-num0;
  col0 = new color[num0];
  col1 = new color[num1];
  for( int i = 0 ; i < num0 ; i++ ) {
    col0[i] = color(0);
  }
  for( int i = 0 ; i < num1 ; i++ ) {
    col1[i] = color(0);
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
  
  thread( "threadCCalc0" );
  thread( "threadCCalc1" );
}




boolean logOut = false;
void draw() {
  if( logOut ) { println( "frame: " , frameCount , "  time: " , millis() , "  FRAMESTART" ); }
  
  // request fld progress
  fldFlag_draw_requestProgress = true;
  while( !fldFlag_thread_progressReady ) {
    // wait until progress is ready
  }
  currentProgress = fldProgress;
  fldFlag_thread_progressReady = false;
  if( logOut ) { println( "frame: " , frameCount , "  time: " , millis() , "  PROGRESSUPDATED" ); }
  
  
  colFlg_draw_goRender0 = true;
  while( !colFlg_thread_Rendering0 ) {}
  colFlg_thread_Rendering0 = false;
  colFlg_draw_goRender0 = false;
  if( logOut ) { println( "frame: " , frameCount , "  time: " , millis() , "  RENDERSTART0" ); }
   
  colFlg_draw_goRender1 = true;
  while( !colFlg_thread_Rendering1 ) {}
  colFlg_thread_Rendering1 = false;
  colFlg_draw_goRender1 = false;
  if( logOut ) { println( "frame: " , frameCount , "  time: " , millis() , "  RENDERSTART1" ); }
  
  
  loadPixels();
  for( int i = 0 ; i < width*height ; i++ ) {
    
    if( PA.I[i] >=0 ) {
      if( PA.I[i] < num0 ) {
        pixels[ i ] = col0[ PA.I[i] ];
      } else {
        pixels[ i ] = col1[ PA.I[i]-num0 ];
      }
    }
  }
  updatePixels();
  if( logOut ) { println( "frame: " , frameCount , "  time: " , millis() , "  PIXELSDONE" ); }
  
  while( !colFlg_thread_doneRendering0 ) {}
  colFlg_thread_doneRendering0 = false;
  if( logOut ) { println( "frame: " , frameCount , "  time: " , millis() , "  RENDERDONE0" ); }
  while( !colFlg_thread_doneRendering1 ) {}
  colFlg_thread_doneRendering1 = false;
  if( logOut ) { println( "frame: " , frameCount , "  time: " , millis() , "  RENDERDONE1" ); }
  
  
  noStroke();
  fill(outlineColor);
  
  int t = millis() + millisOffset;
  float sPart = float(t)/(60000)%1;
  float mPart = float(t)/(3600000)%1;
  float hPart = float(t)/(43200000)%1;
  float sAng = (-0.25+sPart)*TWO_PI;
  float mAng = (-0.25+mPart)*TWO_PI;
  float hAng = (-0.25+hPart)*TWO_PI;
  ellipse( halfWidth + mBandCenter*cos(mAng) , halfHeight + mBandCenter*sin(mAng) , radAmt*mBandWidth , radAmt*mBandWidth );
  ellipse( halfWidth + sBandCenter*cos(sAng) , halfHeight + sBandCenter*sin(sAng) , radAmt*sBandWidth , radAmt*sBandWidth );
  ellipse( halfWidth + hBandCenter*cos(hAng) , halfHeight + hBandCenter*sin(hAng) , radAmt*hBandWidth , radAmt*hBandWidth );
  
  image(pg , 0 , 0 );
  
  fill(bandColor);
  ellipse( halfWidth + mBandCenter*cos(mAng) , halfHeight + mBandCenter*sin(mAng) , radAmt*mBandWidth - 2*borderWidth , radAmt*mBandWidth - 2*borderWidth );
  ellipse( halfWidth + sBandCenter*cos(sAng) , halfHeight + sBandCenter*sin(sAng) , radAmt*sBandWidth - 2*borderWidth , radAmt*sBandWidth - 2*borderWidth );
  ellipse( halfWidth + hBandCenter*cos(hAng) , halfHeight + hBandCenter*sin(hAng) , radAmt*hBandWidth - 2*borderWidth , radAmt*hBandWidth - 2*borderWidth );
  noStroke();
  fill(outlineColor);
  strokeWeight(borderWidth);
  ellipse( halfWidth + mBandCenter*cos(mAng) , halfHeight + mBandCenter*sin(mAng) , 0.5*radAmt*mBandWidth , 0.5*radAmt*mBandWidth );
  ellipse( halfWidth + sBandCenter*cos(sAng) , halfHeight + sBandCenter*sin(sAng) , 0.5*radAmt*sBandWidth , 0.5*radAmt*sBandWidth );
  ellipse( halfWidth + hBandCenter*cos(hAng) , halfHeight + hBandCenter*sin(hAng) , 0.5*radAmt*hBandWidth , 0.5*radAmt*hBandWidth );

  
  
  
  colFlg_draw_goUpdate0 = true;
  while( !colFlag_thread_Updating0 ) {}
  colFlag_thread_Updating0 = false;
  colFlg_draw_goUpdate0 = false;
  if( logOut ) { println( "frame: " , frameCount , "  time: " , millis() , "  PIXEL UPDATE STARTED0" ); }
  
  colFlg_draw_goUpdate1 = true;
  while( !colFlag_thread_Updating1 ) {}
  colFlag_thread_Updating1 = false;
  colFlg_draw_goUpdate1 = false;
  if( logOut ) { println( "frame: " , frameCount , "  time: " , millis() , "  PIXEL UPDATE STARTED1" ); }
  
  if( fldFlag_thread_readyToUpdate ) {
    fldFlag_thread_readyToUpdate = false;
    fldFlag_draw_goUpdate = true;
    if( logOut ) { println( "frame: " , frameCount , "  time: " , millis() , "  FLD UPDATE STARTED" ); }
    while( !fldFlag_thread_doneUpdating ) {
      // wait until done updating
    }
    fldFlag_thread_doneUpdating = false;
    if( logOut ) { println( "frame: " , frameCount , "  time: " , millis() , "  FLD UPDATE DONE" ); }
  }
  
  
  while( !colFlag_thread_doneUpdating0 ) {}
  colFlag_thread_doneUpdating0 = false;
  if( logOut ) { println( "frame: " , frameCount , "  time: " , millis() , "  PIXELS UPDATE DONE0" ); }
  while( !colFlag_thread_doneUpdating1 ) {}
  colFlag_thread_doneUpdating1 = false;
  if( logOut ) { println( "frame: " , frameCount , "  time: " , millis() , "  PIXELS UPDATE DONE1" ); }
  
  while( !colFlag_thread_loopComplete0 ) {}
  colFlag_thread_loopComplete0 = false;
  while( !colFlag_thread_loopComplete1 ) {}
  colFlag_thread_loopComplete1 = false;
  
  if( frameCount%60 == 0 ) {
    println( "frameRate: " , frameRate );
  }
  
  
  
  
}