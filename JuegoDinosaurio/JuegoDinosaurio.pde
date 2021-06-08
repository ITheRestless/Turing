PImage dinoRun1;
PImage dinoRun2;
PImage dinoJump;
PImage dinoDuck;
PImage dinoDuck1;
PImage smallCactus;
PImage bigCactus;
PImage manySmallCactus;
PImage bird;
PImage bird1;
//////////////////////////////////////////////////////////////////////////////////////
ArrayList<Obstacle> obstaculos = new ArrayList<Obstacle>();
ArrayList<Bird> pajaros = new ArrayList<Bird>();
ArrayList<Ground> tierras = new ArrayList<Ground>();
Poblacion poblacion = new Poblacion();

boolean terminado = false;

int ratioCrossOver = 80;         //Sobre 100
int RangoMutacion = 5;

int obstacleTimer = 0;
int minTimeBetObs = 60;
int randomAddition = 0;
int groundCounter = 0;
float speed = 10;
float genDistancia = 50;

int groundHeight = 50;
int playerXpos = 100;
int highScore = 0;
void setup(){
  size(800, 400); //Se definen las dimensiones de la ventana
  frameRate(60);  //La tasa de refresco de los cuadros del GUI
  //Carga los sprite de los elementos del juego
  dinoRun1 = loadImage("dinorun0000.png");
  dinoRun2 = loadImage("dinorun0001.png");
  dinoJump = loadImage("dinoJump0000.png");
  dinoDuck = loadImage("dinoduck0000.png");
  dinoDuck1 = loadImage("dinoduck0001.png");
  smallCactus = loadImage("cactusSmall0000.png");
  bigCactus = loadImage("cactusBig0000.png");
  manySmallCactus = loadImage("cactusSmallMany0000.png");
  bird = loadImage("berd.png");
  bird1 = loadImage("berd2.png");
}

void draw() {
  background(250); //Define el color blanco del fondo
  stroke(0);
  strokeWeight(2);
  line(0, height - groundHeight - 30, width, height - groundHeight - 30);
  //Actualiza los obstaculos 
  updateObstacles();
  //Actualiza la puntuacions de los dinosaurios
  for(int i = 0 ; i < poblacion.jugadores.size() ; i++) {
    Player dino = poblacion.jugadores.get(i);
    if(dino.score > highScore){
      highScore = dino.score;
    }
  } 
  int score = 0;
  for(int i = 0 ; i < poblacion.jugadores.size() ; i++) {
    Player dino = poblacion.jugadores.get(i);
    if(!dino.dead){
      score = dino.score;
    }
  }
  //Imprime en la pantalla la puntuacion y los controles  
  textSize(20);
  fill(0);
  text("Score: " + score, 5, 20);
  text("High Score: " + highScore, width - (140 + (str(highScore).length() * 10)), 20);
  text("Rango de mutacion: " + RangoMutacion, 5, 40);
  text("+ Para aumentar. - Para decrementar", 5, 60);
  text("CrossOver: " + ratioCrossOver, 5, 80);
  text("c Para aumentar. d Para decrementar", 5, 100);
}

void updateObstacles() {
  showObstacles();
  
  for(int i = 0 ; i < poblacion.jugadores.size() ; i++) {
    Player dino = poblacion.jugadores.get(i);
    
    Bird aveMasCercana = new Bird(0);
    Obstacle obstaculoMasCercano = new Obstacle(0);
    
    if(pajaros.size() != 0) {
      aveMasCercana = pajaros.get(0);
    }
    
    if(obstaculos.size() != 0) {
      obstaculoMasCercano = obstaculos.get(0);
    }
    
    if(pajaros.size() != 0) {
      if(aveMasCercana.posY > 100) {                                                               //Ave alta
        if(aveMasCercana.posX < float(dino.adn.Cadena.get(0).contenido)*genDistancia) {
          dino.accion(dino.adn.Cadena.get(1).contenido);
        }
      } else {                                                                                     //Ave baja
        if(aveMasCercana.posX < float(dino.adn.Cadena.get(2).contenido)*genDistancia) {
          dino.accion(dino.adn.Cadena.get(3).contenido);
        }
      }
      
    } 
    
    if(obstaculos.size() != 0) {
      if(obstaculoMasCercano.type == 1) {                                                          //Cactus grande
        if(obstaculoMasCercano.posX < float(dino.adn.Cadena.get(4).contenido)*genDistancia) {
          dino.accion(dino.adn.Cadena.get(5).contenido);
        }
      } else if(obstaculoMasCercano.type == 0) {                                                   //Cactus pequeño
        if(obstaculoMasCercano.posX < float(dino.adn.Cadena.get(6).contenido)*genDistancia) {
          dino.accion(dino.adn.Cadena.get(7).contenido);
        }
      } else {                                                                                     //Grupo de cactus
        if(obstaculoMasCercano.posX < float(dino.adn.Cadena.get(8).contenido)*genDistancia) {
          dino.accion(dino.adn.Cadena.get(9).contenido);
        }
      }
    }
    
    dino.show();
  
  
    if(!dino.dead) {
      dino.update();
    }
  }
  
  obstacleTimer++;
  speed += 0.002;
    
  if(obstacleTimer > minTimeBetObs + randomAddition) {
    addObstacle();
  }
    
  groundCounter++;
    
  if(groundCounter > 10) {
    groundCounter = 0;
    tierras.add(new Ground());
  }
    
  moveObstacles();
    
  boolean vivos = false;
  
  for(int i = 0 ; i < poblacion.largo ; i++) {
    if(!poblacion.jugadores.get(i).dead) {
      vivos = true;
    }
  }
  
  if(!vivos) {
    reset();
  }
}

void showObstacles(){
  for(int i = 0; i < tierras.size(); i++) {
    tierras.get(i).show();
  }
  
  for(int i = 0; i < obstaculos.size(); i++) {
    obstaculos.get(i).show();
  }
  
  for(int i = 0; i < pajaros.size(); i++) {
    pajaros.get(i).show();
  }
}

void addObstacle(){
  if(random(1) < 0.15){
    pajaros.add(new Bird(floor(random(3))));
  }
  else{
    obstaculos.add(new Obstacle(floor(random(3))));
  }
  randomAddition = floor(random(50));
  obstacleTimer = 0;
}

void moveObstacles(){
  for(int i = 0; i < tierras.size(); i++) {
    tierras.get(i).move(speed);
    if(tierras.get(i).posX < -playerXpos) {
      tierras.remove(i);
      i--;
    }
  }
  
  for(int i = 0; i < obstaculos.size(); i++) {
    obstaculos.get(i).move(speed);
    if(obstaculos.get(i).posX < -playerXpos) {
      obstaculos.remove(i);
      i--;
    }
  }
  
  for(int i = 0; i < pajaros.size(); i++) {
    pajaros.get(i).move(speed);
    if(pajaros.get(i).posX < -playerXpos) {
      pajaros.remove(i);
      i--;
    }
  }
}

void reset(){
  poblacion.NuevaGeneracion();
  obstaculos = new ArrayList<Obstacle>();
  pajaros = new ArrayList<Bird>();
  tierras = new ArrayList<Ground>();
  
  obstacleTimer = 0;
  randomAddition = floor(random(50));
  groundCounter = 0;
  speed = 10;
}

void keyPressed(){
  switch(key){
    case '+': RangoMutacion++;
              break;
    case '-': RangoMutacion--;
              break;
    case 'c': ratioCrossOver++;
              break;
    case 'd': ratioCrossOver--;
              break;
  }
}
