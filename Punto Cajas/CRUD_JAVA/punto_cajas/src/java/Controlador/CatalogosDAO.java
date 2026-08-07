package Controlador;
import Modelo.Catalogos;
import java.sql.*;


public class CatalogosDAO {
    
    private Conexion conect = new Conexion();
    
    public Catalogos consultarCatalogo(int id_catalogo){
    
    Catalogos miCatalogo = null;
    
    Connection conn = conect.conn();
    
        try {
            String querySql = "SELECT id_catalogo, stock_actual, url FROM catalogos WHERE id_catalogo = ?";
            
            PreparedStatement ps = conn.prepareStatement(querySql);
            
            ps.setInt(1, id_catalogo);
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                
                miCatalogo = new Catalogos();
                miCatalogo.setIdCatalogo(rs.getInt("id_catalogo"));
                miCatalogo.setStockActual(rs.getString("stock_actual"));
                miCatalogo.setUrl(rs.getString("url"));
                
            }
        } catch (SQLException e) {
            
            System.out.println(e.getMessage());
        }
        return miCatalogo;
    }
    
    public boolean insertarCatalogo(Catalogos miCatalogo){
    
        boolean insertar = false;
        
        Connection conn = conect.conn();
        
        try {
            String querySql = "INSERT INTO catalogos (stock_actual, url) VALUES (?,?)";
            
            PreparedStatement ps = conn.prepareStatement(querySql);
            
            ps.setString(1, miCatalogo.getStockActual());
            ps.setString(1, miCatalogo.getUrl());
            
            ps.executeUpdate();
            insertar = true;
            System.out.println("Catalogo registrado exitosamente");
        } catch (Exception e) {
            System.out.println("Error al insertar Catalogo: " + e.getMessage());
            
        }
        return insertar;
    }
    
}
