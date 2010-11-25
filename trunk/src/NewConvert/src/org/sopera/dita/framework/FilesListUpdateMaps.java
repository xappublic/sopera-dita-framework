package org.sopera.dita.framework;

public class FilesListUpdateMaps {

    public String rootCatalogpath;
    public String filePath;
    public String fileType;
    public String parentLink;
    
    public FilesListUpdateMaps(String dirString, String fileString, String fileTypeString, String parentLinkString)
    {        
        rootCatalogpath = dirString;
        filePath = fileString;
        fileType  = fileTypeString;
        parentLink = parentLinkString;
    }    
}