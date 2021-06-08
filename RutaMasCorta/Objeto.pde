class Objeto {
  public int posX, posY;
  boolean activa = true;
  boolean bateria = false;
 
  Objeto() {
    posX = int(random(50, 900));
    posY = int(random(50, 650));
  }
  
  Objeto(int x, int y) {
    posX = x;
    posY = y;
  }
  
  public void bateria() {
    bateria = true;
  }
  
  public int getPox() {
    return posX;
  }
   
  public int getPoy() {
    return posY;
  }
 
  void recojer() {
    activa = false;
  }
}
