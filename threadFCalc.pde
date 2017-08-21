// fld calc thread

float fDetail = 0.01;
float fSpeed = 0.01;

void threadFCalc() {
  int num = PA.num;
  float xf[];
  float yf[];
  xf = new float[num];
  yf = new float[num];
  for( int i = 0 ; i < num ; i++ ) {
    xf[i] = PA.P[i].xr * fDetail;
    yf[i] = PA.P[i].yr * fDetail;
  }
  float tf = 0;
  
  int n = 0;
  float fld2[] = new float[ num ];
  while(true) {
    // handle request for progress
    if( fldFlag_draw_requestProgress ) {
      fldFlag_draw_requestProgress = false;
      fldProgress = float(n) / float(num);
      fldFlag_thread_progressReady = true;
    }
    
    // update next element of fld2
    fld2[n] = noise( xf[n] , yf[n] , tf );
    // update counter
    n++;
    
    // check if done with fld calculations
    if( n >= num ) {
      // set flag: ready to update
      fldFlag_thread_readyToUpdate = true;
      // wait for flag: go update
      while( !fldFlag_draw_goUpdate ) {
        // handle request for progress
        if( fldFlag_draw_requestProgress ) {
          fldFlag_draw_requestProgress = false;
          fldProgress = float(n) / float(num);
          fldFlag_thread_progressReady = true;
        }
      }
      
      // update fld data
      fldFlag_draw_goUpdate = false;
      for( int i = 0 ; i < num ; i++ ) {
        fld0[i] = fld1[i];
        fld1[i] = fld2[i];
      }
      fldFlag_thread_doneUpdating = true;
      
      
      n = 0;
      tf += fSpeed;
    }
    
    
  }
  
}