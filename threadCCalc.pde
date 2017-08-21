// color calulation thread

void threadCCalc0() {
  color[] col0a = new color[PA.num];
  for( int i = 0 ; i < num0 ; i++ ) {
    col0a[i] = color(0);
  }
  color bgColor = color( 0 , 0 , 0 );
  color outlineColor = color( 255 , 255 , 255 );
  
  while( true ) {
    //println( "thread0 loop started" );
    
    while( !colFlg_draw_goRender0 ) {
    }
    colFlg_thread_Rendering0 = true;
    //colFlg_thread_doneRendering0 = false;
    
    
    for( int i = 0 ; i < num0 ; i++ ) {
      float fldVal = lerp( fld0[i] , fld1[i] , currentProgress );
      color c = bgColor;
      for( int b = 0 ; b < numBands ; b++ ) {
        if( fldVal >= bandStart[b] && fldVal <= (bandStart[b]+bandWidth[b]) ) {
          c = outlineColor;
        }
      }
      col0a[ i ] = c;
    }
    //colFlg_thread_Rendering0 = false;
    colFlg_thread_doneRendering0 = true;

    while( !colFlg_draw_goUpdate0 ) {
    }
    colFlag_thread_Updating0 = true;
    //colFlag_thread_doneUpdating0 = false;
    
    for( int i = 0 ; i < num0 ; i++ ) {
      col0[i] = col0a[i];
    }
    //colFlag_thread_Updating0 = false;
    colFlag_thread_doneUpdating0 = true;
    
    //println( "thread0 loop complete" );
    colFlag_thread_loopComplete0 = true;
  }
}

void threadCCalc1() {
  color[] col1a = new color[PA.num];
  for( int i = 0 ; i < num1 ; i++ ) {
    col1a[i] = color(0);
  }
  color bgColor = color( 0 , 0 , 0 );
  color outlineColor = color( 255 , 255 , 255 );
  
  while( true ) {
    //println( "thread1 loop started" );
    
    while( !colFlg_draw_goRender1 ) {
    }
    colFlg_thread_Rendering1 = true;
    //colFlg_thread_doneRendering1 = false;
    
    for( int i = 0 ; i < num1 ; i++ ) {
      float fldVal = lerp( fld0[i+num0] , fld1[i+num0] , currentProgress );
      color c = bgColor;
      for( int b = 0 ; b < numBands ; b++ ) {
        if( fldVal >= bandStart[b] && fldVal <= (bandStart[b]+bandWidth[b]) ) {
          c = outlineColor;
        }
      }
      col1a[ i ] = c;
    }
    //colFlg_thread_Rendering1 = false;
    colFlg_thread_doneRendering1 = true;

    while( !colFlg_draw_goUpdate1 ) {
    }
    colFlag_thread_Updating1 = true;
    //colFlag_thread_doneUpdating1 = false;
    
    for( int i = 0 ; i < num1 ; i++ ) {
      col1[i] = col1a[i];
    }
    //colFlag_thread_Updating1 = false;
    colFlag_thread_doneUpdating1 = true;
    
    //println( "thread1 loop complete" );
    colFlag_thread_loopComplete1 = true;
  }
}