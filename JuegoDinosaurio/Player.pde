class Player{
  float posY = 0;
  float velY = 0;
  float gravity = 1.2;
  int size = 20;
  boolean duck = false;
  boolean dead = false;
  int runCount = -5;
  int contadorDuck = 0;
  int lifespan;
  int score;
  Cromosoma adn;
  Player() {
    adn = new Cromosoma();
  }
  Player(Cromosoma c) {
    adn = new Cromosoma(c);
  }
  void jump(){
    if(posY == 0){
      gravity = 1.2;
      velY = 16;
    }
  }
  void bigJump() {
    if(posY == 0){
      gravity = 1.2;
      velY = 22;
    }
  }
  void show() {
    if(!dead) {
      if(contadorDuck > 0) {
        duck = true;
        contadorDuck--;
      } else {
        duck = false;
      }
      
      if (duck && posY == 0) {
        if (runCount < 0) {
  
          image(dinoDuck, playerXpos - dinoDuck.width/2, height - groundHeight - (posY + dinoDuck.height));
        } else {
  
          image(dinoDuck1, playerXpos - dinoDuck1.width/2, height - groundHeight - (posY + dinoDuck1.height));
        }
      } else
        if (posY ==0) {
          if (runCount < 0) {
            image(dinoRun1, playerXpos - dinoRun1.width/2, height - groundHeight - (posY + dinoRun1.height));
          } else {
            image(dinoRun2, playerXpos - dinoRun2.width/2, height - groundHeight - (posY + dinoRun2.height));
          }
        } else {
          image(dinoJump, playerXpos - dinoJump.width/2, height - groundHeight - (posY + dinoJump.height));
        }
        
    runCount++;
    
    if(runCount > 5) {
      runCount = -5;
    }
  }
}
  
  void move() {
    posY += velY;
    if(posY > 0 ){
      velY -= gravity;
    }
    else {
      velY = 0;
      posY = 0;
    }
    
    for (int i = 0; i< obstaculos.size(); i++){
      if(dead) {
        if(obstaculos.get(i).collided(playerXpos, posY + dinoDuck.height / 2, dinoDuck.width * 0.5, dinoDuck.height)){
          dead = true;
        }
      }
      else {
        if(obstaculos.get(i).collided(playerXpos, posY + dinoRun1.height / 2, dinoRun1.width * 0.5, dinoRun1.height)){
          dead = true;
        }
      }
    }
    for (int i = 0; i< pajaros.size(); i++){
      if(duck && posY == 0){
        if(pajaros.get(i).collided(playerXpos, posY + dinoDuck.height / 2, dinoDuck.width * 0.5, dinoDuck.height)){
          dead = true;
        }
      }
      else{
        if(pajaros.get(i).collided(playerXpos, posY + dinoRun1.height / 2, dinoRun1.width * 0.5, dinoRun1.height)){
          dead = true;
        }
      }
    }
  }
  void ducking(boolean isDucking){
    if(posY != 0 && isDucking){
      gravity = 3;
    }
    duck = isDucking;
  }
  
  void update(){
   incrementCounter();
   move();
  }
  
  void incrementCounter(){
    lifespan++;
    if(lifespan % 3 == 0){
      score += 1;
    }
  }
  void accion(int a) {
    if(a > 66) {
      bigJump();
    } else if(a > 33) {
      jump();
    } else if(a > 0) {
      contadorDuck = 50;
    }
  }
}
