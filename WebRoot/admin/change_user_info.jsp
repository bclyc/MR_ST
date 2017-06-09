<%@page import="javax.xml.crypto.URIDereferencer"%>
<%@ page contentType="text/html;charset=GBK" import="database.SqlHelper,java.sql.*,java.io.*,java.text.*,java.util.Date,java.net.URLDecoder,java.util.regex.Matcher,java.util.regex.Pattern"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<!DOCTYPE html>
<html>
<head>
<%
	String userId="";	
	String userType="";
	String userTypeName="";
	String sid = session.getId();
	String success ="";
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
		SqlHelper sh=new SqlHelper();
		
		String uid=URLDecoder.decode(request.getParameter("uid"),"UTF-8");
		String password=URLDecoder.decode(request.getParameter("password"),"UTF-8");
		String company=URLDecoder.decode(request.getParameter("company"),"UTF-8");
		String name=URLDecoder.decode(request.getParameter("name"),"UTF-8");
		String telephone=URLDecoder.decode(request.getParameter("tele"),"UTF-8");
		String email=URLDecoder.decode(request.getParameter("email"),"UTF-8");
		
		
		//check email
		String check = "^([a-z0-9A-Z]+[-|_|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$";
        Pattern regex = Pattern.compile(check);
        Matcher matcher = regex.matcher(email);
        boolean flag = matcher.matches();
        if(flag==false){
        	success="邮箱格式不正确!";
        	System.out.println("邮箱格式不正确!");
			
        }
                
		String sql1="select EMAIL from user where EMAIL=? and ID!=?";
		String paras1[]={email,uid};
		ResultSet rs1=sh.query(sql1, paras1);
		if(rs1.next()){
			success="邮箱已被使用!";
			System.out.println("邮箱已被使用!");
			
		}
		
		if(success.equals("")){
			String sql0="update user set PASSWORD=?, COMPANY=?, USER_NAME=?, TELEPHONE=?, EMAIL=? where ID=?";
			String[] param0={password, company, name, telephone, email, uid};
			sh.update(sql0,param0);
			
			
		}
		
		sh.close();
	}		 
%>
		
		 		 
 
<script type="text/javascript">
	if(<%=success.equals("")%>)	alert("成功！");
	else	alert("<%=success%>");
	window.location.href="/MR_ST/admin/admin_user.jsp";
</script>

</head>