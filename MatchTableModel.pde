public class MatchTableModel extends AbstractTableModel {
    
    protected ArrayList<MatchModel> matchs;
  
    protected String[] columnNames = new String[] { 
      "Afficher ?",
      "Equipe Domicile", 
      "Score Dom",
      "Score Ext",
      "Equipe Extérieur", 
      "Date", 
      "Heure", 
      "Salle",
      "Rue",
      "Ville"
    };
    
    protected Class[] columnClasses = new Class[] { 
      Boolean.class,   // toBedisplayed
      String.class,    // homeTeam
      Integer.class,   // homeScore
      Integer.class,   // awayScore
      String.class,    // awayTeam
      String.class,    // dateStr
      String.class,    // hourStr
      String.class,    // hallName
      String.class,    // street
      String.class     // city
    };
    
    public MatchTableModel() {
      matchs = new ArrayList<MatchModel>();
    }
    
    public void parseCsvFile(String csvFile) {
      Table table = loadTable(csvFile, "header");
      // get week and year from the first row in file
      String semaine[] = table.getString(0, "semaine").split("-");
      week = int(semaine[1]);
      year = int(semaine[0]);
      
      for (TableRow row : table.rows()) {
        matchs.add(new MatchModel(row));
      }
      fireTableDataChanged();
    }
    
    public void addMatchFromUrl(String url) {
      matchs.add(new MatchModel(url));
      fireTableDataChanged();
    }
    
    
    public String getColumnName(int col) { return columnNames[col]; } 
    public Class getColumnClass(int col) { return columnClasses[col]; }
    public int getColumnCount() { return columnNames.length; } // A constant for this model 
    public int getRowCount() { return matchs.size(); }
    
    // The method that must actually return the value of each cell
    @Override
    public Object getValueAt(int row, int col) { 
      MatchModel m = matchs.get(row); 
      switch(col) { 
        case 0: return m.toBeDisplayed? Boolean.TRUE : Boolean.FALSE; 
        case 1: return m.homeTeam; 
        case 2: return m.homeScore; 
        case 3: return m.awayScore; 
        case 4: return m.awayTeam; 
        case 5: return m.dateStr;
        case 6: return m.hourStr;
        case 7: return m.hallName;
        case 8: return m.street;
        case 9: return m.city;
        default: return null;
      }
    }
    
    @Override
    public void setValueAt(Object val, int row, int col) {
      MatchModel m = matchs.get(row);
      switch(col) { 
        case 0: m.toBeDisplayed = (boolean)val; break;
        case 1: m.setHomeTeam((String)val); break;
        case 2: m.homeScore = (Integer)val; break;
        case 3: m.awayScore = (Integer)val; break;
        case 4: m.setAwayTeam((String)val); break;
        case 5: m.dateStr = (String)val; break;
        case 6: m.hourStr = (String)val; break;
        case 7: m.hallName = (String)val; break;
        case 8: m.street = (String)val; break;
        case 9: m.city = (String)val; break;
        default: break;
      }
      fireTableDataChanged();
    }
    
    public MatchModel getMatch(int row) {
      if(row < 0 || row >= matchs.size()) 
        return null;
      return matchs.get(row);
    }
    
    public void removeRow(int row) {
      if(row>= 0 && row < matchs.size())
        matchs.remove(row);
    }
    
    @Override
    public boolean isCellEditable(int row, int col)
    {
        return true;
    }
    
    @Override
    public String toString() {
      String str = "";
      for(MatchModel m : matchs) {
        str += m + "\n";
      }
      return str;
    }
}
