
int screenWidth = 400;
int screenHeight = 400;

int maxParticles = 1000;
int maxLandmarks = 3;

float noiseForward = 1.0;
float noiseTurn = 0.1;
float noiseSense = 5.0;

boolean od = false;

Robot robot;
Robot particles[] = new Robot[maxParticles];
ArrayList<Landmark> landMarks = new ArrayList<Landmark>();

void setup()
{
  surface.setResizable(true);
  surface.setSize(screenWidth,screenHeight);
  
  robot = new Robot("ROBOT");
  robot.set(screenWidth/2, screenHeight/2, 0);
  
  //Creates particles
  for (int k = 0; k < maxParticles; k++)
  {
    particles[k] = new Robot("PARTICLE");
    particles[k].setNoise(noiseForward, noiseTurn, noiseSense);    //Add noise to newly created particle    
  }  
}

void draw()
{ 
  if (!od) ownDraw(); 
}

void ownDraw()
{
  od = true;
  background(200);
  
  for (int k = 0; k < landMarks.size(); k++)
  {
    landMarks.get(k).display();
  }
  
  robot.sense();
  
  for (int k = 0; k < maxParticles; k++)
  {    
    particles[k].measurement_prob();
    particles[k].display();
  } 
  
  robot.display();
}

void resample()
{
  float W = 0.0;      //Sum of all the particles weights
  float beta = 0.0;
  float wm = 0.0;
  int index = int(random(maxParticles));  
  float alpha = 0.0;    //Normalised weight using all the added prob values of the particles
  Robot tempParticles[] = new Robot[maxParticles];  
  
  for(int k=0; k < maxParticles; k++)
  {
    tempParticles[k] = new Robot("PARTICLE");
  }  
  
  //Determines the biggest importance weight (prob)  
  for (int k = 0; k < maxParticles; k++)
  {      
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
   tempParticles[i].set(particles[index].xPos, particles[index].yPos, particles[index].heading);
   tempParticles[i].setNoise(noiseForward, noiseTurn, noiseSense);
  }
  
  ////Normalise the prob by dividing prob by the sum of all probs (W) and saving the value to alpha
  ////Calculates the sum of all the probabilities
  //for (int k=0; k < maxParticles; k++)
  //{
  //  W += particles[k].prob;    
  //}
  //for (int k=0; k < maxParticles; k++)
  //{
  //  particles[k].prob = particles[k].prob / W;
  //}
  
  particles = tempParticles;
  
  //arrayCopy(tempParticles, particles);
  
  
  //for (int k = 0; k < maxParticles; k++)
  //{
  //  println(k + ": "+particles[k].xPos + " : "+ particles[k].yPos +" : " + particles[k].noiseForward);
  //}
  
  //for (int k = 0; k < maxParticles; k++)
  //{
  //  fill(0,0,255);
  //  ellipse(tempParticles[k].xPos, tempParticles[k].yPos, 20,20);    
  //}
}    

void mousePressed()
{
  boolean landMarkFound = false;
  int idx = 0;   
  
  if (mouseButton == LEFT) 
  {      
    for (int k = 0; k < landMarks.size(); k++)
    {
      float distToLandMark = dist(mouseX,mouseY, landMarks.get(k).xPos, landMarks.get(k).yPos);
      if (distToLandMark < 10)
      {        
        landMarkFound = true;
        idx = k;
      }
    }    
    
    if (landMarkFound)
    {
      landMarks.remove(idx);      
    }
    else
    {
      landMarks.add(new Landmark(mouseX,mouseY));
    }  
    od = false;
  }
  
  if (mouseButton == RIGHT)
  {    
    robot.set(mouseX, mouseY, 0.0);   
    od = false;
  }  
}

void keyPressed()
{
  switch (key)
  {
    case 'w':
      robot.move(0,1);
      for (int k = 0; k < maxParticles; k++)
      {
        particles[k].move(0.0,1.0);
      }      
      resample();
      od = false;
      break;
      
    case 'a':
      robot.move(-0.1,0.0);
      for (int k = 0; k < maxParticles; k++)
      {
        particles[k].move(-0.1,0.0);
      }      
      resample();
      od = false;
      break;
      
    case 'd':
      robot.move(0.1, 0.0);
      for (int k = 0; k < maxParticles; k++)
      {
        particles[k].move(0.1, 0.0);
      }      
      resample();
      od = false;
      break;
  }
}
  