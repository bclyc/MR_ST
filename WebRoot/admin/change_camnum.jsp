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
		
		String sql0="update project set CAMERA_NUM=? where PROJECT_ID=?";
		String[] param0={request.getParameter("camNum"), request.getParameter("projectId")};
		sh0.update(sql0,param0);
					
			
		
	}		 
%>
		
		 		 
 
<script type="text/javascript">
	alert("���ĳɹ���");
	window.location.href="/MR_ST/admin/assignment.jsp?projectId="+${param.projectId}+"&sid="+"<%=sid%>";
</script>

</head>