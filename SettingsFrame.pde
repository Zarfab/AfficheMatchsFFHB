import javax.swing.*;
import javax.swing.table.*;
import javax.swing.SwingUtilities;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.awt.*;
import  java.awt.event.*;

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

    JButton removeRow = new JButton("Supprimer");
    removeRow.setEnabled(true);
    removeRow.addActionListener(this);
    
    JButton modeBut = new JButton("Mode");
    modeBut.addActionListener(this);
    
    JButton saveBut = new JButton("Sauvegarder image");
    saveBut.addActionListener(this);
    
    JButton exitBut = new JButton("Quitter");
    exitBut.addActionListener(this);

    JPanel buttonPanel = new JPanel(new GridLayout(3, 3));
    buttonPanel.add(addFromCsv);
    buttonPanel.add(addFromUrl);
    buttonPanel.add(removeRow);
    buttonPanel.add(new JLabel());
    buttonPanel.add(new JLabel ());
    buttonPanel.add(new JLabel ());
    buttonPanel.add(modeBut);
    buttonPanel.add(saveBut);
    buttonPanel.add(exitBut);

    panel.add(new JScrollPane(table, JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED, JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED), BorderLayout.CENTER);
    panel.add(buttonPanel, BorderLayout.SOUTH);
    
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
              println("Fichier selectionne: " + csvFilePath);
              // modify a bit the original file so that it can be handled in loadTable
              String csvFileContent[] = loadStrings(csvFilePath);
              for(int i = 0; i < csvFileContent.length; i++) {
                csvFileContent[i] = csvFileContent[i].replaceAll(";", ",");
                csvFileContent[i] = csvFileContent[i].replaceAll("\"", "");
              }
              saveStrings("data/temp.csv", csvFileContent);
              model.parseCsvFile("temp.csv");
              model.fireTableDataChanged();
            }
            break;
          case "Ajouter URL": 
            String url = booster.showTextInputDialog("Copier / Coller l'URL du match ici");
            model.addMatchFromUrl(url);
            model.fireTableDataChanged();
            break;
          case "Supprimer": 
            model.removeRow(table.getSelectedRow());
            model.fireTableDataChanged();
            break;
          case "Mode":
            mode = (mode == Mode.TO_BE_PLAYED? Mode.RESULTS : Mode.TO_BE_PLAYED);
            //println("new mode : " + mode);
            break;
          case "Sauvegarder image" : 
            String saveFile = (csvFileFolder == null? "" : csvFileFolder) + nfs(year, 4) + "-" + nfs(week, 2) + ".png"; 
            booster.showInfoDialog("L'image a été sauvegardée \n" + saveFile);
            break;
          case "Quitter" : 
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