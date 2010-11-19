public class FilesList {

    public String rootCatalogpath;
    public String filePath;
    public String fileType;
    public String parentLink;
    
    public FilesList(String dirString, String fileString, String fileTypeString, String parentLinkString)
    {        
        rootCatalogpath = dirString;
        filePath = fileString;
        fileType  = fileTypeString;
        parentLink = parentLinkString;
    }    
}