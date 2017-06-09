<%@ page contentType="text/html;charset=GBK" import="database.SqlHelper,java.sql.*,java.io.*,java.text.*,java.util.Date"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<!DOCTYPE html>
<html>
<head>
<%
	
	String sid = session.getId();
	String sidstring = request.getParameter("sidstring");
	String userId = request.getParameter("user_id");
	
	
	if(!sid.equals(request.getParameter("sid"))){		
		response.sendRedirect("/MR_ST/redirect_login.jsp");
	}else{
		String pw = request.getParameter("pw1")	;		
		
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SqlHelper sh0=new SqlHelper();
			
		String sql0="update user set PASSWORD=? where ID=? ";
		String[] paras0={pw,userId};
		sh0.update(sql0, paras0);
		
		String sql1="update reset set DONE='1' where SID_STRING=? ";
		String[] paras1={sidstring};
		sh0.update(sql1, paras1);
	}		 
%>
		
		 		 
 
<script type="text/javascript">
	alert("÷ÿ÷√≥…π¶£°");
	window.location.href="/MR_ST/login.jsp";
</script>

</head>