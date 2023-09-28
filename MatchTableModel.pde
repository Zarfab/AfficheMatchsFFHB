public class MatchTableModel extends AbstractTableModel {
    
    protected ArrayList<MatchModel> matchs;
  
    protected String[] columnNames = new String[] { 
      "Afficher ?",
      "A Domicile ?",
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
      Boolean.class,   // toBeDisplayed ?
      Boolean.class,   // atHome ?
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
    }
    
    public void addMatchFromUrl(String url) {
      MatchModel m = new MatchModel(url);
      matchs.add(m);
      if(week == 0) week = m.calendar().get(Calendar.WEEK_OF_YEAR);
      if(year == 0) year = m.calendar().get(Calendar.YEAR);
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
        case 1: return m.atHome? Boolean.TRUE : Boolean.FALSE;
        case 2: return m.homeTeam; 
        case 3: return m.homeScore; 
        case 4: return m.awayScore; 
        case 5: return m.awayTeam; 
        case 6: return m.dateStr;
        case 7: return m.hourStr;
        case 8: return m.hallName;
        case 9: return m.street;
        case 10: return m.city;
        default: return null;
      }
    }
    
    @Override
    public void setValueAt(Object val, int row, int col) {
      MatchModel m = matchs.get(row);
      switch(col) { 
        case 0: m.toBeDisplayed = (boolean)val; break;
        case 1: m.atHome = (boolean)val; break;
        case 2: m.setHomeTeam((String)val); break;
        case 3: m.homeScore = (Integer)val; break;
        case 4: m.awayScore = (Integer)val; break;
        case 5: m.setAwayTeam((String)val); break;
        case 6: m.setDateString((String)val); break;
        case 7: m.setHourString((String)val); break;
        case 8: m.hallName = (String)val; break;
        case 9: m.street = (String)val; break;
        case 10: m.city = (String)val; break;
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
