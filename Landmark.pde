class Landmark
{
  float xPos, yPos;
  
  Landmark()
  {
    xPos = random(width);
    yPos = random(height);
  }
  
  Landmark(float _xPos, float _yPos)
  {
    xPos = _xPos;
    yPos = _yPos;
  }
    
  
  void set(float _xPos, float _yPos)
  {
    xPos = _xPos;
    yPos = _yPos;
  }
  
  void display()
  {
    stroke(0);
    fill(0,0,255);
    rectMode(CENTER);
    rect(xPos, yPos, 5, 5);
  }
    
  
}