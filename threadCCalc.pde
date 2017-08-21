// color calulation thread

void threadCCalc() {
  color[] col0a = new color[PA.num];
  println( PA.num );
  for( int i = 0 ; i < PA.num ; i++ ) {
    col0a[i] = color(0);
  }
  color bgColor = color( 0 , 0 , 0 );
  color outlineColor = color( 255 , 255 , 255 );
  
  while( true ) {
    while( !colFlg_draw_goRender ) {
    }
    colFlg_draw_goRender = false;
    
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
      col0a[ i ] = c;
    }
    
    colFlg_thread_doneRendering0 = true;
    
    
    
    while( !colFlg_draw_goUpdate ) {
    }
    
    
    
    colFlg_draw_goUpdate = false;
    for( int i = 0 ; i < PA.num ; i++ ) {
      col0[i] = col0a[i];
    }
    colFlag_thread_doneUpdating0 = true;
    
    
    
  }
}