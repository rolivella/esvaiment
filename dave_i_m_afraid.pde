import java.util.Arrays;
import java.util.Collections;
import processing.sound.*;
SoundFile file;
float transparency = 0;
PImage img;
int n = 25;
float w = 512;
float h = 512; 
float ox = 0;
float oy = 0;
float a = w / n;//side of a shading square
int R = 0;
int nn = n*n;
Integer[] randoms = new Integer[nn];
int[] eyeRects = { 234, 235, 259, 260, 261 };//Eyes squares defined by hand: 
int counter = 0;
int mediaCounter = 0;
int fade = 0;
boolean buttonStartPressed;
int buttonX, buttonY, buttonW, buttonH;
boolean soundFileLoaded;
boolean imageLoaded;
boolean imageFadeinLoaded;

void setup() {
  
  // General variables:
  frameRate(500);
  size(512,512);
  
  // Assume the button has not been pressed
  buttonStartPressed = false;
 
  // Some basic parameters for the button:
  buttonW = 100;
  buttonH = 40;
  textSize(buttonH);
  buttonX = (width-buttonW)/2;
  buttonY = (height-buttonH)/2;
 
  // Generate random array numbers for positioning small black squares:
  for (int i = 1; i <= randoms.length; i++) randoms[i-1] = i; //<>//
  Collections.shuffle(Arrays.asList(randoms)); //<>//
  
  //Load sound file: 
  soundFileLoaded = false;  
  thread("loadSoundFile");//diff thread to do not freeze program
  
  //Load photo file: 
  imageLoaded = false;  
  imageFadeinLoaded = false;
  thread("loadImageFile");//diff thread to do not freeze program
  
}

void draw() { //<>//
  
  if(!soundFileLoaded){//Sound file loading not yet finished
   
    // "Loading" text: 
    fill(255);
    rect(buttonX, buttonY, buttonW, buttonH);
    fill(0);
    textSize(25);
    text("Loading", buttonX+10, buttonY+buttonH-10);
    
  } else {//Sound file loading already finished
  
    if (buttonStartPressed) {//Start button already pressed
    
      if(!imageFadeinLoaded) {//Fade-in photo not finished
        fadeIn();
      } else { //Fade-in photo already finished
        if(fade <= 40){
          boolean isEye = false;
          for(int i = 0; i < eyeRects.length; i++){
            if(randoms[counter] == eyeRects[i]) isEye= true;
          }
          if (!isEye) drawRectangle(randoms[counter],false);
          fade ++;
        } else {
          fade = 0;
          counter++;
          if(counter == nn) noLoop();
        }
      }
      
    } else {//Start button not yet pressed
    
      // Intro text: 
      String s = "This project bla bla bla...";
      fill(50);
      textSize(10); 
      text(s, 100, 50, 200, 200);//Text wraps within text box
      // Show the button
      fill(255);
      rect(buttonX, buttonY, buttonW, buttonH);
      fill(0);
      textSize(25);
      text("START", buttonX+10, buttonY+buttonH-10);
    }

  }
  
}//end draw

void loadSoundFile() {
  file = new SoundFile(this, "audio/i_am_afraid_dave.mp3");
  soundFileLoaded = true;
}

void loadImageFile() {
  img = loadImage("photo/oldman.jpg");
  imageLoaded = true;
}

void fadeIn() {//Fade-in photo   
    background(0);
    if (transparency < 255) { 
      transparency += 0.75; 
    } else {
      imageFadeinLoaded = true;
    }
    tint(255, transparency);
    image(img, 0, 0);
}

void mousePressed() {
  if (mouseX > buttonX && mouseX < buttonX+buttonW && mouseY > buttonY && mouseY < buttonY+buttonH)
    buttonStartPressed = true;
}

void drawRectangle(int random, boolean showtext) {
  int r = random % n;//reminder 
  int q = (int)(random / n);//quocient
  if (r == 0) {
    ox = (n-1)*a;
    oy = (q-1)*a;    
  } else {
    if (random > n) {
      ox = (r-1)*a;
      oy = q*a;
    } else {
      ox = (r-1)*a;
      oy = 0;
    }
  }
  fill(0,fade);
  noStroke();
  rect(ox, oy, a, a);
  fill(255);
  if(showtext) text(random, ox+0, oy+15);
}
