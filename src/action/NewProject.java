package action;

import database.*;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Vector;
import java.util.Date;

import javax.xml.ws.Response;

import com.opensymphony.xwork2.ActionSupport;

public class NewProject extends ActionSupport{
	
	
	private String title;
	private String companyname;
	private String description;
	private String city;
	private String address;
	private String personincharge;
	private String contacttele;
	private String contactemail;
	private String cameranum;
	private String remark;
	private String userId;
	private String sid;
	private String comments;
	
	private String sub;
	private String mainId;
	
	private String message;
	
	private String projectId;
		
	public String getTitle() {
		return title;
	}	
	public void setTitle(String title) {
		this.title = title;
	}

	public String getDescription() {
		return description;
	}	
	public void setDescription(String description) {
		this.description = description;
	}

	public String getCity() {
		return city;
	}	
	public void setCity(String city) {
		this.city = city;
	}
	
	public String getAddress() {
		return address;
	}	
	public void setAddress(String address) {
		this.address = address;
	}
	
	public String getPersonincharge() {
		return personincharge;
	}	
	public void setPersonincharge(String personincharge) {
		this.personincharge = personincharge;
	}
	
	public String getContacttele() {
		return contacttele;
	}	
	public void setContacttele(String contacttele) {
		this.contacttele = contacttele;
	}

	public String getContactemail() {
		return contactemail;
	}	
	public void setContactemail(String contactemail) {
		this.contactemail = contactemail;
	}

	public String getCameranum() {
		return cameranum;
	}	
	public void setCameranum(String cameranum) {
		this.cameranum = cameranum;
	}

	public String getRemark() {
		return remark;
	}	
	public void setRemark(String remark) {
		this.remark = remark;
	}
	
	public String getUserId() {
		return userId;
	}	
	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	public String getSid() {
		return sid;
	}
	public void setSid(String sid) {
		this.sid = sid;
	}
	
	public String getComments() {
		return comments;
	}
	public void setComments(String comments) {
		this.comments = comments;
	}

	public String getSub() {
		return sub;
	}
	public void setSub(String sub) {
		this.sub = sub;
	}
	
	public String getMainId() {
		return mainId;
	}
	public void setMainId(String mainId) {
		this.mainId = mainId;
	}
	
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	
	public String getCompanyname() {
		return companyname;
	}
	public void setCompanyname(String companyname) {
		this.companyname = companyname;
	}
	
	public String getProjectId() {
		return projectId;
	}
	public void setProjectId(String projectId) {
		this.projectId = projectId;
	}
	
	// all struts logic here
	public String execute() {		
		if(sub.equals("no")){
			if(projectId==null){	//New project
				System.out.println("New project:"+title);
				System.out.println("comments:"+comments);
				
		        SqlHelper sh=new SqlHelper();
				String sql="select PROJECT_ID from project ORDER BY PROJECT_ID DESC";
				ResultSet rs=sh.query(sql);
				
				String projectid = "100000" ;
				try {
					if(rs.next()){
						projectid = Integer.toString(rs.getInt(1)+1);
					}
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
				SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				
				String note=userId+"新建了项目, 备注：";
				if(comments!=null&&comments!=""&&comments.length()!=0){
					note=note+comments;			
				}else{
					note=note+"无";
				}
				//Insert into project table
				String sql1="insert into project (PROJECT_ID,TITLE,COMPANY_NAME,DESCRIPTION,CITY,ADDRESS,PERSON_IN_CHARGE,CONTACT_TELE,CONTACT_EMAIL,CAMERA_NUM,REMARK,SUBMIT_BY,SUBMIT_DATE,VALIDATION,VALIDATION_DATE,PROGRESS,NOTE, V_SUBMIT_DATE, ASSIGNMENT_DATE, START_DATE, FINISH_DATE, RESULT_VALIDATION_DATE, CLIENT_CONFIRM_DATE)" 
						+" values(?,?,?,?,?,?,?,?,?,?,?,?,?, '0','','1',?,'','','','','','') ;";
				String paras1[]={projectid, title, companyname, description, city, address, personincharge, contacttele,	contactemail,  cameranum, remark, userId, df.format(new Date()), note};		
				sh.update(sql1, paras1);
				
				//Insert into project_filepath table
				String sql2="insert into project_filepath (PROJECT_ID,FINE_MODELING) values(?,'0');";
							
				String paras2[]={projectid};		
				sh.update(sql2, paras2);
				
				//Insert into project_sub table
				String sql22="insert into project_sub (SUB_PROJECT_ID,MAIN_PROJECT_ID,ABANDON) values(?,?,'0');";
							
				String paras22[]={projectid,projectid};		
				sh.update(sql22, paras22);
				
				//Insert into log table
				String sql3="insert into log (USER_ID,PROJECT_ID,DATE,PROGRESS,NOTE) values(?,?,?,'1',?)";
				String paras3[]={userId, projectid, df.format(new Date()), note};		
				sh.update(sql3, paras3);
				
				setMessage("New project successfully created!");
				sh.close();
				return SUCCESS;
			}else{	//Update project info
				SqlHelper sh=new SqlHelper();
				try{
					String sql="update project set TITLE=?,COMPANY_NAME=?,DESCRIPTION=?,CITY=?,ADDRESS=?,PERSON_IN_CHARGE=?,CONTACT_TELE=?,CONTACT_EMAIL=?,CAMERA_NUM=?,REMARK=? where PROJECT_ID=?";
					String[] paras0={title, companyname, description, city, address, personincharge, contacttele, contactemail, cameranum, remark,projectId};
					sh.update(sql,paras0);
					
				}catch(Exception e){
					e.printStackTrace();
				}finally{
					sh.close();
					setMessage("修改成功!");
					return SUCCESS;
				}
			}
			
			
		}else if(sub.equals("yes")){
			System.out.println("New sub project:"+title);
			System.out.println("comments:"+comments);
			
	        SqlHelper sh=new SqlHelper();
			String sql="select PROJECT_ID from project ORDER BY PROJECT_ID DESC";
			ResultSet rs=sh.query(sql);
			
			String projectid = "100000" ;
			try {
				if(rs.next()){
					projectid = Integer.toString(rs.getInt(1)+1);
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			
			String note=userId+"新建了子项目, 备注：";
			if(comments!=null&&comments!=""&&comments.length()!=0){
				note=note+comments;			
			}else{
				note=note+"无";
			}
			
			
			try {
				//Look up info of main project
				String sql0="select CITY,ADDRESS,PERSON_IN_CHARGE,CONTACT_TELE,CONTACT_EMAIL from project where PROJECT_ID=?";
				String paras0[]={mainId};		
				ResultSet rs0=sh.query(sql0, paras0);
				rs0.next();
				
				//Insert into project table
				String sql1="insert into project (PROJECT_ID,TITLE,DESCRIPTION,CITY,ADDRESS,PERSON_IN_CHARGE,CONTACT_TELE,CONTACT_EMAIL,CAMERA_NUM,REMARK,SUBMIT_BY,SUBMIT_DATE,VALIDATION,VALIDATION_DATE,PROGRESS,NOTE, V_SUBMIT_DATE, ASSIGNMENT_DATE, START_DATE, FINISH_DATE, RESULT_VALIDATION_DATE, CLIENT_CONFIRM_DATE)" 
						+" values(?,?,?,?,?,?,?,?,?,?,?,?, '0','','1',?,'','','','','','') ;";
				String paras1[]={projectid, title, description, rs0.getString(1), rs0.getString(2), rs0.getString(3), rs0.getString(4),	rs0.getString(5),  cameranum, remark, userId, df.format(new Date()), note};		
				sh.update(sql1, paras1);
				
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
					
			
			//Insert into project_filepath table
			String sql2="insert into project_filepath (PROJECT_ID,FINE_MODELING) values(?,'0');";
						
			String paras2[]={projectid};		
			sh.update(sql2, paras2);
			
			//Insert into project_sub table
			String sql22="insert into project_sub (SUB_PROJECT_ID,MAIN_PROJECT_ID,ABANDON) values(?,?,'0');";
						
			String paras22[]={projectid,mainId};		
			sh.update(sql22, paras22);
			
			//Insert into log table
			String sql3="insert into log (USER_ID,PROJECT_ID,DATE,PROGRESS,NOTE) values(?,?,?,'1',?)";
			String paras3[]={userId, projectid, df.format(new Date()), note};		
			sh.update(sql3, paras3);
			
			setMessage("New sub project successfully created!");
			return SUCCESS;
			
		}
		
		return INPUT;
		
	}
	
	public void validate(){
		if(sub.equals("no")){
	        if("".equals(title)){
	            addFieldError("title", getText("title.required"));
	        }
	        if("".equals(description)){
	            addFieldError("description", getText("description.required"));
	        }
	        if("".equals(city)){
	            addFieldError("city", getText("city.required"));
	        }
	        if("".equals(address)){
	            addFieldError("address", getText("address.required"));
	        }
	        if("".equals(personincharge)){
	            addFieldError("personincharge", getText("personincharge.required"));
	        }
	        if("".equals(contacttele)){
	            addFieldError("contacttele", getText("contacttele.required"));
	        }
	        if("".equals(contactemail)){
	            addFieldError("contactemail", getText("contactemail.required"));
	        }
	        if("".equals(cameranum)){
	            addFieldError("cameranum", getText("cameranum.required"));
	        }
	        if("".equals(remark)){
	            addFieldError("remark", getText("remark.required"));
	        }
		}else if(sub.equals("yes")){
			if("".equals(title)){
	            addFieldError("title", getText("title.required"));
	        }
	        if("".equals(description)){
	            addFieldError("description", getText("description.required"));
	        }
	        if("".equals(cameranum)){
	            addFieldError("cameranum", getText("cameranum.required"));
	        }
	        if("".equals(remark)){
	            addFieldError("remark", getText("remark.required"));
	        }
		}
                
    }
}