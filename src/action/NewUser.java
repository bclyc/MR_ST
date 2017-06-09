package action;

import database.*;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Vector;
import java.util.Date;

import javax.xml.ws.Response;

import com.opensymphony.xwork2.ActionSupport;

public class NewUser extends ActionSupport{
	
	
	private String id;
	private String password;
	private String type;
	private String username;
	private String telephone;
	private String email;
	
	private String sid;
	
	private String message;
	
		
	public String getId() {
		return id;
	}	
	public void setId(String id) {
		this.id = id;
	}

	public String getPassword() {
		return password;
	}	
	public void setPassword(String password) {
		this.password = password;
	}

	public String getType() {
		return type;
	}	
	public void setType(String type) {
		this.type = type;
	}
	
	public String getUsername() {
		return username;
	}	
	public void setUsername(String username) {
		this.username = username;
	}
	
	public String getTelephone() {
		return telephone;
	}	
	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}
	
	public String getEmail() {
		return email;
	}	
	public void setEmail(String email) {
		this.email = email;
	}

	public String getSid() {
		return sid;
	}
	public void setSid(String sid) {
		this.sid = sid;
	}
	
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	
	// all struts logic here
	public String execute() {		
        SqlHelper sh = new SqlHelper();
        
        String sql1="select count(ID) from user where ID=?";
        String[] paras1={id};
        ResultSet rs=sh.query(sql1, paras1);
        String sql4="select count(EMAIL) from user where EMAIL=?";
        String[] paras4={email};
        ResultSet rs4=sh.query(sql4, paras4);
        try {
			rs.next();
			rs4.next();
			if(rs.getInt(1)>=1){
				message="此账号ID已经存在！请使用其他ID.";
				return INPUT;
			}else if(rs4.getInt(1)>=1){
				message="此Email已经已被注册！请使用其他Email.";
				return INPUT;
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        
        System.out.println(type);
        
		String sql2="insert into user (ID, PASSWORD, TYPE, USER_NAME, TELEPHONE, EMAIL, DISABLE) values(?,?,?,?,?,?,'0');";
		String paras2[]={id, password, type, username, telephone, email};		
		sh.update(sql2, paras2);
		
		setMessage("New user successfully created!");
		return SUCCESS;
	}
	
	public void validate(){
        
                
    }
}