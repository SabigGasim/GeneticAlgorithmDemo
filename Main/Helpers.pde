final float SCROLL_FACTOR = 1.1;

void mouseWheel(MouseEvent event) {
  float scrollCount = event.getCount();
  
  if (scrollCount < 0) {
    FrameRate *= SCROLL_FACTOR; 
  } else if (scrollCount > 0) {
    FrameRate /= SCROLL_FACTOR;
  }
  FrameRate = constrain(FrameRate, 10, 2000);
  println("Frame rate: " + FrameRate);
  frameRate(FrameRate);
}

void mousePressed() {
  if (mouseButton == LEFT) 
  {
    noLoop();
  }
}

void mouseReleased() {
  if (mouseButton == LEFT) 
  {
    loop();
  }
}

void PrintOptimizationComplete()
{
  fill(color(252, 194, 3));
  text("Steps optimization complete!", width/2, height/2);
  noLoop();
}
