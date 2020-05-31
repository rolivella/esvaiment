import java.util.concurrent.ThreadLocalRandom; //<>//
import java.util.*;
import processing.video.*;
PFont fontLoading, fontIntro, fontsubIntro;

//Declrataions:
Movie videoSubtitles;
PImage img;//Photo must be 512x512
Integer[] randomsWoEyes;
boolean buttonStartPressed,photoLoaded,photofadeInPhotoLoaded,videoFileLoaded;
 
// Text: 
// Catalan: 
String loadingText = "Carregant...";
String introText = "ESVAÏMENT";
String subintroText = "per Roger Olivella";
String startButtonText = "";

// Loading text constants: 
float loadingTextX, loadingTextY;
int loadingTextBackgroundColor = 0;
int loadingTextColor = 255;
int loadingTextSize = 54;

// Intro text constants: 
int introTextBackgroundColor = 0;
int introTextFillColor = 255;
int introTextSize = 64;
float introTextX, introTextY;
int introTextW = 500;
int introTextH = 200;
//Subtitle: 
int subintroTextBackgroundColor = 0;
int subintroTextFillColor = 255;
int subintroTextSize = 34;
float subintroTextX, subintroTextY;
int subintroTextW = 500;
int subintroTextH = 200;

// Start button constants: 
float startButtonX, startButtonY;      
int startButtonSize = 90;     
color startButtonBaseColor = color(0);
color startButtonHoverColor = color(255);
boolean isStartButtonHovered = false;
int startButtonStroke = 255;
int startButtonFill = 255;

// Photo constants: 
int photosize = 512;
String photoName = "data/oldman.jpg";
float startTransparencyColor = 0;//photo transparency start color
float endTransparencyColor = 255;//photo transparency end color
float speedTransparency = 10;//0.75
float oxphoto, oyphoto;

// Video constants: 
String videoName = "hal.mp4";
float oxvideo, oyvideo;
//float widthVideo = 784;//width video
//float heightVideo = 112;//height video
float widthVideo = 640;//width video
float heightVideo = 81;//height video
boolean showVideo = true;//video length: 3min 56 sec = 236 sec

// Small squares constants: 
int[] eyeSquares = { 234, 235, 259, 260 };//Eyes squares defined by hand 
int smallSquaresFadeSpeed = 21;//21->237 sec aprox. (less, faster)
int n = 25;
float w = photosize;
float ox = 0;
float oy = 0;
int R = 0;
int counter = 0;
int counterEye = 0;
int fade = 0;
float a = w / n;//side of a shading square
int nn = n*n;
Integer[] randoms = new Integer[nn];
boolean showNumInSquare = false;
int fadeColor = 0;
int fadeEyeColor = 0;

// Other constants: 
int endDelay = 5000;
int frameRate = 60;

void setup() {
   
  // General variables:
  frameRate(frameRate);
  fullScreen();
  
  //Load fonts: 
  fontLoading = createFont("microgramma.ttf", loadingTextSize); 
  fontIntro = createFont("microgramma.ttf", introTextSize); 
  fontsubIntro = createFont("microgramma.ttf", introTextSize);
    
  //Auto-position: 
  oxphoto = (displayWidth-photosize)/2;
  oyphoto = ((displayHeight-photosize)/2)*0.6;
  oxvideo = oxphoto-oxphoto*0.1;
  oyvideo = oyphoto+1.01*photosize; 
  loadingTextX = oxphoto*1.05;
  loadingTextY = oyphoto*4; 
  introTextX = oxphoto;
  introTextY = oyphoto;
  subintroTextX = oxphoto*1.1;
  subintroTextY = oyphoto*1.55;
  startButtonX = subintroTextX*1.14;
  startButtonY = subintroTextY*1.55;

  // Assume start button has not been pressed
  buttonStartPressed = false;

  //Load movie: 
  videoFileLoaded = false; 
  thread("loadMovieFile");//diff thread to do not freeze program

  //Load photo file: 
  photoLoaded = false;  
  photofadeInPhotoLoaded = false;
  thread("loadPhotoFile");//diff thread to do not freeze program
  
}

void draw() {
  
  //videoFileLoaded = false;

  if (!videoFileLoaded) {//Video file loading not yet finished

    // "Loading" text: 
    background(loadingTextBackgroundColor);
    textFont(fontLoading, loadingTextSize);
    fill(loadingTextColor);
    text(loadingText, loadingTextX, loadingTextY);
    
  } else {//Video file loading already finished

    if (buttonStartPressed) {//Start button already pressed

      if (!photofadeInPhotoLoaded) {//Fade-in photo not finished

        fadeInPhoto();//photo fade-in
        
      } else { //Fade-in photo already finished

        if (showVideo == true) {
          //Play and locate video:
          videoSubtitles.play();
          image(videoSubtitles, oxvideo, oyvideo, widthVideo, heightVideo);
        }

        //Show small black rectangles: 
        if (fade <= smallSquaresFadeSpeed) {

          if (counter < randomsWoEyes.length) {
            drawRandomSquare(randomsWoEyes[counter], showNumInSquare, fadeColor);
          } else {
            drawRandomSquare(eyeSquares[counterEye], showNumInSquare, fadeColor);
          }

          fade ++;
        } else {
          fade = 0;
          counter++;
          if (counter == nn) {
            buttonStartPressed = false;
            photofadeInPhotoLoaded = false;
            counter = 0;
            counterEye = 0;
            fade = 0;
            delay(endDelay);
            //println("End sec: "+millis()/1000);
          } 
          if (counter > randomsWoEyes.length) counterEye++;
        }//end small rectangles
      }
    } else {//Start button not yet pressed

      // Generate random array numbers for positioning small black squares:
      for (int i = 1; i <= randoms.length; i++) randoms[i-1] = i;
      Collections.shuffle(Arrays.asList(randoms));
      shuffleArray(eyeSquares);
      int randomsSize = randoms.length;
      int eyesSize = eyeSquares.length;
      int randomOKSize = randomsSize - eyesSize;
      int k = 0;
      randomsWoEyes = new Integer[randomOKSize];
      for (int i = 0; i < randomsSize; i++) {
        boolean isEye = false;
        for (int j = 0; j < eyesSize; j++) {
          if (randoms[i] == eyeSquares[j]) {
            isEye = true;
          }
        }
        if (!isEye) {
          randomsWoEyes[k]=randoms[i];
          k++;
        }
      }

      // Intro text: 
      background(introTextBackgroundColor);
      textFont(fontIntro, introTextSize);
      fill(introTextFillColor);
      text(introText, introTextX, introTextY, introTextW, introTextH);//Text wraps within text box
      textFont(fontsubIntro, subintroTextSize);
      fill(subintroTextFillColor);
      text(subintroText, subintroTextX, subintroTextY, subintroTextW, subintroTextH);//Text wraps within text box

      //Start button hover system: 
      updateStartButton(mouseX, mouseY);
      if (isStartButtonHovered) {
        fill(startButtonHoverColor);
      } else {
        fill(startButtonBaseColor);
      }
      stroke(startButtonStroke);
      rect(startButtonX, startButtonY, startButtonSize, startButtonSize);
      fill(startButtonFill);
      text(startButtonText, startButtonX+10, startButtonY+10);

    }
  }
}//end draw

void updateStartButton(int x, int y) {
  if ( overStartButton(startButtonX, startButtonY, startButtonSize, startButtonSize) ) {
    isStartButtonHovered = true;
  } else {
    isStartButtonHovered = false;
  }
}

boolean overStartButton(float x, float y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

void loadMovieFile() {
  if (showVideo == true) {
    videoSubtitles = new Movie(this, videoName);
  }
  videoFileLoaded = true;
}

void loadPhotoFile() {
  img = loadImage(photoName);
  photoLoaded = true;
}

void fadeInPhoto() {//Fade-in photo 
  background(0);
  if (startTransparencyColor < endTransparencyColor) { 
    startTransparencyColor += speedTransparency; 
  } else {
    photofadeInPhotoLoaded = true;
    //println("Start sec: "+millis()/1000);
  }
  tint(255, startTransparencyColor);
  image(img, oxphoto, oyphoto);
}

void mousePressed() {
  if (isStartButtonHovered) {
    buttonStartPressed = true;
  }
}

void movieEvent(Movie m) {
  m.read();
}

// Implementing Fisher–Yates shuffle
void shuffleArray(int[] ar)
{
  // If running on Java 6 or older, use `new Random()` on RHS here
  Random rnd = ThreadLocalRandom.current();
  for (int i = ar.length - 1; i > 0; i--)
  {
    int index = rnd.nextInt(i + 1);
    // Simple swap
    int a = ar[index];
    ar[index] = ar[i];
    ar[i] = a;
  }
}

void drawRandomSquare(int random, boolean showtext, int fadeColorSet) {
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
  fill(fadeColorSet, map(fade, 0, smallSquaresFadeSpeed, 0, 255));
  stroke(fadeColorSet, map(fade, 0, smallSquaresFadeSpeed, 0, 255));
  rect(oxphoto+ox, oyphoto+oy, a, a);
  if (showtext) {
    fill(255);
    textSize(10); 
    text(random, oxphoto+ox+0, oyphoto+oy+15);
  }
}
