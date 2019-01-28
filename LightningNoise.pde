int sizeX = 1000;
int sizeY = 1000;


float noiseScale = .02;
void setup(){
  size(1000,1000);
  //for(int i = 0; i < sizeX; i++){
  //  for(int j = 0; j < sizeY; j++){
  //    set(i,j,color((int)(noise(i*noiseScale,j*noiseScale)*255)));
  //    //print(noise(i,j)+"\n");
  //  }
  //}
}

private class Point{
  private int x;
  private int y;
  
  public Point(int X, int Y){
    x = X;
    y = Y;
  }
  
  public int getX(){return x;}
  public int getY(){return y;}
  public float distance(Point p2){
    return sqrt(pow((p2.getX()-x),2)+pow((p2.getY()-y),2));
  }
}



void lightning(Point po, Point pf, int jumpDist){  
  while (po.distance(pf) > jumpDist*2){
    int subDiv = 32;
    Point[] possible = new Point[subDiv];
    //goes through a bunch of potential angles and records their resulting points
    for(int i = 0; i < subDiv; i++){
        int newX = po.getX() + (int)(jumpDist * cos(2*PI*i/subDiv));
        int newY = po.getY() + (int)(jumpDist * sin(2*PI*i/subDiv));
        possible[i] = new Point(newX,newY);
    }
    Point bestPoint = po;
    float bestDistance = po.distance(pf);
    for(Point pc : possible){ // finds which of the previously found points is the best one
      float cDist = pc.distance(pf);
      float noiseWeight = noise(pc.getX()*noiseScale,pc.getY()*noiseScale);
      float weightedDist = ((cDist-(po.distance(pf)-jumpDist))/(2*jumpDist));
      float combinedWeight = pow(weightedDist,3) + (noiseWeight); // multiply Dist and Noise here to influence importance
      if(combinedWeight <= bestDistance){ // this is where i insert all the weights dude
        
        bestDistance = combinedWeight;
        bestPoint = pc;
      }
    }
    //print("("+bestPoint.getX()+","+bestPoint.getY()+")\n");
    strokeWeight(5);
    stroke(color(46, 207, 232));
    line(po.getX(),po.getY(),bestPoint.getX(),bestPoint.getY());
    po = bestPoint;
  }
  line(po.getX(),po.getY(),pf.getX(),pf.getY());
}

int oldMouseX = 0;
int oldMouseY = 0;
void draw() {
  background(31,41,59);
  int randomness = 0;
  int randomMouseX = (int)(mouseX-(randomness/2)+random(randomness));
  int randomMouseY = (int)(mouseY-(randomness/2)+random(randomness));
  lightning(new Point(500,500),new Point(mouseX,mouseY),10);
  if(mousePressed){
    noiseSeed((long)random(50));
  }
}