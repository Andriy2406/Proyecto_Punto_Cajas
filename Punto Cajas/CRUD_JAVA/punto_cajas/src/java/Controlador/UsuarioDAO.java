package Controlador;
import Modelo.Usuarios;
import java.sql.*;


public class UsuarioDAO {
    
    private Conexion conect = new Conexion();
    
    public Usuarios consultarUsuario(String correo){
    
    Usuarios miUsuario = null;
    
    Connection establecerConexion = conect.establecerConexion();
        try {
            String querySql = "SELECT id_usuario, nombre, apellido, identificacion_usuario, direccion, "
            + "telefono, correo, clave, fecha_de_nacimiento, fecha_de_vencimiento, autorizaciondatos, id_documento, id_rol FROM usuarios WHERE correo = ?";
            
            PreparedStatement ps = establecerConexion.prepareStatement(querySql);
            
            ps.setString(1, correo);
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                
                miUsuario = new Usuarios();
                miUsuario.setIdUsuario(rs.getInt("id_usuario"));
                miUsuario.setNombre(rs.getString("nombre"));
                miUsuario.setApellido(rs.getString("apellido"));
                miUsuario.setIdentificacionUsuario(rs.getString("identificacion_usuario"));
                miUsuario.setDireccion(rs.getString("direccion"));
                miUsuario.setTelefono(rs.getString("telefono"));
                miUsuario.setCorreo(rs.getString("correo"));
                miUsuario.setClave(rs.getString("clave"));
                java.sql.Date fechaNacSql = rs.getDate("fecha_de_nacimiento");
                if (fechaNacSql != null) {
                    miUsuario.setFechaDeNacimiento(fechaNacSql.toLocalDate());
                }
                java.sql.Date fechaVencSql = rs.getDate("fecha_de_vencimiento");
                if (fechaVencSql != null) {
                    miUsuario.setFechaDeVencimiento(fechaVencSql.toLocalDate());
                }
                miUsuario.setAutorizacionDatos(rs.getBoolean("autorizaciondatos"));
                miUsuario.setIdDocumento(rs.getInt("id_documento"));
                miUsuario.setIdRol(rs.getInt("id_rol"));
                
            }
        } catch (SQLException e) {
            
            System.out.println(e.getMessage());
        }
        return miUsuario;
    }
    
    public boolean insertarUsuario(Usuarios miUsuario){
    
        boolean insertar = false;
        
        Connection establecerConexion = conect.establecerConexion();
        
        try {
            String querySql = "INSERT INTO usuarios (nombre, apellido, identificacion_usuario, direccion, telefono, correo, "
                + "clave, fecha_de_nacimiento, fecha_de_vencimiento, autorizaciondatos, id_documento, id_rol) "
                + "VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
            
            PreparedStatement ps = establecerConexion.prepareStatement(querySql);
            
            ps.setString(1, miUsuario.getNombre());
            ps.setString(2, miUsuario.getApellido());
            ps.setString(3, miUsuario.getIdentificacionUsuario());
            ps.setString(4, miUsuario.getDireccion());
            ps.setString(5, miUsuario.getTelefono());
            ps.setString(6, miUsuario.getCorreo());
            ps.setString(7, miUsuario.getClave());
            
            if (miUsuario.getFechaDeNacimiento() != null) {
                ps.setDate(8, java.sql.Date.valueOf(miUsuario.getFechaDeNacimiento()));
            } else {
                ps.setNull(8, java.sql.Types.DATE);
            }

            if (miUsuario.getFechaDeVencimiento() != null) {
                ps.setDate(9, java.sql.Date.valueOf(miUsuario.getFechaDeVencimiento()));
            } else {
                ps.setNull(9, java.sql.Types.DATE);
            }

            ps.setBoolean(10, miUsuario.isAutorizacionDatos());
            ps.setInt(11, miUsuario.getIdDocumento());
            ps.setInt(12, miUsuario.getIdRol());

            ps.executeUpdate();
            insertar = true;
            System.out.println("Usuario registrado exitosamente.");
            
        } catch (Exception e) {
            System.out.println("Eror al insertar Usuario: " + e.getMessage());
        }
            return insertar;
    
    
    }
    
    
    
    
}
