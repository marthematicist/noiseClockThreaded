// color calulation thread

void threadCCalc() {
  color[] col1 = new color[PA.num];
  for( int i = 0 ; i < PA.num ; i++ ) {
    col1[i] = color(0);
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
      col1[i] = bgColor;
      for( int b = 0 ; b < numBands ; b++ ) {
        if( fldVal >= bandStart[b] && fldVal <= (bandStart[b]+bandWidth[b]) ) {
          col1[i] = outlineColor;
        }
      }
    }
    
    colFlg_thread_doneRendering = true;
    while( !colFlg_draw_goUpdate ) {
    }
    colFlg_draw_goUpdate = false;
    for( int i = 0 ; i < PA.num ; i++ ) {
      col0[i] = col1[i];
    }
    colFlag_thread_doneUpdating = true;
    
  }
}