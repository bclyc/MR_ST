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
		if(userType.equals("1"))	userTypeName="����Ա"; else if(userType.equals("2"))	userTypeName="��Ŀ����Ա";
		else if(userType.equals("3"))	userTypeName="�����˺�";
		else if(userType.equals("4"))	userTypeName="������Ա";
		
			
		
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SqlHelper sh0=new SqlHelper();
		String sidstring = sid+"CH_INFO"+df.format(new java.util.Date());
												
		String sql1="update user set USER_NAME=?,TELEPHONE=?,COMPANY=? where ID=? ";
		String[] paras1={request.getParameter("user_name"),request.getParameter("telephone"), request.getParameter("company"), userId};
		sh0.update(sql1, paras1);
		
		String sql2="insert into reset (SID_STRING,RESET_TYPE,USER_ID,DONE) values(?,'CH_INFO',?,'1')";
		String[] paras2={sidstring,userId};
		sh0.update(sql2, paras2);
		
		success=true;		
	}
		 
%>
		
		 		 
 
<script type="text/javascript">
	if(<%=success==true%>){
		alert("���ĳɹ���");
		window.location.href="/MR_ST/reset/change_info.jsp?sid=<%=sid%>";
	}else if(<%=success==false%>){		
		window.location.href="/MR_ST/reset/change_info.jsp?sid=<%=sid%>";
	}
	
</script>

</head>