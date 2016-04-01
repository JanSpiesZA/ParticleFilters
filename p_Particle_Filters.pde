
int screenWidth = 400;
int screenHeight = 400;

int maxParticles = 1000;
int maxLandmarks = 3;

float noiseForward = 1.0;
float noiseTurn = 0.1;
float noiseSense = 5.0;

boolean od = false;

Robot robot;
Landmark landmarks[] = new Landmark[maxLandmarks];
Robot particles[] = new Robot[maxParticles];

void setup()
{
  surface.setResizable(true);
  surface.setSize(screenWidth,screenHeight);
  
  robot = new Robot("ROBOT");
  robot.set(screenWidth/2, screenHeight/2, 0);
  
  //Create landmarks
  for (int k = 0; k < maxLandmarks; k++)
  {
    landmarks[k] = new Landmark();
  }
  
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
  robot.sense();
  
  for (int k = 0; k < maxParticles; k++)
  {    
    particles[k].measurement_prob();
    particles[k].display();
  }
  
  for (int k = 0; k < maxLandmarks; k++)
  {
    landmarks[k].display();
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
    case '1':
      landmarks[0].xPos = mouseX;
      landmarks[0].yPos = mouseY; 
      od = false;
      break;
      
    case '2':
      landmarks[1].xPos = mouseX;
      landmarks[1].yPos = mouseY;
      od = false;
      break;
      
    case '3':
      landmarks[2].xPos = mouseX;
      landmarks[2].yPos = mouseY;
      od = false;
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
      
    case 'r':
      resample();
      od = false;
      break;
  }
}
  