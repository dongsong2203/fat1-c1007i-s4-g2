/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package dvd.libraries;

import java.sql.DriverManager;
import javax.faces.context.FacesContext;

/**
 *
 * @author Administrator
 */
public class Connection {
    public Connection() {
    }

    public java.sql.Connection GetConnect() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            java.sql.Connection connection = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;databasename=SHOPDVDS;user=sa;password=!vh04782$");
            return connection;
        } catch (Exception e) {
            return null;
        }
    }
}