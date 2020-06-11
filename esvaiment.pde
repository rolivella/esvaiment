import java.util.concurrent.ThreadLocalRandom; //<>//
import java.util.*;
import processing.video.*;
PFont fontLoading, fontIntro, fontsubIntro, fontSummary;

//Declrataions:
Movie videoSubtitles;
PImage img;//Photo must be 512x512
Integer[] randomsWoEyes;
boolean buttonStartPressed,photoLoaded,photofadeInPhotoLoaded,videoFileLoaded;
int currTime, prevTime;  // millisec
float elapsedTime;       // seconds
int firstRandomWoEyes;
 
// Text: 
// Catalan: 
String loadingText = "Carregant...";
String introText = "ESVAÏMENT";
String subintroText = "per Roger Olivella";
String summaryText = "Poc abans de morir, el pare em va dir: \"aquesta enfermetat \nés com quan apaguen HAL a 2001...sento que me'n vaig lentament\".";
String startButtonText = "Clic";

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
float summaryTextX, summaryTextY;
int introTextW = 500;
int introTextH = 200;
//Subtitle: 
int subintroTextBackgroundColor = 0;
int subintroTextFillColor = 255;
int subintroTextSize = 34;
float subintroTextX, subintroTextY;
int subintroTextW = 500;
int subintroTextH = 200;
int summaryTextSize = 24;

// Start button constants: 
float startButtonX, startButtonY;      
int startButtonSize = 90;     
color startButtonBaseColor = color(0);
color startButtonHoverColor = color(255);
boolean isStartButtonHovered = false;
int startButtonStroke = 255;
int startButtonFill = 255;
int startButtonTextSize = 17;

// Photo constants: 
int photosize = 512;
String photoName = "data/pare.png";
float startTransparencyColor = 0;//photo transparency start color
float endTransparencyColor = 255;//photo transparency end color
float speedTransparency = 10;
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
boolean showNumInSquare = false;
int[] eyeSquares = { 284, 285, 309, 310, 290, 291, 315, 316 };//Eyes squares defined by hand 
float squaresFadeTime = 0.37;
float cumEllapsedTime = 0;
int n = 25;
float w = photosize;
float ox = 0;
float oy = 0;
int R = 0;
int counter = 0;
int counterEye = 0;
int counterPrevtime =0;
int fade = 0;
float a = w / n;//side of a shading square
int nn = n*n;
Integer[] randoms = new Integer[nn];
int fadeColor = 0;
int fadeEyeColor = 0;
boolean isDrawingSquares = false;

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
  fontSummary = createFont("microgramma.ttf", introTextSize); 
      
  //Auto-position: 
  //Photo and video: 
  oxphoto = (displayWidth-photosize)/2;
  oyphoto = ((displayHeight-photosize)/2)*0.6;
  oxvideo = oxphoto-oxphoto*0.1;
  oyvideo = oyphoto+1.01*photosize; 
  //Loading text: 
  loadingTextX = displayWidth/2;
  loadingTextY = displayHeight/2; 
  //Main menu: 
  introTextX = displayWidth/2;
  introTextY = displayHeight/6;
  subintroTextX = displayWidth/2;
  subintroTextY = displayHeight/4;
  startButtonX = subintroTextX-startButtonSize/2;
  startButtonY = subintroTextY*1.3;
  summaryTextX = displayWidth/2;
  summaryTextY = startButtonY*1.5;

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

  if (!videoFileLoaded) {//Video file loading not yet finished

    // "Loading" text: 
    background(loadingTextBackgroundColor);
    textFont(fontLoading, loadingTextSize);
    fill(loadingTextColor);
    textAlign(CENTER);
    text(loadingText, loadingTextX, loadingTextY);
    
    //thread("loadMovieFile");//diff thread to do not freeze program
    
  } else {//Video file loading already finished

    if (buttonStartPressed) {//Start button already pressed
      isDrawingSquares = true;
      isStartButtonHovered = false;
      noCursor();
          
      if (!photofadeInPhotoLoaded) {//Fade-in photo not finished

        fadeInPhoto();//photo fade-in
                
      } else { //Fade-in photo already finished
      
        if (showVideo == true) {
          //Play and locate video:
          videoSubtitles.play();
          image(videoSubtitles, oxvideo, oyvideo, widthVideo, heightVideo);
          if(counterPrevtime==0) prevTime = millis();
          counterPrevtime++;
        }
    
        //Show small black squares: 
        
        if (cumEllapsedTime <= squaresFadeTime) { //<>//
          if (counter < randomsWoEyes.length) { //<>//
            drawRandomSquare(randomsWoEyes[counter], showNumInSquare, fadeColor);
          } else {
            drawRandomSquare(eyeSquares[counterEye], showNumInSquare, fadeColor);
          }

          fade ++;
          currTime = millis();;
          elapsedTime = (currTime - prevTime) / 1000.0;
          cumEllapsedTime = cumEllapsedTime + elapsedTime;
          prevTime = currTime;  // set it up for the next frame
          
        } else {
          fade = 0;
          cumEllapsedTime = 0;
          counter++;
          if (counter == nn) {
            isDrawingSquares = false;
            videoSubtitles.stop();
            buttonStartPressed = false;
            photofadeInPhotoLoaded = false;
            photoLoaded = false;
            //videoFileLoaded = false;
            startTransparencyColor = 0;
            counter = 0;
            counterEye = 0;
            counterPrevtime = 0;
            fade = 0;
            delay(endDelay);
            buttonStartPressed = false;
            cursor();
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
      firstRandomWoEyes=randomsWoEyes[0];

      // Intro text: 
      background(introTextBackgroundColor);
      textFont(fontIntro, introTextSize);
      fill(introTextFillColor);
      textAlign(CENTER);
      text(introText, introTextX, introTextY);
      textFont(fontsubIntro, subintroTextSize);
      fill(subintroTextFillColor);
      text(subintroText, subintroTextX, subintroTextY);
      textFont(fontSummary, subintroTextSize);
      fill(subintroTextFillColor);
      textAlign(CENTER);
      textFont(fontsubIntro, summaryTextSize);
      text(summaryText, summaryTextX, summaryTextY);

      //Start button hover system: 
      updateStartButton();
      if (isStartButtonHovered) {
        fill(startButtonHoverColor);
      } else {
        fill(startButtonBaseColor);
      }
      stroke(startButtonStroke);
      rect(startButtonX, startButtonY, startButtonSize, startButtonSize);
      fill(startButtonFill);
      textSize(startButtonTextSize);
      text(startButtonText, startButtonX+45, startButtonY+70);

    }
  }
}//end draw

void updateStartButton() {
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
  }
  tint(255, startTransparencyColor);
  image(img, oxphoto, oyphoto);
}

void mousePressed() {
  if(!isDrawingSquares){
    if (isStartButtonHovered) {
      buttonStartPressed = true;
    } else {
      buttonStartPressed = false;
    }
  }
}

void keyPressed()
{
 if(key == 27 && isDrawingSquares) {
  exit();
 } else {
  key = 0;
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
  fill(fadeColorSet, map(fade, 0, squaresFadeTime, 0, 255));
  stroke(fadeColorSet, map(fade, 0, squaresFadeTime, 0, 255));
  rect(oxphoto+ox, oyphoto+oy, a, a);
  if (showtext) {
    fill(255);
    textSize(8); 
    text(random, oxphoto+ox+10, oyphoto+oy+15);
  }
}
