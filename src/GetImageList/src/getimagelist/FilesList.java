/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package getimagelist;

/**
 *
 * @author Администратор
 */
public class FilesList {

    public String rootCatalogpath;
    public String filePath;
    
    public FilesList(String dir, String file)
    {        
        rootCatalogpath = dir;
        filePath = file;
    }    
}
