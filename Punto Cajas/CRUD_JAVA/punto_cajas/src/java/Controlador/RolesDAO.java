package Controlador;
import Modelo.Roles;
import java.sql.*;


public class RolesDAO {
    
    private Conexion conect = new Conexion();
    
    public Roles consultarRol(int id_rol){
    
    Roles miRol = null;
    
    Connection conn = conect.conn();
    
        try {
            String querySql = "SELECT id_rol, detalle_rol FROM roles WHERE id_rol = ?";
            
            PreparedStatement ps = conn.prepareStatement(querySql);
            
            ps.setInt(1, id_rol);
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                
                miRol = new Roles ();
                
                miRol.setIdRol(rs.getInt("id_rol"));
                miRol.setDetalleRol(rs.getString("detalle_rol"));
                
                
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return miRol;
    }
    
    public boolean insertarRol(Roles miRol){
    
        boolean insertar = false;
        
        Connection conn = conect.conn();
        
        try {
            String querySql = "INSERT INTO roles (detalle_rol) VALUES (?)";
            
            PreparedStatement ps = conn.prepareStatement(querySql);
            
            ps.setString(1, miRol.getDetalleRol());
            
            ps.executeUpdate();
            insertar = true;
            System.out.println("Rol registrado exitosamente.");
        } catch (Exception e) {
            System.out.println("Error al insertar Rol: " + e.getMessage());
        }
            return insertar;
    }
    
}
