<%@ page contentType="text/html;charset=GBK" import="database.SqlHelper,java.sql.*,java.io.*,java.text.*,java.util.Date,java.net.URLDecoder"%>
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
	
	if(!userType.equals("1")||!sid.equals(request.getParameter("sid"))){		
		response.sendRedirect("/MR_ST/redirect_login.jsp");
	}else{
		if(userType.equals("1"))	userTypeName="管理员"; else if(userType.equals("2"))	userTypeName="项目管理员";
		else if(userType.equals("3"))	userTypeName="当地账号";
		else if(userType.equals("4"))	userTypeName="制作人员";
						
		
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SqlHelper sh0=new SqlHelper();
		
		String action=request.getParameter("action");
		String userid=request.getParameter("userId");
		userid=URLDecoder.decode(userid,"UTF-8");
		System.out.println("userid:"+userid);
		if(action.equals("disable")){
			String sql0="update user set DISABLE='1' where ID=?";
			String[] paras0={userid};
			sh0.update(sql0, paras0);
		}else{
			String sql0="update user set DISABLE='0' where ID=?";
			String[] paras0={userid};
			sh0.update(sql0, paras0);
		}
		 
		
	}		 
%>
		
		 		 
 
<script type="text/javascript">
	alert("成功！");
	window.location.href="/MR_ST/admin/admin_user.jsp";
</script>

</head>