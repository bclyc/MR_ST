<%@ page language="java" import="java.util.*" pageEncoding="GBK"%>
<%
System.out.println(request.getServerName());
if(request.getServerName().equals("nave.vr3i.com")){
	response.sendRedirect("/MR_ST/redirect_vr3i.jsp");
}else{
	response.sendRedirect("/MR_ST/login.jsp");
}

%>

