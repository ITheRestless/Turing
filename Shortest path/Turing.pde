Robot player;
Objeto obj;

String[] estados = {"ola", "Enrutando", "Recorriendo", "Recojiendo", "Cargando", "Calculando", "Exito"};

float ox, oy, dx, dy, dY, dX, IncYi, IncXi, IncXr, IncYr;
float avR, av, avI, X1, Y1, X, Y;

int recarga = 1200;
int masCorta = 0;
Ruta RMasCorta;
int cont = 0;
int iteraciones = 0;

Objeto[] objetos;
ArrayList<Ruta> rutas;

PImage img;
PImage bg;
PImage bat;
PImage m;

void setup(){
  size(1000, 700);
  bg = loadImage("bg.png");
  bat = loadImage("bat.png");
  m = loadImage("m.png");
  Reset();
}


void draw(){
  RutaCorta();
}

public void RutaCorta() {
  image(bg, 0,0, 1000,700);
  dibujar();
  
  //------------------------------------------------------------- Automata de estados ----------------------------------------------------------------------
  switch (player.estado) {
    //Trazando recorrido
    case 1: {
      
      if(cont < RMasCorta.ruta.size()) {
        obj = RMasCorta.ruta.get(cont);
        cont++;
      } else {
        player.estado = 6;
      }
      
      
      TrazarCamino();
      player.estado = 2;
      delay(200);
      break;
    }

    //Recorriendo
    case 2: {
      for(int i = 0 ; i < 3 ; i++) {
        if(X == dx && Y == dy) {
          player.estado = 3;
          break;
        }
        avanzar();
      }
      break;
    }

    //Recojiendo 
    case 3: {
      if(obj.bateria) {
        player.estado = 4;
      } else if(cont == RMasCorta.ruta.size()) {
        player.estado = 6;
      } else {
        obj.recojer();
        player.estado = 1;
      }
      
      break;
    }
    
    //Cargando
    case 4: {
      player.bateria = recarga;
      player.estado = 1;
      break;
    }

    //Calculando rutas
    case 5: {
      ArrayList<Objeto> ruta1 = new ArrayList<Objeto>();
      Objeto inicio = new Objeto(int(player.posX), int(player.posY));
      ruta1.add(inicio);
      Ruta rutaInicial = new Ruta(ruta1);
      TrazarRuta(rutaInicial, "012345678", recarga, 9);
      
      for(int i = 1 ; i < rutas.size() ; i++) {
        if(rutas.get(i).costo < rutas.get(masCorta).costo) {
          masCorta = i;
        }
      }

      RMasCorta = rutas.get(masCorta);
      
      print(RMasCorta.costo);
      
      for(int i = 0 ; i < RMasCorta.ruta.size(); i++) {
        print("-" + RMasCorta.ruta.get(i).posX + "," + RMasCorta.ruta.get(i).posY + "-       ");
      }
      
      print("Iteraciones: " + iteraciones);

      player.estado = 1;
      break;
    }
    
    //Exito
    case 6: {
      
    }
  }
  
  fill(255,255,255,255);
}
