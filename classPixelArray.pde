class PixelArray {
  Pix[] P;
  int[] I;    // indices
  int[] B;    // bands
  int num;
  
  PixelArray() {
    this.num = 0;
    ArrayList<Pix> PT = new ArrayList<Pix>();
    for( int x = 0 ; x < halfWidth ; x++ ) {
      for( int y = 0 ; y < halfHeight ; y++ ) {
        float r = sqrt(float(x*x+y*y));
        if( y <= x && r <= outerRadius &&
            !(r > hBandCenter - 0.5*hBandWidth && r < hBandCenter + 0.5*hBandWidth) &&
            !(r > mBandCenter - 0.5*mBandWidth && r < mBandCenter + 0.5*mBandWidth) &&
            !(r > sBandCenter - 0.5*sBandWidth && r < sBandCenter + 0.5*sBandWidth)
        
        ) {
          PT.add( new Pix( x , y ) );
          num++;
        }
      }
    }
    P = new Pix[num];
    B = new int[num];
    for( int i = 0 ; i < num ; i++ ) {
      P[i] = PT.get(i).copy();
      float x = float(P[i].xp[0]) - halfWidth;
      float y = float(P[i].yp[0]) - halfHeight;
      float r = sqrt( x*x + y*y );
      if( r <= outerRadius && r >= sBandCenter - 0.5*sBandWidth ) { B[i] = 3; }
      else if( r <= sBandCenter + 0.5*sBandWidth && r >= mBandCenter - 0.5*mBandWidth ) { B[i] = 2; }
      else if( r <= mBandCenter + 0.5*mBandWidth && r >= hBandCenter - 0.5*hBandWidth ) { B[i] = 1; }
      else { B[i] = 0; }
    }
    
    this.I = new int[width*height];
    for( int i = 0 ; i < width*height ; i++ ) {
      I[i] = -1;
    }
    for( int i = 0 ; i < num ; i++ ) {
      for( int p = 0 ; p < P[i].np ; p++ ) {
        I[ P[i].xp[p] + P[i].yp[p]*width ] = i;
      }
    }
  }
}

class Pix {
  int[] xp;          // x coordinate of screen pixels
  int[] yp;          // y coordinate of screen pixels
  int[] ip;          // indeces of pixels
  int np;
  float xr;          // render x coord 
  float yr;          // render y coord
  
  Pix() {
  }
  
  Pix( int xin , int yin ) {
    this.np = 4;
    IntList xt = new IntList();
    IntList yt = new IntList();
    
    xt.append( halfWidth + xin );
    yt.append( halfHeight + yin );
    
    xt.append( halfWidth-1 - xin );
    yt.append( halfHeight-1 - yin );
  
    xt.append( halfWidth + xin );
    yt.append( halfHeight-1 - yin );
    
    xt.append( halfWidth-1 - xin );
    yt.append( halfHeight + yin );
    
    if( (xin < halfHeight) && (yin < halfWidth) && (xin != yin) ) {
      this.np = 8;
      
      yt.append( halfHeight + xin );
      xt.append( halfWidth + yin );
      
      yt.append( halfHeight-1 - xin );
      xt.append( halfWidth-1 - yin );
    
      yt.append( halfHeight + xin );
      xt.append( halfWidth-1 - yin );
      
      yt.append( halfHeight-1 - xin );
      xt.append( halfWidth + yin );
    }
    this.xp = new int[np];
    this.yp = new int[np];
    this.ip = new int[np];
    for( int i = 0 ; i < np ; i++ ) {
      xp[i] = xt.get(i);
      yp[i] = yt.get(i);
      ip[i] = xt.get(i) + yt.get(i)*width;
    }
    
    float ang = atan2( float(yin) , float(xin) ) % ( TWO_PI/12.0 );
    if( ang > 0.5*( TWO_PI/12.0 ) ) {
      ang = TWO_PI/12.0 - ang ;
    }
    float rad = sqrt( float(xin*xin) + float(yin*yin) );
    this.xr = rad*cos(ang);
    this.yr = rad*sin(ang);
  }
  
  Pix copy() {
    Pix output = new Pix();
    output.np = this.np;
    output.xr = this.xr;
    output.yr = this.yr;
    output.xp = new int[np];
    output.yp = new int[np];
    output.ip = new int[np];
    for( int i = 0 ; i < np ; i++ ) {
      output.xp[i] = this.xp[i];
      output.yp[i] = this.yp[i];
      output.ip[i] = this.ip[i];
    }
    return output;
  }
}