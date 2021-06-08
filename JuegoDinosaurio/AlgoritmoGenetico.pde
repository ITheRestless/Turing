
/*----------------------------------------------- Clase Gen -------------------------------------------------*/

class Gen {
  int contenido;
  
  Gen(int v) {
    contenido = v;
  }
  
  public void Mutar() {
    print("Mutado: " + contenido);
    contenido += random(-RangoMutacion, RangoMutacion);
    print(" a " + contenido + " - ");
    
    if(contenido < 0) {
      contenido = 0;
    } else if(contenido > 100) {
      contenido = 100;
    }
  }
}
/*-------------------------------------------- Clase Cromosoma ----------------------------------------------*/

/*
    Cada gen del cromosoma representa un "Gatillo" por decirlo de una forma, 
    estos povocan que se hagan ciertas acciones en diferentes situaciones 
    dependiendo de la situacion actual del juego, por lo que se podria decir 
    que en conjunto forman un patron de comportamiento
*/
class Cromosoma {
  ArrayList<Gen> Cadena = new ArrayList<Gen>();
  int largo = 10;
  
  Cromosoma() {
    
    for(int i = 0 ; i < largo ; i++) {
      Cadena.add(new Gen(0));
    }
  }
  
  Cromosoma(Cromosoma c) {
    for(int i = 0 ; i < largo ; i++) {
      Cadena.add(c.Cadena.get(i));
    }
  }
}

/*-------------------------------------------- Clase Poblacion ----------------------------------------------*/

class Poblacion {

  int largo = 10;                  //Tamaño de cromosoma
  int individuos = 10;             //Tamaño de la poblacion
  int[] elites = new int[2];       //Cantidad de individuos sorevivientes
  
  ArrayList<Player> jugadores = new ArrayList<Player>();  //Lista con la poblacion
  ArrayList<Player> elite = new ArrayList<Player>();      //Lista con los sucesores
  
  Poblacion() {
    for(int i = 0 ; i < individuos ; i ++) {
      jugadores.add(new Player());
    }
    
    for(int  i = 0 ; i < elites.length ; i++) {
      elites[i] = i;
    }
  }
  
  Cromosoma Crossover(Cromosoma padre1, Cromosoma padre2) {
      Cromosoma hijo = new Cromosoma();
      
      for(int i = 0 ; i < largo ; i++) {
        if(random(0, 1) == 0)
          hijo.Cadena.get(i).contenido = padre1.Cadena.get(i).contenido;
        else
          hijo.Cadena.get(i).contenido = padre2.Cadena.get(i).contenido;
      }
      
      return hijo;
  }
  
  void NuevaGeneracion() {
    /* ----------------------------------------------------------------- Mostrar generacion anterior --------------------------------------------------------------------*/
    
    for(int i = 0 ; i < poblacion.jugadores.size() ; i++) {
      println("");
      Player dino = poblacion.jugadores.get(i);
        print(" - ");
      for(int j = 0; j < poblacion.largo ; j++) {
        print(dino.adn.Cadena.get(j).contenido);
        print(" - ");
      }
      
      print("Puntuacion" + dino.score);
    }
    
    println("");
    
    /* ----------------------------------------------------------------- Determinar existencia de elite --------------------------------------------------------------------*/
    
    int mejor = poblacion.jugadores.get(0).score;
    boolean sinElite = true;
    
    for(int i = 0 ; i < 10 ; i++) {
      if(mejor != poblacion.jugadores.get(i).score) {
          sinElite = false;
      }
    }
    
    /* ----------------------------------------------------------------- Existe elite -------------------------------------------------------------------------*/
    if(!sinElite) {
    
      /* ------------------------------------------------------- Encontrar elite (2 individuos) ---------------------------------------------------------------*/
      elite = new ArrayList<Player>();
      
      for(int i = 0 ; i < individuos ; i++) {
        if(jugadores.get(i).lifespan > jugadores.get(elites[0]).lifespan) {
          elites[1] = elites[0];
          elites[0] = i;
        } else if(jugadores.get(i).lifespan > jugadores.get(elites[1]).lifespan) {
          elites[1] = i;
        }
      }
      
      /* ----------------------------------------------------------------- Mostrar elite --------------------------------------------------------------------*/
      
      println("ELITES");
      for(int i = 0 ; i < 2 ; i++) {
        println("");
        Player dino = poblacion.jugadores.get(elites[i]);
          print(" - ");
        for(int j = 0; j < poblacion.largo ; j++) {
          print(dino.adn.Cadena.get(j).contenido);
          print(" - ");
        }
        
        print("Puntuacion" + dino.score);
      }
      
      /* ----------------------------------------------------------------- Almacena elite --------------------------------------------------------------------*/
      
      for(int i = 0 ; i < elites.length ; i++) {
        elite.add(new Player(jugadores.get(elites[i]).adn));
      }
      
      if(random(0, 100) <= ratioCrossOver) {
        
        /* ---------------------- ---------------------------------------- Hace CrossOver ---------------------------------------------------------------------*/
        println("CROSSOVER");
        
        for(int i = 0 ; i < largo ; i++) {
          jugadores.get(i).adn = Crossover(elite.get(0).adn, elite.get(1).adn);
        }
        
      } else {
        /* ---------------------------------------------------------- copia la elite almacenada ------------------------------------------------------------------*/
        println("");
        println("SOLO MUTACION");
        
        for(int i = 0 ; i < largo/2 ; i++) {
          jugadores.get(i).adn = new Cromosoma(elite.get(0).adn);
        }
        
        for(int i = 0 ; i < largo/2 ; i++) {
          jugadores.get(i).adn = new Cromosoma(elite.get(1).adn);
        }
      }
      
      for(int i = 0 ; i < 10 ; i++ ) {
        for(int j = 0 ; j < 10 ; j++) {
          jugadores.get(i).adn.Cadena.get(j).Mutar();
        }
        
        jugadores.get(i).score = 0;
        jugadores.get(i).lifespan = 0;
        jugadores.get(i).score = 0;
        jugadores.get(i).contadorDuck = 0;
        jugadores.get(i).dead = false;
      }
      
      jugadores.get(0).adn = new Cromosoma(elite.get(0).adn);
      jugadores.get(1).adn = new Cromosoma(elite.get(0).adn);
    
    }
    /* ----------------------------------------------------------------- No existe elite --------------------------------------------------------------------*/
    
    for(int i = 0 ; i < 10 ; i++ ) {
      for(int j = 0 ; j < 10 ; j++) {
        jugadores.get(i).adn.Cadena.get(j).Mutar();
        
      }
      println("");
      
      jugadores.get(i).score = 0;
      jugadores.get(i).lifespan = 0;
      jugadores.get(i).score = 0;
      jugadores.get(i).contadorDuck = 0;
      jugadores.get(i).dead = false;
    }
  }
}
