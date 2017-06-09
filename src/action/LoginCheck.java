package action;

import database.*;

import java.sql.*;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.xml.ws.Response;

import org.apache.catalina.Session;
import org.apache.struts2.ServletActionContext;

import com.opensymphony.xwork2.ActionSupport;

public class LoginCheck extends ActionSupport{
	
	private String username;
	private String password;
	private String message;

	public String getUsername() {
		return username;
	}
	public String getPassword() {
		return password;
	}
	public String getMessage() {
		return message;
	}

	public void setUsername(String username) {
		this.username = username;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public void setMessage(String message) {
		this.message = message;
	}

	// all struts logic here
	public String execute() {		
		HttpServletRequest request = ServletActionContext.getRequest();
    	HttpSession Session = request.getSession();
		
		String type="";
        SqlHelper sh=new SqlHelper();
        
        if(username.equals("")||username==null){
        	setMessage("请输入用户名");
        	return INPUT;
        }
        if(password.equals("")||password==null){
        	setMessage("请输入密码");
        	return INPUT;
        }
        
		String sql="select TYPE,DISABLE from user where ID=? and PASSWORD=?";
		String paras[]={username,password};
		String sql2="select TYPE,ID,DISABLE from user where EMAIL=? and PASSWORD=?";
		String paras2[]={username,password};
		
		ResultSet rs=sh.query(sql, paras);
		ResultSet rs2=sh.query(sql2, paras2);
		
		try {
			if(rs.next()){
				if(rs.getInt(2)==1){
					setMessage("账号已被停用!");
					
					rs.close();
					rs2.close();
					sh.close();
					return INPUT;
				}
				type = Integer.toString(rs.getInt(1));
				System.out.println("userType:"+type);
				String usertype="";
				switch(type)
				{
				case "1": usertype="管理员";
				case "2": usertype="项目管理员";
				case "3": usertype="当地账号";
				case "4": usertype="制作人员";
				}
				
				Session.setAttribute("userId",username);
				Session.setAttribute("userType",type);
				
				rs.close();
				rs2.close();
				sh.close();
				return type;
			}else if(rs2.next()){
				if(rs.getInt(3)==1){
					setMessage("账号已被停用!");
					
					rs.close();
					rs2.close();
					sh.close();
					return INPUT;
				}
				type = Integer.toString(rs2.getInt(1));
				System.out.println("userType:"+type);
				String usertype="";
				switch(type)
				{
				case "1": usertype="管理员";
				case "2": usertype="项目管理员";
				case "3": usertype="当地账号";
				case "4": usertype="制作人员";
				}
				
				Session.setAttribute("userId",rs2.getString(2));
				Session.setAttribute("userType",type);
				
				rs.close();
				rs2.close();
				sh.close();
				return type;
			}else{
				setMessage("用户名或者密码错误!");
				
				rs.close();
				rs2.close();
				sh.close();
				return INPUT;
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			
		}
		
		return INPUT;
	}
	
	public void validate(){
        
                
    }
}