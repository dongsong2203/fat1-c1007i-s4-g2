/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package dvd.behind.client;

import dvd.business.client.AlbumManager;
import dvd.entity.AlbumAllExtention;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.RequestScoped;

/**
 *
 * @author Administrator
 */
@ManagedBean
@RequestScoped
public class DefaultManagerBean {

    private List<AlbumAllExtention> listAlbum;
    private int pageIndex;
    private int totalRow;
    private int totalPaging;
    private int pageSize = 1;
    private boolean disableFirst;
    private boolean disableLast;
    private boolean disableNext;
    private boolean disablePrev;

    public DefaultManagerBean() {
    }

    public List<AlbumAllExtention> loadAlbum() {
        try {
            listAlbum = new ArrayList<AlbumAllExtention>();
            AlbumManager am = new AlbumManager();
            if (pageIndex <= 0) {
                pageIndex = 1;
            }
            ResultSet rs = am.listAllAlbum(pageIndex, pageSize);
            while (rs.next()) {
                AlbumAllExtention aae = new AlbumAllExtention();
                aae.setAlbumID(rs.getInt(1));
                aae.setAlbumName(rs.getString(2));
                aae.setAlbumPrice(rs.getDouble(3));
                aae.setAlbumImage(rs.getString(4));
                totalRow = rs.getInt(5);
                listAlbum.add(aae);
            }
            if (totalRow % pageSize > 0) {
                totalPaging = totalRow / pageSize + 1;
            } else {
                totalPaging = totalRow / pageSize;
            }
            if (pageIndex == 0 || pageIndex >= totalPaging) {
                disableLast = true;
            } else {
                disableLast = false;
            }
            if(totalPaging <= 1){
                disableNext = true;
                disablePrev = true;
                disableFirst = true;
            }
        } catch (SQLException ex) {
            Logger.getLogger(DefaultManagerBean.class.getName()).log(Level.SEVERE, null, ex);
        }
        return listAlbum;
    }

    public String btnNext() {
        if (totalRow - pageIndex * pageSize > 0) {
            pageIndex++;
        } else {
            pageIndex = 1;
        }
        if (pageIndex <= 1) {
            disableFirst = true;
        } else {
            disableFirst = false;
        }
        return "Default.xhtml";
    }

    public String btnPrevious() {
        if (pageIndex > 1) {
            pageIndex--;
        } else {
            pageIndex = totalPaging;
        }
        if (pageIndex <= 1) {
            disableFirst = true;
        } else {
            disableFirst = false;
        }
        return "Default.xhtml";
    }

    public String btnFirst() {
        pageIndex = 1;
        disableLast = false;
        disableFirst = true;
        return "Default.xhtml";
    }

    public String btnLast() {
        pageIndex = totalPaging;
        disableFirst = false;
        disableLast = true;
        return "Default.xhtml";
    }

    /**
     * @return the pageIndex
     */
    public int getpageIndex() {
        return getPageIndex();
    }

    /**
     * @param pageIndex the pageIndex to set
     */
    public void setpageIndex(int pageIndex) {
        this.setPageIndex(pageIndex);
    }

    /**
     * @return the pageIndex
     */
    public int getPageIndex() {
        return pageIndex;
    }

    /**
     * @param pageIndex the pageIndex to set
     */
    public void setPageIndex(int pageIndex) {
        this.pageIndex = pageIndex;
    }

    /**
     * @return the totalPaging
     */
    public int getTotalPaging() {
        return totalPaging;
    }

    /**
     * @param totalPaging the totalPaging to set
     */
    public void setTotalPaging(int totalPaging) {
        this.totalPaging = totalPaging;
    }

    /**
     * @return the DisableLast
     */
    public boolean getDisableLast() {
        return disableLast;
    }

    /**
     * @param DisableLast the DisableLast to set
     */
    public void setDisableLast(boolean DisableLast) {
        this.disableLast = DisableLast;
    }

    /**
     * @return the disableFirst
     */
    public boolean isDisableFirst() {
        return disableFirst;
    }

    /**
     * @param disableFirst the disableFirst to set
     */
    public void setDisableFirst(boolean disableFirst) {
        this.disableFirst = disableFirst;
    }

    /**
     * @return the disableNext
     */
    public boolean isDisableNext() {
        return disableNext;
    }

    /**
     * @param disableNext the disableNext to set
     */
    public void setDisableNext(boolean disableNext) {
        this.disableNext = disableNext;
    }

    /**
     * @return the disablePrev
     */
    public boolean isDisablePrev() {
        return disablePrev;
    }

    /**
     * @param disablePrev the disablePrev to set
     */
    public void setDisablePrev(boolean disablePrev) {
        this.disablePrev = disablePrev;
    }
}
