package mining;

import jason.environment.grid.Location;
import java.util.Random;
import java.util.logging.Logger;

public class GoldGenerator implements Runnable {

  WorldModel model;
  WorldView view;
  
  private Logger logger   = Logger.getLogger("jasonTeamSimLocal.mas2j." + WorldModel.class.getName());

  protected Random random = new Random();
  //tempo de geracao dos ouros
  private static final int SLEEP_TIME = 10000; 

  public GoldGenerator(WorldModel newModel, WorldView newView) {
    model = newModel;
    view = newView;
  }

  public void run() {
    while (!Thread.currentThread().isInterrupted()) {
      try {
        generateRandomGold();
        Thread.sleep(SLEEP_TIME);
      } catch (InterruptedException ex) {
        Thread.currentThread().interrupt();
      }
    }
  }

  public void generateRandomGold() {
    Location l = model.getFreePos();
    if( !model.hasObject(WorldModel.OBSTACLE, l.y, l.x) ) {	    
	    model.add(WorldModel.GOLD, l.y, l.x);
	    model.setInitialNbGolds(model.getInitialNbGolds()+1);		    
	    view.update(l.y, l.x);
	    view.udpateCollectedGolds();
	    logger.warning("Novo ouro em (" + l.x + "," + l.y + ")!");
    }    
  }
}