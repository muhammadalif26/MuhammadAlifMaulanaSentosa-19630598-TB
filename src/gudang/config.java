/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package gudang;
import java.sql.Driver;       
import java.sql.DriverManager;  
import java.sql.Connection;    
import java.sql.SQLException;  
import java.sql.Statement;   
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableColumn;

import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.design.JRDesignQuery;
import net.sf.jasperreports.engine.design.JasperDesign;
import net.sf.jasperreports.engine.xml.JRXmlLoader;
import net.sf.jasperreports.view.JasperViewer;
import java.io.File;
import java.text.SimpleDateFormat;
import javax.swing.JOptionPane;
/**
 *
 * @author Windows 8.1
 */
public class config {
    private String url = "jdbc:mysql://localhost:3306/db_gudang_1";
    private String user = "root";
    private String pass = "";
    
    public Connection koneksiDatabase;
    
    public config(){}
    
    // Mathod dengan jenis Funcion
    public Connection getKoneksiDB() throws SQLException{
        try {
            Driver driverku = new com.mysql.jdbc.Driver();
            DriverManager.registerDriver(driverku);
            System.out.println("Berhasil di Koneksikan");
        } catch (Exception e){
                System.out.println(e.toString());
        }
        return DriverManager.getConnection(url, user, pass);
    }
    public void setJudulTabel(JTable Tabelnya, String[] Kolomnya){
      try {
          DefaultTableModel modelnya = new DefaultTableModel();
          Tabelnya.setModel(modelnya);
           for (int i = 0; i < Kolomnya.length; i++) {
              modelnya.addColumn(Kolomnya[i]);
          }  
      } catch (Exception e) {
          System.err.println(e.toString());
      }
  }
    public void setLebarKolomTabel(JTable Tabelnya, int[] Kolomnya){
      try {
        TableColumn kolom = new TableColumn();
        Tabelnya.setAutoResizeMode(javax.swing.JTable.AUTO_RESIZE_OFF);
          for (int i = 0; i < Kolomnya.length; i++) {
            kolom = Tabelnya.getColumnModel().getColumn(i);
            kolom.setPreferredWidth(Kolomnya[i]);
          }
      } catch (Exception e) {
          System.err.println(e.toString());
      }
  }
    public Object[][] DataTabel(String SQL,int JumlahKolom){
      Object[][] data = null;
      try {
          Statement  perintah = getKoneksiDB().createStatement();
          ResultSet  dataset = perintah.executeQuery(SQL);
          dataset.last(); // kita mengecek kondisi baris terakhir untuk bantuan perulangan
          int baris = dataset.getRow();
          dataset.beforeFirst();
          int j =0;
          data = new Object[baris][JumlahKolom];
          while(dataset.next()){
              for (int i = 0; i < JumlahKolom; i++) {
                  data[j][i]= dataset.getString(i+1);
              }
              j++;
          }        
      } catch (Exception e) {
          System.err.println(e.toString());
      } 
      return data;    
  }
    public void tampilTabel(JTable Tabelnya,String[] judul, String sql){    
      try {
        String[] title = judul;
        int jum = judul.length;
        Tabelnya.setModel(new DefaultTableModel(DataTabel(sql, jum), title));
      } catch (Exception e) {
          System.out.println(e.toString());
      }     
  }
    public boolean DuplikasiPrimeryKey (String Tabelnya,String Primarinya,String Isinya){
        boolean hasil = false;
        try{
        String SQLCari ="SELECT*FROM "+Tabelnya+" Where "+Primarinya+" = '"+Isinya+"'";
        Statement perintah = getKoneksiDB().createStatement();
        ResultSet dataset = perintah.executeQuery(SQLCari); 
        if (dataset.next()){
            hasil = true;
        }else {hasil = false;}
        perintah.close();
        dataset.close();
        getKoneksiDB().close();
    }   catch (Exception e){
            System.out.println(e.toString());
    }
    return hasil;
    }
    public String getFieldArray(String[] Fieldnya){
        String hasil = "";
        int deteksi = Fieldnya.length-1;
        try {
            for (int i = 0; i < Fieldnya.length; i++) {
                if (i == deteksi){
                     hasil = hasil +Fieldnya[i];
                } else {
                     hasil = hasil +Fieldnya[i]+",";  
                }           
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return "("+hasil+")";     
    }
    public String getValueArray(String[] Valuenya){
      String hasil = "";
      int deteksi = Valuenya.length - 1;
      try {
                for (int i = 0; i < Valuenya.length; i++) {

                if (i == deteksi) {
                    hasil = hasil +"'"+Valuenya[i]+"'";
                }else{
                    hasil = hasil +"'"+Valuenya[i]+"',";
                }
               }
      } catch (Exception e) {
          System.out.println(e.toString());
      }   
      return "("+hasil+")";     
    }
    public String getEditFieldValueArray(String[] Fieldnya, String[] Valuenya){
      String hasil = "";
      int deteksi = Fieldnya.length - 1;
      try {
          for (int i = 0; i < Fieldnya.length; i++) {
              if (i == deteksi){
                  hasil = hasil +Fieldnya[i]+"="+"'"+Valuenya[i]+"'";
              }else {
                  hasil = hasil + Fieldnya[i]+"='"+Valuenya[i]+"',";
              }
          }
      } catch (Exception e) {
          System.out.println(e.toString());
      }     
      return hasil; 
    }
      
    public void Simpan(String Tabelnya,String[] Fieldnya,String[] Valuenya){ 
          try {
              String SQLSave = "INSERT INTO "+Tabelnya+" "+getFieldArray(Fieldnya)+" VALUES "+getValueArray(Valuenya);
              Statement perintah = getKoneksiDB().createStatement();
              perintah.executeUpdate(SQLSave);
              perintah.close();
              getKoneksiDB().close();
          } catch (Exception e){
              System.out.println(e.toString());
          }
      }
    public void Hapus(String Tabelnya, String Primary, String value){
       try {
          String SQLDelete="DELETE FROM "+Tabelnya+" WHERE "+Primary+"='"+value+"'";
          Statement perintah = getKoneksiDB().createStatement();
          perintah.executeUpdate(SQLDelete);
          perintah.close();
          getKoneksiDB().close();
           System.out.println(Primary+"="+value+" Berhasil dihapus");
      } catch (Exception e) {
           System.out.println(e.toString());
      }
    }
    public void Ubah(String Tabelnya, String Primary, String isiPK, String[] Fieldnya, String[] Valuenya){
      try {
          String SQLEdit ="UPDATE "+Tabelnya+" SET "+getEditFieldValueArray(Fieldnya, Valuenya)+" WHERE "+Primary+"='"+isiPK+"'";
          Statement perintah = getKoneksiDB().createStatement();
          perintah.executeUpdate(SQLEdit);
          perintah.close();
          getKoneksiDB().close();
          System.out.println(Primary+"="+isiPK+" Berhasil diubah");
      } catch (Exception e) {
          System.out.println(e.toString());
      }
    }
    public void tampilLaporan(String laporanFile, String SQL){
    try {
            File file = new File(laporanFile);
            JasperDesign jasDes = JRXmlLoader.load(file);

            JRDesignQuery sqlQuery = new JRDesignQuery();
            sqlQuery.setText(SQL);
            jasDes.setQuery(sqlQuery);

             JasperReport JR = JasperCompileManager.compileReport(jasDes);
             JasperPrint JP = JasperFillManager.fillReport(JR,null,getKoneksiDB());
             JasperViewer.viewReport(JP,false);
    } catch (Exception e) {
      JOptionPane.showMessageDialog(null,e.toString());
      }
    }
    
}
