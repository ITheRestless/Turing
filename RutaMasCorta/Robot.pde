class Robot {
  float posX = 50;
  float posY = 50;
  int bateria = recarga;
  int estado;
  
  Robot() {
    
  }
  
  void mover(float mx, float my) {
    if(bateria > 0) {
      posX = mx;
      posY = my;
      bateria--;
    }
  }
}
