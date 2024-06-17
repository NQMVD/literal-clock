boolean precise = true;
boolean edit = false;

int xoff = 100, yoff = 100;
int xspace = 100, yspace = 110;
int fontsize = 75, grey = 35;
float scale = 0.8;

float barlvl=0, barmax=100;
float counter=0, countermax=60 * 2;

float[][] kernel = {{ -1, -1, -1}, { -1, 8, -1}, { -1, -1, -1}};

char[][] grid = {
  {'E', 'S', 'K', 'I', 'S', 'T', 'A', 'F', 'Ü', 'N', 'F'}, 
  {'Z', 'E', 'H', 'N', 'Z', 'W', 'A', 'N', 'Z', 'I', 'G'}, 
  {'D', 'R', 'E', 'I', 'V', 'I', 'E', 'R', 'T', 'E', 'L'}, 
  {'V', 'O', 'R', 'F', 'U', 'N', 'K', 'N', 'A', 'C', 'H'}, 
  {'H', 'A', 'L', 'B', 'A', 'E', 'L', 'F', 'Ü', 'N', 'F'}, 
  {'E', 'I', 'N', 'S', 'X', 'A', 'M', 'Z', 'W', 'E', 'I'}, 
  {'D', 'R', 'E', 'I', 'P', 'M', 'J', 'V', 'I', 'E', 'R'}, 
  {'S', 'E', 'C', 'H', 'S', 'N', 'L', 'A', 'C', 'H', 'T'}, 
  {'S', 'I', 'E', 'B', 'E', 'N', 'Z', 'W', 'Ö', 'L', 'F'}, 
  {'Z', 'E', 'H', 'N', 'E', 'U', 'N', 'K', 'U', 'H', 'R'}
};
PFont f;
PImage lime;

void setup() {
  fullScreen();
  background(5, 5, 5);
  frameRate(1);
  //f = createFont("Qualy.ttf", fontsize);
  //textFont(font);
  textSize(fontsize * scale);
  // lime = loadImage("lime.png");
}

void draw() {
  background(5, 5, 5);
  imageMode(CENTER);
  // image(lime, width/2, height/2);
  //background(0, 100);

  // lime.loadPixels();
  // PImage grayImg = lime.copy();
  // grayImg.filter(GRAY); // grayImg.filter(BLUR);
  // PImage edgeImg = createImage(grayImg.width, grayImg.height, RGB);
  
  //for (int y = 1; y < grayImg.height-1; y++) {
  //  for (int x = 1; x < grayImg.width-1; x++) {
  //  float sum = 128;
  //  for (int ky = -1; ky <= 1; ky++) {
  //    for (int kx = -1; kx <= 1; kx++) {
  //      int pos = (y + ky)*grayImg.width + (x + kx);
  //      float val = blue(grayImg.pixels[pos]);
  //      sum += kernel[ky+1][kx+1] * val;
  //     }
  //   }
  //   edgeImg.pixels[y*edgeImg.width + x] = color(sum);
  // }
 // }
  //edgeImg.updatePixels();
  //image(edgeImage, width/2, height/2);


  xoff = width/2  - (10*int(xspace*scale))/2;
  yoff = height/2 - (9*int(yspace*scale))/2 + 230;
  int h = hour();
  int m = minute();

  for (int row = 0; row < grid.length; row++) {
    for (int col = 0; col < grid[row].length; col++) {
      char letter = grid[row][col];
      if (shouldHighlight(h, m, row, col)) fill(255);
      else fill(grey);
      textAlign(CENTER, CENTER);
      text(letter, col*(xspace*scale) + xoff, row*(yspace*scale) + yoff);
    }
  }
  
  if (mousePressed && edit) {
    counter++;
    if (counter>countermax) counter=countermax;
  } else {
    counter-=2;
    if (counter<0) counter=-60;
  }

  if (counter>0 && edit) {
    float x = mouseX-150;
    //text(int(counter), x-100, mouseY);
    strokeWeight(10);
    stroke(100);
    line(x, mouseY+100, x, mouseY-100);
    stroke(255);
    line(x, mouseY+100, x, mouseY-map(counter, 0, countermax, -100, 100));

    if (counter==countermax) {
      text("Scale: "+scale+"\nGrey: "+grey, x-200, mouseY);
      if (mouseY < (height/5)*2) {
        scale = map(mouseX, 100, width-100, 0.5, 0.9);
      } else if (mouseY > (height/5)*4) {
        grey = (int)map(mouseX, 100, width-100, 40, 70);
      }
    }
  }
}
// XXXX UHR
// FUNF NACH XXXX
// ZEHN NACH XXXX
// VIERTEL NACH XXXX
// ZWANZIG NACH XXXX
// FUNF VOR HALB XXXX
// HALB XXXX
// FUNF NACH HALB XXXX
// ZEHN NACH HALB XXXX
// VIERTEL VOR XXXX | DREIVIERTEL XXXX
// ZEHN VOR XXXX
// FUNF VOR XXXX

boolean shouldHighlight(int h, int m, int row, int col) {
  h = h%12;
  if (row == 0) {
    if (col==0 || col==1 || col==3 || col==4 || col==5) return true;
  }

  // minuten
  if ((m>=0 && m<=3) || (m>=57 && m<=60)) {
    if (row == 9) 
      if (col==8 || col==9 || col==10) return true;
    if (h==1 && row==5 && col==3) return false;
  }

  if (m>=4 && m<=7) {  // FUNF NACH
    if (row==0 && col>=7) return true;
    if (row==3 && col>=7) return true;
  }
  if (m>=8 && m<=12) { // ZEHN NACH
    if (row==1 && col<=3) return true;
    if (row==3 && col>=7) return true;
  }
  if (m>=13 && m<=17) {// VIERTEL NACH
    if (row==2 && col>=4) return true;
    if (row==3 && col>=7) return true;
  }
  if (m>=18 && m<=22) {// ZWANZIG NACH
    if (row==1 && col>=4) return true;
    if (row==3 && col>=7) return true;
  }
  if (m>=23 && m<=27) {// FUNF VOR HALB
    if (row==0 && col>=7) return true;
    if (row==3 && col<=2) return true;
    if (row==4 && col<=3) return true;
  }
  if (m>=28 && m<=32) {// HALB
    if (row==4 && col<=3) return true;
  }
  if (m>=33 && m<=37) {// FUNF NACH HALB
    if (row==0 && col>=7) return true;
    if (row==3 && col>=7) return true;
    if (row==4 && col<=3) return true;
  }
  if (m>=38 && m<=42) {// ZWANZIG VOR (ZEHN NACH HALB)
    if (row==1 && col>=4) return true;
    if (row==3 && col<=2) return true;
  }
  if (m>=43 && m<=47) {// VIERTEL VOR
    if (row==2 && col>=4) return true;
    if (row==3 && col<=2) return true;
  }
  if (m>=48 && m<=52) {// ZEHN VOR
    if (row==1 && col<=3) return true;
    if (row==3 && col<=2) return true;
  }
  if (m>=53 && m<=56) {// FUNF VOR
    if (row==0 && col>=7) return true;
    if (row==3 && col<=2) return true;
  }
  if (m>=23) h++;

  // studen
  if (h==1 && row==5 && col<=3) return true;
  if (h==2 && row==5 && col>=7) return true;
  if (h==3 && row==6 && col<=3) return true;
  if (h==4 && row==6 && col>=7) return true;
  if (h==5 && row==4 && col>=7) return true;
  if (h==6 && row==7 && col<=4) return true;
  if (h==7 && row==8 && col<=5) return true;
  if (h==8 && row==7 && col>=7) return true;
  if (h==9 && row==9 && col>=3 && col<=6) return true;
  if (h==10&& row==9 && col<=3) return true;
  if (h==11&& row==4 && col>=5 && col<=7) return true;
  if (h==12 || h==0) if (row==8 && col>=6) return true;

  return false;
}
