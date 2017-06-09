<%@ page contentType="text/html;charset=GBK" import="database.SqlHelper,java.sql.*,java.io.*,java.text.*,java.util.Date"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<!DOCTYPE html>
<html>
<head>
<%
	String userId="";	
	String userType="";
	String userTypeName="";
	String sid = session.getId();
	boolean success = false;	
	
	if(session.getAttribute("userId")!=null||session.getAttribute("userType")!=null){
		userId= (String)session.getAttribute("userId");
		userType= (String)session.getAttribute("userType");
	}
	
	if(!sid.equals(request.getParameter("sid"))){
		response.sendRedirect("/MR_ST/redirect_login.jsp");
	}else{
		if(userType.equals("1"))	userTypeName="管理员"; else if(userType.equals("2"))	userTypeName="项目管理员";
		else if(userType.equals("3"))	userTypeName="当地账号";
		else if(userType.equals("4"))	userTypeName="制作人员";
		
		String oldpw = request.getParameter("oldpw")	;
		String pw = request.getParameter("pw1")	;		
		
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SqlHelper sh0=new SqlHelper();
		String sidstring = sid+"CH_PW"+df.format(new java.util.Date());
			
		String sql0="select ID from user where PASSWORD=? and ID=?";
		String[] paras0={oldpw,userId};
		ResultSet rs0=sh0.query(sql0, paras0);
		if(rs0.next()){
			String sql1="update user set PASSWORD=? where ID=? ";
			String[] paras1={pw,userId};
			sh0.update(sql1, paras1);
			
			String sql2="insert into reset (SID_STRING,RESET_TYPE,USER_ID,DONE) values(?,'CH_PW',?,'1')";
			String[] paras2={sidstring,userId};
			sh0.update(sql2, paras2);
			
			success=true;
		}
	}
		 
%>
		
		 		 
 
<script type="text/javascript">
	if(<%=success==true%>){
		alert("更改成功！");
		window.location.href="/MR_ST/login.jsp";
	}else if(<%=success==false%>){
		alert("原密码错误！");
		window.location.href="javascript:history.back(-1)";
	}
	
</script>

</head>