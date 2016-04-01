class Robot
{
  float xPos = random(screenWidth);
  float yPos = random(screenHeight);
  float xSpeed = 1.0;
  float ySpeed = 1.0;
  float robotDiameter = 20.0;
  float noseLength = robotDiameter/2;
  float heading = random(0, 2*PI);
  float[] distance = new float[maxLandmarks];
  float noiseForward = 0.0;
  float noiseTurn = 0.0;
  float noiseSense = 5.0;
  String nodeType = "";    //ROBOT or PARTICLE
  float prob = 1.0;
  
  
  Robot(String _nodeType)  
  {    
    nodeType = _nodeType;    
  }
  
  void set(float _xPos, float _yPos, float _Heading)
  {
    xPos = _xPos;
    yPos = _yPos;
    heading = _Heading;
  }
  
  void setNoise(float _noiseForward, float _noiseTurn, float _noiseSense)
  {
    noiseForward = _noiseForward;
    noiseTurn = _noiseTurn;
    noiseSense = _noiseSense;
  }
  
  void move(float _turnAngle, float _forward)
  {    
    float orientation = heading + _turnAngle + randomGaussian() * noiseTurn;    //Add _turnAngle to current heading    
   
    if (heading >= (2*PI)) heading -= (2*PI);
    if (heading <= (-2*PI)) heading += (2*PI);    
    
    float dist = _forward + randomGaussian() * noiseForward;
    float newX = xPos + dist * cos(orientation);
    float newY = yPos + dist * sin(orientation);
    xPos = newX;
    yPos = newY;
    
    //Ensures a cyclic world
    if (xPos > screenWidth) xPos =- screenWidth;
    if (xPos < 0) xPos += screenWidth;
    if (yPos > screenHeight) yPos =- screenHeight;
    if (yPos < 0) yPos += screenHeight;
    
    heading = orientation;
  }
  
  void display()
  {
    switch (nodeType)
    {
      case "ROBOT":
        stroke(0);
        fill(0,255,0);    
        ellipse(xPos, yPos, robotDiameter, robotDiameter);         
        textAlign(CENTER, CENTER);
        textSize(10);
        fill(0);
        //text(dist, xPos, yPos-10);        
        break;
      
      case "PARTICLE":
        stroke(255,0,0);
        fill(255,0,0);
        ellipse(xPos, yPos, prob*10, prob*10);
        //ellipse(xPos, yPos, 5, 5);
        textAlign(CENTER, CENTER);
        fill(0);
        //text(prob, xPos,yPos-10);
        //print(prob+",");
        break;
    } 
    stroke(0);
    float noseX = xPos + noseLength * cos(heading);        //Added a robot nose to indicate heading
    float noseY = yPos + noseLength * sin(heading);
    line (xPos, yPos, noseX, noseY);   
  }
  
  //Calculates linear distances to each landmark
  void sense()
  {
    for (int k = 0; k < maxLandmarks; k++)
    {
      distance[k] = dist(xPos, yPos, landmarks[k].xPos, landmarks[k].yPos);
      distance[k] += randomGaussian() * noiseSense;
    }
  }
  
  //Calculates the probability of how closely a particle's measurements to landmarks corespond with that of the robot.
  //A prob value is calculated for each landmark which is multiplied to all other probabilities of the specific particle
  //Uses a gausian with:
  //  mu     - Particle's measured distance to a landmark
  //  sigma  - Particle's measurement noise
  //  x      - Robot's measurement to the same landmark  
  void measurement_prob()
  {
    prob = 1.0;
    for (int k = 0; k < maxLandmarks; k++)
    {
      distance[k] = dist(xPos, yPos, landmarks[k].xPos, landmarks[k].yPos);      
      prob *= exp(- (pow(distance[k] - robot.distance[k],2) / pow(noiseSense,2)/2.0) / sqrt(2*PI * pow(noiseSense,2)));      
    }
  }
}