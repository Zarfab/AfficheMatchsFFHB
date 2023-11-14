import javax.swing.*;
import javax.swing.table.*;
import javax.swing.SwingUtilities;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.awt.*;
import java.awt.event.*;

public class SettingsFrame extends JFrame implements ActionListener {
  
  private MatchTableModel model;
  private JTable table;
  
  public SettingsFrame() {
    super("Paramètres");
  }
  
  public SettingsFrame(MatchTableModel inputModel) {
    super("Paramètres");
    model = inputModel;
  }
  
  public void showMatchTable() {
   
    table = new JTable(model);
    table.setEnabled(Boolean.TRUE);
    table.setFillsViewportHeight(true);
    table.putClientProperty("terminateEditOnFocusLost", Boolean.TRUE);
    //table.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);

    JPanel panel = new JPanel(new BorderLayout());
    
    JButton addFromCsv = new JButton("Ajouter CSV");
    addFromCsv.setEnabled(true);
    addFromCsv.addActionListener(this);
    
    JButton addFromUrl = new JButton("Ajouter URL");
    addFromUrl.setEnabled(true);
    addFromUrl.addActionListener(this);
    
    JButton saveCsv = new JButton("Enregistrer le tableau");
    saveCsv.addActionListener(this);
    
    JButton invertSelectionBut = new JButton("Inverser la selection");
    invertSelectionBut.addActionListener(this);
    JButton nextSponsorsBut = new JButton("Sponsors suivants");
    nextSponsorsBut.addActionListener(this);
    
    JButton removeRow = new JButton("Supprimer la ligne");
    removeRow.setEnabled(true);
    removeRow.addActionListener(this);
    
    JButton delTable = new JButton("Supprimer tout");
    delTable.addActionListener(this);
    
    JButton modeBut = new JButton("Mode");
    modeBut.addActionListener(this);
    
    JButton saveBut = new JButton("Sauvegarder image");
    saveBut.addActionListener(this);
    
    JButton exitBut = new JButton("<html><font color=red>Quitter");
    exitBut.addActionListener(this);

    JPanel leftPanel = new JPanel(new GridLayout(0, 1, 20, 10));
    leftPanel.add(new JLabel());
    leftPanel.add(addFromCsv);
    leftPanel.add(addFromUrl);
    
    leftPanel.add(new JLabel());
    leftPanel.add(saveCsv);
    
    leftPanel.add(new JLabel());
    leftPanel.add(invertSelectionBut);
    leftPanel.add(nextSponsorsBut);
    
    leftPanel.add(new JLabel());
    leftPanel.add(removeRow);
    leftPanel.add(delTable);
    leftPanel.add(new JLabel());
    
    JPanel bottomPanel = new JPanel(new GridLayout(1, 4, 40, 10));
    bottomPanel.add(new JLabel());
    bottomPanel.add(modeBut);
    bottomPanel.add(saveBut);
    bottomPanel.add(exitBut);

    panel.add(new JScrollPane(table, JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED, JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED), BorderLayout.CENTER);
    panel.add(leftPanel, BorderLayout.WEST);
    panel.add(bottomPanel, BorderLayout.SOUTH);
    
    getContentPane().add(panel, "Center"); 
    setSize(1200, 400); 
    setResizable(true);
    setVisible(true); 
    setDefaultCloseOperation(JFrame. DO_NOTHING_ON_CLOSE);

    return;
  }
  
   public void actionPerformed(ActionEvent e) {
        String cmd = e.getActionCommand();
        switch(cmd) {
          case "Ajouter CSV":
            File csvFile = booster.showFileSelectionFromPath(sketchPath(), "*.csv", "csv");
            if(csvFile != null) {
              csvFilePath = csvFile.getAbsolutePath();
              csvFileFolder = csvFilePath.substring(0, csvFilePath.lastIndexOf('\\') + 1);
              //println("Fichier selectionne: " + csvFilePath);
              // modify a bit the original file so that it can be handled in loadTable
              String csvFileContent[] = loadStrings(csvFilePath);
              for(int i = 0; i < csvFileContent.length; i++) {
                csvFileContent[i] = csvFileContent[i].replaceAll(";", ",");
                csvFileContent[i] = csvFileContent[i].replaceAll("\"", "");
              }
              saveStrings("data/temp.csv", csvFileContent);
              loadPoolToTeam();
              model.parseCsvFile("temp.csv");
              model.fireTableDataChanged();
            }
            break;
          case "Ajouter URL": 
            String url = booster.showTextInputDialog("Copier / Coller l'URL du match ici");
            model.addMatchFromUrl(url);
            model.fireTableDataChanged();
            break;
          case "Enregistrer le tableau":
            File file = booster.showFileSelection();
            String filePath = file.getAbsolutePath();
            if(!filePath.endsWith(".csv")) {
              filePath += ".csv";
            }
            model.saveTableAsCsv(filePath);
            booster.showInfoDialog("Le tableau a été sauvegardé sous\n" + filePath);
            break;
          case "Inverser la selection":
            model.invertDisplaySelection();
            break;
          case "Sponsors suivants":
            sponsorIndex++;
            if(sponsorIndex >= sponsors.size())
              sponsorIndex = 0;
            break;
          case "Supprimer la ligne": 
            model.removeRow(table.getSelectedRow());
            model.fireTableDataChanged();
            break;
          case "Supprimer tout":
              booster.showConfirmDialog(
                "Voulez-vous vraiment effacer toute la table ?",
                "Supprimer tout",
                new Runnable() {
                    public void run() {
                       model.clear();
                       model.fireTableDataChanged();
                    }
                },
                new Runnable() {
                    public void run() {
                        ;
                    }
                }
            );
            break;
          case "Mode":
            mode = (mode == Mode.TO_BE_PLAYED? Mode.RESULTS : Mode.TO_BE_PLAYED);
            //println("new mode : " + mode);
            break;
          case "Sauvegarder image" : 
            File dir = booster.showDirectorySelection();
            if(dir != null) {
              String saveFileWithoutExt = dir.getAbsolutePath() + "/"
                                + clubNames.get(0) + "_"
                                + nf(year, 4) 
                                + "-" + nf(week, 2) 
                                + (mode == Mode.RESULTS ? "_resultats" : "");
                                
              String saveFile = saveFileWithoutExt + ".png";
              int it = 1;
              String saveFileIt = saveFile;
              File f = new File(saveFileIt);
              while(f.exists()) {
                saveFileIt = saveFileWithoutExt + "_" + it + ".png";
                f = new File(saveFileIt);
                it++;
              }
              getPoster().save(saveFileIt);
              booster.showInfoDialog("L'image a été sauvegardée \n" + saveFileIt);
            }
            break;
          case "<html><font color=red>Quitter" : 
            booster.showConfirmDialog(
                "Voulez-vous vraiment quitter le programme ?",
                "Quitter",
                new Runnable() {
                    public void run() {
                        exit();
                    }
                },
                new Runnable() {
                    public void run() {
                        ;
                    }
                }
            );
            break;
          default : println("command not set : " + cmd); break;
        }
   }
   
}
