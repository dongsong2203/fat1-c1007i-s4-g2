/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package dvd.business.dashboard;

import dvd.libraries.HandlingBusiness;
import dvd.libraries.MapperData;
import java.util.List;

/**
 *
 * @author Administrator
 */
public class DataStore {

    private dvd.libraries.MapperData<dvd.entity.DataStore> mapperCommo;
    private dvd.libraries.HandlingBusiness maphand;
    private int[] paramnumber;
    private String[] paramvalues;

    public DataStore() {
        this.mapperCommo = new MapperData<dvd.entity.DataStore>();
    }

    public List<dvd.entity.DataStore> getListDataStoreWAlbum(String id) {
        this.paramvalues = new String[]{
            id
        };
        return this.mapperCommo.getDataWithProc("aShowDataStore", "?",
                paramvalues, dvd.entity.DataStore.class);
    }

    public List<dvd.entity.DataStore> getListAllDataStore() {
        this.paramvalues = new String[]{
            "1"
        };
        return this.mapperCommo.getDataWithProc("aShowAllDataStore", "?",
                paramvalues, dvd.entity.DataStore.class);
    }

    public List<dvd.entity.DataStore> getListAllDataWithAlbumCate(String id) {
        this.paramvalues = new String[]{
            id
        };
        return this.mapperCommo.getDataWithProc("aShowAllDataStoreFilter", "?",
                paramvalues, dvd.entity.DataStore.class);
    }

    public void MoveStoreToListAlbum(String id, String idalbum) {
        try {
            this.paramvalues = new String[]{
                idalbum,
                id
            };
            this.mapperCommo.getDataWithProc("aAddDataStoreToList", "?,?",
                    paramvalues, dvd.entity.DataStore.class);
        } catch (Exception e) {
        }
    }

    public void MoveListAlbumToStore(String id) {
        try {
            this.paramvalues = new String[]{
                id
            };
            this.mapperCommo.getDataWithProc("aAddListAlbumToStore", "?",
                    paramvalues, dvd.entity.DataStore.class);
        } catch (Exception e) {
        }
    }

    public Boolean CreateDataStore(dvd.entity.DataStore bs) {
        try {
            this.maphand = new HandlingBusiness();
            String albumlID = Integer.toString(bs.getAlbumID());
            this.paramvalues = new String[]{
                albumlID,
                bs.getAlbumName(),
                bs.getDataPath(),
                bs.getDataPublic() + "",
                bs.getDataImage()
            };
            return this.maphand.InsertToDB("aInserData",
                    "?,?,?,?,?",
                    paramvalues);
        } catch (Exception e) {
            return null;
        }
    }

    public Boolean UpdateUseGuest(String id) {
        try {
            this.maphand = new HandlingBusiness();
            this.paramvalues = new String[]{
                id
            };
            return this.maphand.UpdateToDB("aUpdateUseGuest", "?", paramvalues);
        } catch (Exception e) {
            return false;
        }
    }

    public List<dvd.entity.DataStore> getListEditData(String id) {
        try {
            this.paramvalues = new String[]{
                id
            };
            return this.mapperCommo.getDataWithProc("aGetdataEditData", "?", paramvalues, dvd.entity.DataStore.class);
        } catch (Exception e) {
            return null;
        }
    }

    public Boolean UpdateDataStore(dvd.entity.DataStore dt) {
        try {
            this.paramvalues = new String[]{
                Integer.toString(dt.getDataID()),
                dt.getDataName(),
                dt.getDataImage(),
                dt.getDataPath()
            };
            this.maphand = new HandlingBusiness();
            return this.maphand.UpdateToDB("aUpdateDataStore", "?,?,?,?", paramvalues);
        } catch (Exception e) {
            return false;
        }
    }
}
