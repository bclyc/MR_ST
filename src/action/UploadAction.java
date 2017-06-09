package action;  
  
import java.io.File;
import java.io.FileOutputStream;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
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
  

public class UploadAction  extends ActionSupport {  
    /** 代表上传的文件内容的对象 */  
    private File upload;  
      
    /** Struts2约定的代表上传的文件的名 */  
    private String uploadFileName;  
    /** Struts2约定的代表上传文件的内容类型(MIME) */  
    private String uploadContentType;  
    
    private String message;
    private String projectId;
    private String sid;
    
    private String finFlag;
    /** 上传的文件用途 */ 
    private String fileUsage;
    
    private String filedata;
    private String markerPosition;
    private String links;
    private String assId;
    
    /** 视频链接 */
    private List<String> camera;
    
    public String execute() throws Exception{
    	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
    	if(fileUsage.equals("Base_map")||fileUsage.equals("Base_map_marked")){
    		if(uploadFileName==null){
        		this.addFieldError("upload", "Please select file!");
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
        	if(param.containsKey("projectId")){
        		this.projectId=(String)param.get("projectId");
        		System.out.println("Got proId" + projectId);
        	}
        	
            System.out.println("文件名：" + uploadFileName);  
            System.out.println("不要用upload.getName()来获取文件名，这个是临时名：" + upload.getName());  
            System.out.println("文件的内容类型：" + uploadContentType);  
            System.out.println("project：" + projectId);  
            
            //////////使用IO流来操作upload属性  
            //File destPath = new File("d:/"); //服务端存放文件的目录  
              
            //如果要存放到web服务器中本项目的某个目录下  
            //根据服务器的文件保存地址和原文件名创建目录文件全路径  
            String destPath = ServletActionContext.getServletContext().getRealPath("/Uploads/"+projectId);  
              
            System.out.println("path：" + destPath); 
            
            String fileSuffix = uploadFileName.substring(uploadFileName.lastIndexOf("."), uploadFileName.length());
            
            File dest = new File(destPath, fileUsage+fileSuffix); //服务器的文件  
              
            FileUtils.copyFile(upload, dest);//完成了文件的拷贝工作  
            
            String urlPath="/MR_ST/Uploads/"+projectId+"/"+fileUsage+fileSuffix;
            System.out.println("urlPath：" + urlPath);
            //update filepath in database
            SqlHelper sh=new SqlHelper();
            String sql="update project_filepath set "+fileUsage+"=? where project_Id=?";	
    		String []paras={urlPath, projectId};
    		sh.update(sql,paras);
            
            message ="上传成功！";
            return "succ";
    	}else if(fileUsage.equals("Video_link")){
    		SqlHelper sh=new SqlHelper();
    		String []paras= new String[camera.size()+1];
            String sql="update project_filepath set ";    		
    		
    		for(int i=0;i<camera.size()-1;i++){
    			sql += "CAMERA_"+(i+1)+"=?, ";
    			paras[i]=camera.get(i);
    		}
    		sql += "CAMERA_"+camera.size()+"=? ";
			paras[camera.size()-1]=camera.get(camera.size()-1);
    		
    		sql += "where project_Id=?";
    		paras[camera.size()]=projectId;
    		
    		System.out.println("sql：" + sql);
    		System.out.println(Arrays.toString(paras));
    		sh.update(sql,paras);
    		
    		message ="上传成功！";
    		return "succ";
    	}else if(fileUsage.equals("Config_file")){
    		String urlPath="";
    		if(uploadFileName!=null){
    			System.out.println("文件名：" + uploadFileName);  
                System.out.println("不要用upload.getName()来获取文件名，这个是临时名：" + upload.getName());  
                System.out.println("文件的内容类型：" + uploadContentType);  
                System.out.println("project：" + projectId);  
                
                //////////使用IO流来操作upload属性  
                //File destPath = new File("d:/"); //服务端存放文件的目录  
                  
                //如果要存放到web服务器中本项目的某个目录下  
                //根据服务器的文件保存地址和原文件名创建目录文件全路径  
                String destPath = ServletActionContext.getServletContext().getRealPath("/Uploads/"+projectId+"/"+assId);  
                  
                System.out.println("path：" + destPath); 
                
                String fileSuffix = uploadFileName.substring(uploadFileName.lastIndexOf("."), uploadFileName.length());
                
                File dest = new File(destPath, uploadFileName); //服务器的文件  
                  
                FileUtils.copyFile(upload, dest);//完成了文件的拷贝工作  
                
                urlPath="/MR_ST/Uploads/"+projectId+"/"+assId+"/"+uploadFileName;
                System.out.println("urlPath：" + urlPath);
        	}    		
            
            //update filepath in database
            SqlHelper sh=new SqlHelper();
            String sql0="select distinct ASSIGNMENT_ID from ass_filepath where ASSIGNMENT_ID=?";	
    		String []paras0={assId};
    		ResultSet rs0 = sh.query(sql0,paras0);
    		
    		
    		if(!rs0.next()){
    			String sql="insert into ass_filepath (ASSIGNMENT_ID,PROJECT_ID,FILE_PATH,LINKS,SUBMIT_DATE) values(?,?,?,?,?)";	
        		String []paras={assId, projectId, urlPath, links, df.format(new Date())};
        		sh.update(sql,paras);
    		}else{
    			String sql="update ass_filepath set FILE_PATH=?,LINKS=?,SUBMIT_DATE=? where ASSIGNMENT_ID=?";	
        		String []paras={urlPath, links, df.format(new Date()), assId};
        		sh.update(sql,paras);
    		}
            
            message ="上传成功！";
            
            finFlag="1";
            return "succ";
    	}else if(fileUsage.equals("Result")){
    		String urlPath="";
    		if(uploadFileName!=null){
    			System.out.println("文件名：" + uploadFileName);  
                System.out.println("不要用upload.getName()来获取文件名，这个是临时名：" + upload.getName());  
                System.out.println("文件的内容类型：" + uploadContentType);  
                System.out.println("project：" + projectId);  
                
                //////////使用IO流来操作upload属性  
                //File destPath = new File("d:/"); //服务端存放文件的目录  
                  
                //如果要存放到web服务器中本项目的某个目录下  
                //根据服务器的文件保存地址和原文件名创建目录文件全路径  
                String destPath = ServletActionContext.getServletContext().getRealPath("/Uploads/"+projectId+"/Result");  
                  
                System.out.println("path：" + destPath); 
                
                String fileSuffix = uploadFileName.substring(uploadFileName.lastIndexOf("."), uploadFileName.length());
                
                File dest = new File(destPath, uploadFileName); //服务器的文件  
                  
                FileUtils.copyFile(upload, dest);//完成了文件的拷贝工作  
                
                urlPath="/MR_ST/Uploads/"+projectId+"/Result/"+uploadFileName;
                System.out.println("urlPath：" + urlPath);
        	}    		
            
            //update filepath in database
            SqlHelper sh=new SqlHelper();
            
			String sql="update project_filepath set CONFIG_FILE=?,RESULT_LINK=? where PROJECT_ID=?";	
    		String []paras={urlPath, links, projectId};
    		sh.update(sql,paras);
    		
            
            message ="上传成功！";
            
            finFlag="1";
            return "succ";
    	}else if(fileUsage.equals("Base_map_marked_canvas")){
    		BASE64Decoder decoder = new BASE64Decoder();
    		
    		byte[] decodedBytes = decoder.decodeBuffer(filedata);

    		String destPath = ServletActionContext.getServletContext().getRealPath("/Uploads/"+projectId);  
    		
    		FileOutputStream out = new FileOutputStream(destPath+"/Base_map_marked.png");
    		out.write(decodedBytes);
    		out.close();
    		
    		String urlPath="/MR_ST/Uploads/"+projectId+"/Base_map_marked.png";
    		
    		SqlHelper sh=new SqlHelper();
            String sql="update project_filepath set BASE_MAP_MARKED=? where project_Id=?";	
    		String []paras={urlPath, projectId};
    		sh.update(sql,paras);
    		
    		message ="上传成功！";
            return "succ";
            
    	}else if(fileUsage.equals("Base_map_marked_position")){
    		SqlHelper sh=new SqlHelper();
            String sql="update project_filepath set LNGLAT=? where project_Id=?";	
    		String []paras={markerPosition, projectId};
    		sh.update(sql,paras);
            
            message ="成功！";
            
            return "succ";
            
    	}else if(fileUsage.equals("Fine_link")){
    		SqlHelper sh=new SqlHelper();
            String sql="update project_filepath set FINE_MODELING=? where project_Id=?";	
    		String []paras={filedata, projectId};
    		sh.update(sql,paras);
            
            message ="提交成功！";
            
            return "succ";
            
    	}
    	
    	return "input";  
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

	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	
	public String getProjectId() {
		return projectId;
	}
	public void setProjectId(String projectId) {
		this.projectId = projectId;
	}
	
	public String getSid() {
		return sid;
	}
	public void setSid(String sid) {
		this.sid = sid;
	}
	
	public String getFinFlag() {
		return finFlag;
	}
	public void setFinFlag(String finFlag) {
		this.finFlag = finFlag;
	}
	
	public String getFileUsage() {
		return fileUsage;
	}
	public void setFileUsage(String fileUsage) {
		this.fileUsage = fileUsage;
	}
	
	public String getFiledata() {
		return filedata;
	}
	public void setFiledata(String filedata) {
		this.filedata = filedata;
	}
	
	public String getMarkerPosition() {
		return markerPosition;
	}
	public void setMarkerPosition(String markerPosition) {
		this.markerPosition = markerPosition;
	}
	
	public List<String> getCamera() {
		return camera;
	}
	public void setCamera(List<String> camera) {
		this.camera = camera;
	}
	
	public String getLinks() {
		return links;
	}
	public void setLinks(String links) {
		this.links = links;
	}
	
	public String getAssId() {
		return assId;
	}
	public void setAssId(String assId) {
		this.assId = assId;
	}
}  