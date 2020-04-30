import java.util.Arrays; //<>//
import java.util.Collections;
import processing.video.*;

Movie videoSubtitles;
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
int fade = 0;
boolean buttonStartPressed;
int buttonX, buttonY, buttonW, buttonH;
boolean photoLoaded;
boolean photoFadeinLoaded;
boolean videoFileLoaded;
String videoName = "dave_i_m_afraid.mp4";
String photoName = "photo/oldman.jpg";

float offsetX = 450;//ox photo
float offsetY = 50;//oy photo
float oxvideo = 300;//ox video
float oyvideo = 600;//oy video
float widthVideo = 784;//width video
float heightVideo = 112;//height video

int endDelay = 5000;

boolean showVideo = true;

void setup() {

  // General variables:
  frameRate(500);
  fullScreen();

  // Assume start button has not been pressed
  buttonStartPressed = false;

  // Some basic parameters for the start button:
  buttonW = 100;
  buttonH = 40;
  textSize(buttonH);
  buttonX = (width-buttonW)/2;
  buttonY = (height-buttonH)/2;



  //Load movie: 
  videoFileLoaded = false; 
  thread("loadMovieFile");//diff thread to do not freeze program
 
  //Load photo file: 
  photoLoaded = false;  
  photoFadeinLoaded = false;
  thread("loadPhotoFile");//diff thread to do not freeze program
  
}

void draw() {

  if (!videoFileLoaded) {//Video file loading not yet finished

    // "Loading" text: 
    fill(255);
    rect(buttonX, buttonY, buttonW, buttonH);
    fill(0);
    textSize(25);
    text("Loading", buttonX+10, buttonY+buttonH-10);
    
  } else {//Video file loading already finished

    if (buttonStartPressed) {//Start button already pressed

      if (!photoFadeinLoaded) {//Fade-in photo not finished
      
        fadeIn();//photo fade-in
        
      } else { //Fade-in photo already finished
      
        if(showVideo == true){
          //Play and locate video:
          videoSubtitles.play();
          image(videoSubtitles, oxvideo, oyvideo, widthVideo, heightVideo);
        }

        //Show small black rectangles: 
        if (fade <= 40) {
          boolean isEye = false;
          for (int i = 0; i < eyeRects.length; i++) {
            if (randoms[counter] == eyeRects[i]) isEye= true;
          }
          if (!isEye) drawRectangle(randoms[counter], false);
          fade ++;
        } else {
          fade = 0;
          counter++;
          if (counter == nn) {
            buttonStartPressed = false;
            photoFadeinLoaded = false;
            counter = 0;
            fade = 0;
            delay(endDelay);
          }
        }//end small rectangles

      }
      
    } else {//Start button not yet pressed
    
      // Generate random array numbers for positioning small black squares:
      for (int i = 1; i <= randoms.length; i++) randoms[i-1] = i;
      Collections.shuffle(Arrays.asList(randoms));

      // Intro text: 
      background(100);
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

void loadMovieFile() {
  if(showVideo == true){
    videoSubtitles = new Movie(this, videoName);
  }
  videoFileLoaded = true;
}

void loadPhotoFile() {
  img = loadImage(photoName);
  photoLoaded = true;
}

void fadeIn() {//Fade-in photo   
  background(0);
  if (transparency < 255) { 
    transparency += 10; //0.75
  } else {
    photoFadeinLoaded = true;
  }
  tint(255, transparency);
  image(img, offsetX, offsetY);
}

void mousePressed() {
  if (mouseX > buttonX && mouseX < buttonX+buttonW && mouseY > buttonY && mouseY < buttonY+buttonH)
    buttonStartPressed = true;
}

void movieEvent(Movie m) {
  m.read();
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
  fill(0, fade);
  noStroke();
  rect(offsetX+ox, offsetY+oy, a, a);
  fill(255);
  if (showtext) text(random, ox+0, oy+15);
}
