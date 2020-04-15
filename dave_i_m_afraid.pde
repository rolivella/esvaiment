import java.util.Arrays;
import java.util.Collections;
import processing.sound.*;
SoundFile file;

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
int fade = 0;
boolean buttonPressed;
int buttonX, buttonY, buttonW, buttonH;
int state = 0;//state=0 intro screen, state=1 image screen

void setup() {
  
  //General variables:
  frameRate(500);
  size(512,512);
  
  // Assume the button has not been pressed
  buttonPressed = false;
  
  // Some basic parameters for a button
  buttonW = 100;
  buttonH = 40;
  textSize(buttonH);
  buttonX = (width-buttonW)/2;
  buttonY = (height-buttonH)/2;
 
  //Generate random array numbers for positioning small squares:
  for (int i = 1; i <= randoms.length; i++) randoms[i-1] = i; //<>//
  Collections.shuffle(Arrays.asList(randoms)); //<>//
  
}

void draw() { //<>//
  
  if (buttonPressed) {
    state = 1;
    if(counter == 0){
      loadMedia();
    }
  } else {
    state = 0;
    // Intro text: 
    String s = "The quick brown fox jumps over the lazy dog.";
    fill(50);
    textSize(10); 
    text(s, 100, 50, 200, 200);  // Text wraps within text box
    // Show the button
    fill(255);
    rect(buttonX, buttonY, buttonW, buttonH);
    fill(0);
    textSize(25);
    text("START", buttonX+10, buttonY+buttonH-10);
  }
  
  if (state == 1) {
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
  
}

void loadMedia() {
  // Image load: 
  img = loadImage("photo/oldman.jpg");
  image(img, 0, 0);
  //Sound file: load and play
  file = new SoundFile(this, "audio/i_am_afraid_dave.mp3");
  file.play();
}

void mousePressed() {
  if (mouseX > buttonX && mouseX < buttonX+buttonW && mouseY > buttonY && mouseY < buttonY+buttonH)
    buttonPressed = true;
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
