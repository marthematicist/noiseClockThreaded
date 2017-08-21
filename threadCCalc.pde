// color calulation thread

void threadCCalc() {
  color[] col1 = new color[width*height];
  for( int i = 0 ; i < PA.num ; i++ ) {
    col1[i] = color(0);
  }
  color bgColor = color( 0 , 0 , 0 );
  color outlineColor = color( 255 , 255 , 255 );
  
  while( true ) {
    while( !colFlg_draw_goRender ) {
    }
    colFlg_draw_goRender = false;
    
    if( logOut ) { println( "frame: " , frameCount , "  time: " , millis() , "  RENDERSTART" ); }
    
    // request fld progress
    fldFlag_draw_requestProgress = true;
    while( !fldFlag_thread_progressReady ) {
      // wait until progress is ready
    }
    float prog = fldProgress;
    fldFlag_thread_progressReady = false;
    
    for( int i = 0 ; i < PA.num ; i++ ) {
      float fldVal = lerp( fld0[i] , fld1[i] , prog );
      color c = bgColor;
      for( int b = 0 ; b < numBands ; b++ ) {
        if( fldVal >= bandStart[b] && fldVal <= (bandStart[b]+bandWidth[b]) ) {
          c = outlineColor;
        }
      }
      for( int p = 0 ; p < PA.P[i].np ; p++ ) {
        col1[ PA.P[i].ip[p] ] = c;
      }
    }
    
    colFlg_thread_doneRendering = true;
    
    if( logOut ) { println( "frame: " , frameCount , "  time: " , millis() , "  RENDERDONE" ); }
    
    while( !colFlg_draw_goUpdate ) {
    }
    
    if( logOut ) { println( "frame: " , frameCount , "  time: " , millis() , "  PIXEL UPDATE STARTED" ); }
    
    colFlg_draw_goUpdate = false;
    for( int i = 0 ; i < width*height ; i++ ) {
      col0[i] = col1[i];
    }
    colFlag_thread_doneUpdating = true;
    
    if( logOut ) { println( "frame: " , frameCount , "  time: " , millis() , "  PIXELS UPDATE DONE" ); }
    
  }
}