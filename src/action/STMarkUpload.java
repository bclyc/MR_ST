package action;  
  
import java.io.File;
import java.io.FileOutputStream;
import java.sql.ResultSet;
import java.util.*;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FileUtils;  
import org.apache.struts2.ServletActionContext;  
  
import com.opensymphony.xwork2.ActionSupport;

import database.SqlHelper;  

import sun.misc.BASE64Decoder; 
  

public class STMarkUpload  extends ActionSupport {  
    /** 代表上传的文件内容的对象 */  
    private File upload;  
      
    /** Struts2约定的代表上传的文件的名 */  
    private String uploadFileName;  
    /** Struts2约定的代表上传文件的内容类型(MIME) */  
    private String uploadContentType;  
    
    private String username;
	private String password;
	private String use;

    
    
    
    public String execute() throws Exception{
    	
		if(uploadFileName==null){
    		this.addFieldError("upload", "Please select file!");
    		System.out.println("无文件！");
    		return INPUT;
    	}
		
		System.out.println("username:"+username+", password:"+password+", use:"+use);
		System.out.println("uploadFileName:"+uploadFileName+", upload.getName():"+upload.getName()+", size:"+upload.length()+", uploadContentType:"+uploadContentType);
		
//		SqlHelper sh=new SqlHelper();
//		String sql="select TYPE,DISABLE from user where ID=? and PASSWORD=?";
//		String paras[]={username,password};
//		ResultSet rs=sh.query(sql, paras);
//		
//		if(!rs.next()){
//			return INPUT;			
//		}
//		if(!rs.getString(1).equals("3")){
//			return INPUT;
//		}
		
		if(!username.equals("padtest")||!password.equals("padtest")){
			return INPUT;
		}
		String fileName ="";
		if(use.equals("base")){
			fileName="base";
		}else if(use.equals("mark")){
			fileName="mark";
		}else{
			return INPUT;
		}
    	
    	HttpServletRequest request = ServletActionContext.getRequest();    	
    	
    	DiskFileItemFactory factory = new DiskFileItemFactory();
    	ServletFileUpload fileuploads = new ServletFileUpload(factory);
    	List items = fileuploads.parseRequest(request);
    	Map param = new HashMap();
    	for(Object object:items){
    	    FileItem fileItem = (FileItem) object;
    	    if (fileItem.isFormField()) {
    	        param.put((String)fileItem.getFieldName(), fileItem.getString("GBK"));
    	        System.out.println((String)fileItem.getFieldName() + "----"+fileItem.getString("GBK"));
    	    }
    	} 
    	
    	
        System.out.println("文件名：" + uploadFileName);  
        System.out.println("不要用upload.getName()来获取文件名，这个是临时名：" + upload.getName());  
        System.out.println("文件的内容类型：" + uploadContentType);  
        
        //////////使用IO流来操作upload属性  
        //File destPath = new File("d:/"); //服务端存放文件的目录  
          
        //如果要存放到web服务器中本项目的某个目录下  
        //根据服务器的文件保存地址和原文件名创建目录文件全路径  
        String destPath = ServletActionContext.getServletContext().getRealPath("/Uploads/Pad/"+username);  
          
        System.out.println("path：" + destPath); 
        
        String fileSuffix = uploadFileName.substring(uploadFileName.lastIndexOf("."), uploadFileName.length());
        
        File dest = new File(destPath, fileName+fileSuffix); //服务器的文件  
          
        FileUtils.copyFile(upload, dest);//完成了文件的拷贝工作  
        
        String urlPath="/Uploads/Pad/"+username+"/"+fileName+fileSuffix;
        System.out.println("urlPath：" + urlPath);
        //update filepath in database
        
//        String sql1="update project_filepath set "+fileUsage+"=? where project_Id=?";	
//		String []paras1={urlPath, projectId};
//		sh.update(sql1,paras1);
        
        
        return "succ";
    	 
    }  
     
    public File getUpload() {  
        return upload;  
    }  
    public void setUpload(File upload) {  
        this.upload = upload;  
    }  
    public String getUploadFileName() {  
        return uploadFileName;  
    }  
    public void setUploadFileName(String uploadFileName) {  
        this.uploadFileName = uploadFileName;  
    }  
    public String getUploadContentType() {  
        return uploadContentType;  
    }  
    public void setUploadContentType(String uploadContentType) {  
        this.uploadContentType = uploadContentType;  
    }  

    public String getUsername() {
		return username;
	}
    public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}	
	public void setPassword(String password) {
		this.password = password;
	}
	
	public String getUse() {
		return use;
	}	
	public void setUse(String use) {
		this.use = use;
	}
}  