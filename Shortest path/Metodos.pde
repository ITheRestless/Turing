void TrazarCamino() {
  ox = player.posX;
  oy = player.posY;
  dx = obj.posX;
  dy = obj.posY;

  //Distancias que se desplazan en cada eje
  float dY = (dy - oy);
  float dX = (dx - ox);
     
  //Incrementos para las secciones con avance inclinado
  if (dY >= 0) {
    IncYi = 1;
  } else {
    dY = -dY;
    IncYi = -1;
  }

  if (dX >= 0) {
    IncXi = 1;
  } else {
    dX = -dX;
    IncXi = -1;
  }

  //Incrementos para las secciones con avance recto:
  if (dX >= dY) {
    IncYr = 0;
    IncXr = IncXi;
  } else {
    IncXr = 0;
    IncYr = IncYi;
    float k = dX; 
    dX = dY; 
    dY = k;
  }
      
  //Inicializar valores
  X = player.posX; 
  Y = player.posY;
  avR = (2 * dY);
  av = (avR - dX);
  avI = (av - dX);
}

void avanzar() {
  player.mover(X, Y);
  if (av >= 0) {
    X = (X + IncXi);     // X aumenta en inclinado.
    Y = (Y + IncYi);     // Y aumenta en inclinado.
    av = (av + avI);     // Avance Inclinado
  } else {
    X = (X + IncXr);     // X aumenta en recto.
    Y = (Y + IncYr);     // Y aumenta en recto.
    av = (av + avR);     // Avance Recto
  }
}


void dibujar() {
  
  textSize(14);
  text("X: " + player.posX + "    Y: " + player.posY, 25, 675);
  
  stroke(200, 200, 200);
  ellipse(player.posX, player.posY, 40, 40);
  ellipse(30, 590, 40, 40);text("      - Robot", 30, 598);
  
  stroke(210,255,210);
  fill(150, 255, 150);
  ellipse(25, 635, 10, 10); text("  - Objeto", 25, 640);
  
  //Dibujar objetos
  for(int i = 0; i < 9 ; i++) {
    if(objetos[i].activa) {
      stroke(210,255,210);
      fill(150, 255, 150);
      ellipse(objetos[i].posX, objetos[i].posY, 10, 10);
      image(m,objetos[i].posX-20, objetos[i].posY-20, 50, 50);
    }
  }
  
  rect(objetos[9].posX - 15, objetos[9].posY - 15, 15, 15);
  image(bat,objetos[9].posX - 50, objetos[9].posY - 50, 120, 120 );
  
  textSize(18);
  fill(255 - int(255.0*(float(player.bateria)/float(recarga))), int(255.0*(float(player.bateria)/float(recarga))), 0);
  text("Bateria: " + player.bateria, 870, 690);
  
  fill(255, 255, 255);
  text("Estado: " + estados[player.estado], 670, 690);
  
  if(player.estado == 6) {
    image(img, - 150, 0);
    textSize(40);
    text("Presione X para reiniciar", 50, 100);
  }
}


public void TrazarRuta(Ruta lista, String disponibles, int bateria, int contador) {
  
  //Aumentar el numero de iteraciones y verificar que no pasa del limite
  iteraciones++;
  if(!(iteraciones > 2500)) {
    
    //Si quedan nodos que visitar
    if(contador > 0) {
      //Se inicializan las variables de control
      int r1 = 9, r2 = 9;
      double d1 = 10000, d2 = 10000;
  
      //Se buscan los nodos aun no visitados
      for(int i = 0 ; i < 9 ; i++) {
        //Si el costo(Distancia de este nodo es menor que el de el ultimo guardado, se alamcena en la variable r1 y el segundo se va a la r2
        if(char(i + 48) == disponibles.charAt(i)) {
          if(DistanciaPuntos(lista.ruta.get(lista.ruta.size() - 1).posX, lista.ruta.get(lista.ruta.size() - 1).posY, 
          objetos[i].posX, objetos[i].posY) < d1) {
            r2 = r1;
            r1 = i;
            d2 = d1;
            d1 = DistanciaPuntos(lista.ruta.get(lista.ruta.size() - 1).posX, lista.ruta.get(lista.ruta.size() - 1).posY, 
            objetos[i].posX, objetos[i].posY);
          }
        }
      }
  
      //Si no se puede visitar el nodo y despues ir por la bateria debido a la distancia y la carga
      if((bateria*1.1 - (d1 + DistanciaPuntos(objetos[r1].posX, objetos[r1].posY, objetos[9].posX, objetos[9].posY))) < 0 && contador > 1) {
        
        //Se crea una nueva ruta con lo que llevaba la anterior y se le suma la bateria
        Ruta a1 = new Ruta(lista.ruta);
        a1.ruta.add(objetos[9]);
        a1.costo = lista.costo + DistanciaPuntos(lista.ruta.get(lista.ruta.size() - 1).posX, lista.ruta.get(lista.ruta.size() - 1).posY, 
        objetos[9].posX, objetos[9].posY);
        
        //Se vuelve a llamar el metodo
        TrazarRuta(a1, disponibles, recarga, contador);
        
      //En caso contrario que si se pueda visitar
      } else {
        
        //Se hace lo mismo que en el anterior pero con el nodo mas cercano
        Ruta a1 = new Ruta(lista.ruta);
        a1.ruta.add(objetos[r1]);
        bateria -= d1;
        a1.costo = lista.costo + d1;
        
        //Se vuelve a llamar el metodo pero con el contador disminuido y se elimina el nodo visitado de la cadena con los disponibles
        TrazarRuta(a1, disponibles.replace(str(r1), "x"), bateria, contador - 1);
      }
  
      //Se hace lo mismo pero con el segundo nodo mas cercano
      if(r2 != 9) {
        if((bateria*1.1 - (d2 + DistanciaPuntos(objetos[r2].posX, objetos[r2].posY, objetos[9].posX, objetos[9].posY))) < 0 && contador > 1) {
          Ruta a2 = new Ruta(lista.ruta);
          a2.ruta.add(objetos[9]);
          a2.costo = lista.costo + DistanciaPuntos(lista.ruta.get(lista.ruta.size() - 1).posX, lista.ruta.get(lista.ruta.size() - 1).posY, 
          objetos[9].posX, objetos[9].posY);
          TrazarRuta(a2, disponibles, recarga, contador);
        } else {
          Ruta a2 = new Ruta(lista.ruta);
          a2.ruta.add(objetos[r2]);
          bateria -= d2;
          a2.costo = lista.costo + d2;
          TrazarRuta(a2, disponibles.replace(str(r2), "x"), bateria, contador - 1);
        }
      }
  
    //Si ya no quedan nodos que visitar
    } else {
      rutas.add(lista);
    }
  }
}


public double DistanciaPuntos(int x1, int y1, int x2, int y2) {
  return Math.sqrt((x1-x2)*(x1-x2) + (y1-y2)*(y1-y2));
}

//Se reinician la variables para volver a ejecutar
public void Reset() {
  
  player = new Robot();
  player.estado = 5;
  iteraciones = 0;
  masCorta = 0;
  cont = 0;
  
  objetos = new Objeto[10];
  rutas = new ArrayList<Ruta>();
  
  for(int i = 0; i < 10 ; i++) {
      objetos[i] = new Objeto();
  }
  
  img = loadImage("victory.jpg");
  
  objetos[9].bateria();
  objetos[9].posX = 900;
  objetos[9].posY = 600;
}

void keyPressed() {
  if (key == 'x')
  {
    Reset();
  }
}
