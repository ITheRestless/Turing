class Ruta {
  public ArrayList<Objeto> ruta;
  public double costo = 0;
  
  Ruta(ArrayList<Objeto> rutaX) {
    ruta = new ArrayList<Objeto>();
    ruta = concatenarLista(ruta, rutaX);
  }
}

public ArrayList<Objeto> concatenarLista(ArrayList<Objeto> lista1, ArrayList<Objeto> lista2) {
  ArrayList<Objeto> nuevaLista = new ArrayList<Objeto>();
  
  for(int i = 0 ; i < lista1.size() ; i++) {
      nuevaLista.add(lista1.get(i));
  }
  
  for(int i = 0 ; i < lista2.size() ; i++) {
      nuevaLista.add(lista2.get(i));
  }
  
  return nuevaLista;
}

public ArrayList<Ruta> concatenarRuta(ArrayList<Ruta> lista1, ArrayList<Ruta> lista2) {
  ArrayList<Ruta> nuevaLista = new ArrayList<Ruta>();
  
  for(int i = 0 ; i < lista1.size() ; i++) {
      nuevaLista.add(lista1.get(i));
  }
  
  for(int i = 0 ; i < lista2.size() ; i++) {
      nuevaLista.add(lista2.get(i));
  }
  
  return nuevaLista;
}
