<%@ page contentType="text/html;charset=GBK" import="database.SqlHelper,java.sql.*,java.io.*,java.text.*,java.util.Date"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<!DOCTYPE html>
<html>
<head>
<%
	String sidstring = request.getParameter("sidstring");	
	SqlHelper sh0=new SqlHelper(); 
	String sql0="select NEW_EMAIL,USER_ID from reset where SID_STRING=? and RESET_TYPE='CH_EM' and DONE='0'";
	String[] paras0={sidstring};
	ResultSet rs0=sh0.query(sql0, paras0);
	
	String newemail="";
	String userId="";	
	if(!rs0.next()){
				
		RequestDispatcher rd;
       	rd = getServletContext().getRequestDispatcher("/login.jsp");
       	request.setAttribute("message", "链接已失效！");
       	rd.forward(request,response);
	}else{
		newemail = rs0.getString(1);
		userId = rs0.getString(2);				
		
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		
		String sql1="update user set EMAIL=? where ID=? ";
		String[] paras1={newemail,userId};
		sh0.update(sql1, paras1);
		
		String sql2="update reset set DONE='1' where SID_STRING=? and RESET_TYPE='CH_EM' and DONE='0'";
		String[] paras2={sidstring};
		sh0.update(sql2, paras2);
		
	}
		
%>
		
		 		 
 
<script type="text/javascript">
	
	alert("邮箱"+"<%=newemail%>"+" 绑定成功！");	
	window.location.href="/MR_ST/login.jsp";	
	
</script>

</head>