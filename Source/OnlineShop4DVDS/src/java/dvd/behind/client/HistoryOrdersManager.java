/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package dvd.behind.client;

import dvd.business.client.OrderManager;
import dvd.entity.Order;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.SessionScoped;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Administrator
 */
@ManagedBean
@SessionScoped
public class HistoryOrdersManager {

    /**
     * Creates a new instance of HistoryOrdersManager
     */
    private int UserId = 1;
    HttpSession session = (HttpSession) FacesContext.getCurrentInstance().getExternalContext().getSession(false);
    private String message;
    private boolean displayMessage;
    private boolean typeMessage;
    
    public void resetMessage(){
        this.setMessage("");
        setDisplayMessage(false);
    }

    public HistoryOrdersManager() {
//        if (session.getAttribute("UserId") == null) {
//            UserId = 0;
//        }
    }

    public List<Order> listOrder() {
        List<Order> listO = null;
        try {
            OrderManager om = new OrderManager();
            listO = om.listOrder(UserId);
            for (Order order : listO) {
                order.setTotalMoney(order.getOrderID());
            }
        } catch (Exception e) {
        }
        return listO;
    }

    public String checkStatus(int _ID, int _Status) {
        if (_Status == 0) {
            return "<td class=\"HistoryOrdersTableTdStatus\"><a href=\"changeStatusOrder.xhtml?OrderId=" + _ID + "\" onclick=\"return confirm('Cancel order ID: " + _ID + " ?');\" style=\"background: none repeat scroll 0 0 yellow;color: green;cursor: pointer;padding: 1px 10px;text-align: center;\">Waiting</a></td>";
        } else if (_Status == 1) {
            return "<td class=\"HistoryOrdersTableTdStatus\"><span style=\"background: none repeat scroll 0 0 inactivecaption;color: green;padding: 1px 9px;text-align: center;\">Transportding</span></td>";
        } else if (_Status == 2) {
            return "<td class=\"HistoryOrdersTableTdStatus\"><span style=\"background: none repeat scroll 0 0 green;color: yellow;padding: 1px 9px;text-align: center;\">Done</span></td>";
        } else {
            return "<td class=\"HistoryOrdersTableTdStatus\"><span style=\"background: none repeat scroll 0 0 buttonface;color: red;padding: 1px 9px;text-align: center;\">Cancel</span></td>";
        }
    }

    public void changeStatus(int _ID) {
        try {
            OrderManager om = new OrderManager();
            if (om.changeStatus(_ID)) {
                this.setDisplayMessage(true);
                this.setTypeMessage(true);
                this.setMessage("Cancel order: " + _ID + " success!");
            } else {
                this.setDisplayMessage(true);
                this.setTypeMessage(false);
                this.setMessage("Cancel order: " + _ID + " false!");
            }
            FacesContext.getCurrentInstance().getExternalContext().redirect("HistoryOrders.xhtml");
        } catch (IOException ex) {
            Logger.getLogger(HistoryOrdersManager.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * @return the message
     */
    public String getMessage() {
        return message;
    }

    /**
     * @param message the message to set
     */
    public void setMessage(String message) {
        this.message = message;
    }

    /**
     * @return the displayMessage
     */
    public boolean isDisplayMessage() {
        return displayMessage;
    }

    /**
     * @param displayMessage the displayMessage to set
     */
    public void setDisplayMessage(boolean displayMessage) {
        this.displayMessage = displayMessage;
    }

    /**
     * @return the typeMessage
     */
    public boolean isTypeMessage() {
        return typeMessage;
    }

    /**
     * @param typeMessage the typeMessage to set
     */
    public void setTypeMessage(boolean typeMessage) {
        this.typeMessage = typeMessage;
    }
}