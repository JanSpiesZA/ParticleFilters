
int screenWidth = 400;
int screenHeight = 400;

int maxParticles = 100;
int maxLandmarks = 3;

boolean od = false;

Robot robot;
Landmark landmarks[] = new Landmark[maxLandmarks];
Robot particles[] = new Robot[maxParticles];

void setup()
{
  surface.setResizable(true);
  surface.setSize(screenWidth,screenHeight);
  
  robot = new Robot("ROBOT");
  
  //Create landmarks
  for (int k = 0; k < maxLandmarks; k++)
  {
    landmarks[k] = new Landmark();
  }
  
  //Creates particles
  for (int k = 0; k < maxParticles; k++)
  {
    particles[k] = new Robot("PARTICLE");
  }  
}

void draw()
{ 
  if (!od)
  {
  ownDraw();
  }
}

void ownDraw()
{
  od = true;
  background(200);  
  robot.sense();    //Calculates the straight line distance to each landmark
  robot.display();  
  
  
  for (int k = 0; k < maxParticles; k++)
  {
    particles[k].measurement_prob();   
  }
  
  resample();

  for (int k = 0; k < maxParticles; k++)
  {   
    particles[k].display();
  }
  
  for (int k = 0; k < maxLandmarks; k++)
  {
    landmarks[k].display();
  }
}

void resample()
{
  float W = 0.0;      //Sum of all the particles weights
  float beta = 0.0;
  float wm = 0.0;
  int index = int(random(maxParticles));  
  Robot tempParticles[] = new Robot[maxParticles];
  
  //Calculates the sum of all the probabilities
  for (int k=0; k < maxParticles; k++)
  {
    W += particles[k].prob;    
  }
  
  //Determines the biggest importance weight (prob)
  //Normalise the prob by dividing prob by the sum of all probs (W) and saving the value to alpha
  for (int k = 0; k < maxParticles; k++)
  {
   //particles[k].prob = particles[k].prob / W;   
   if (particles[k].prob > wm) 
   {
     wm = particles[k].prob;      
   }
  }  
   
  for (int i = 0; i < maxParticles; i++)
  {
    beta += random(0, 2*wm);   
    while (beta > particles[index].prob)
    {      
      beta -= particles[index].prob;
      index = (index + 1) % maxParticles;
    } 
    tempParticles[i] = particles[index];    
  }
  
  for (int k = 0; k < maxParticles; k++)
  {
    fill(0,0,255);
    ellipse(tempParticles[k].xPos, tempParticles[k].yPos, 20,20);    
  }
}
    

void mousePressed()
{
  if (mouseButton == LEFT)
  {
    //landmarks.set(mouseX, mouseY);
    robot.set(mouseX, mouseY, 0.0);
  }
  od = false;
}

void keyPressed()
{
  switch (key)
  {
    case '1':
      landmarks[0].xPos = mouseX;
      landmarks[0].yPos = mouseY;            
      break;
      
    case '2':
      landmarks[1].xPos = mouseX;
      landmarks[1].yPos = mouseY;            
      break;
      
    case '3':
      landmarks[2].xPos = mouseX;
      landmarks[2].yPos = mouseY;            
      break;
      
    case 'c':
      for (int k = 0; k < maxLandmarks; k++)
      {
        landmarks[k].set(random(width), random(height));
      }
      break;
      
    case 'n':
      od = false;
      break;
  }
}
  