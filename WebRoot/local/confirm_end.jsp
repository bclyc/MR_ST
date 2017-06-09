<%@ page contentType="text/html;charset=GBK" import="database.SqlHelper,java.sql.*,java.io.*,java.text.*,java.util.Date"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%
	String userId="";	
	String userType="";
	String userTypeName="";
	String sid = session.getId();
	String mailto = "";
	
	if(session.getAttribute("userId")!=null||session.getAttribute("userType")!=null){
		userId= (String)session.getAttribute("userId");
		userType= (String)session.getAttribute("userType");
	}
	
	if(!userType.equals("3")||!sid.equals(request.getParameter("sid"))){
		response.sendRedirect("/MR_ST/redirect_login.jsp");
	}else{
		if(userType.equals("1"))	userTypeName="管理员"; else if(userType.equals("2"))	userTypeName="项目管理员";
		else if(userType.equals("3"))	userTypeName="当地账号";
		else if(userType.equals("4"))	userTypeName="制作人员";
		
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SqlHelper sh0=new SqlHelper(); 
		 
		 if(request.getParameter("confirm").equals("true")){
		 	
			
			String note=userId+"确认了"+request.getParameter("projectId")+"项目的制作结果,项目结束";
			String comments = request.getParameter("comments");
			if(comments!=null&&comments!=""&&comments.length()!=0&& !comments.equals("null")){
					note=note+", 备注:"+comments;			
				}else{
					note=note+", 备注:无";
			}
			
			String sql0="update project set PROGRESS='8', NOTE=?, CLIENT_CONFIRM_DATE=? where PROJECT_ID=?";
			String[] paras1={note, df.format(new Date()), request.getParameter("projectId")};
			sh0.update(sql0, paras1);			
			
			String sql3="insert into log (USER_ID,PROJECT_ID,DATE,PROGRESS,NOTE) values(?,?,?,'8',?)";
			String paras3[]={userId, request.getParameter("projectId"), df.format(new Date()), note};		
			sh0.update(sql3, paras3);
			
		 }else if(request.getParameter("confirm").equals("false")){
			
			String note=userId+"要求"+request.getParameter("projectId")+"项目返工";
			String comments = request.getParameter("comments");
			if(comments!=null&&comments!=""&&comments.length()!=0&& !comments.equals("null")){
					note=note+", 备注:"+comments;			
				}else{
					note=note+", 备注:无";
			}
			
			String sql0="update project set PROGRESS='6', NOTE=? where PROJECT_ID=?";
			String[] paras1={note, request.getParameter("projectId")};
			sh0.update(sql0, paras1);
						
			String sql3="insert into log (USER_ID,PROJECT_ID,DATE,PROGRESS,NOTE) values(?,?,?,'6',?)";
			String paras3[]={userId, request.getParameter("projectId"), df.format(new Date()), note};		
			sh0.update(sql3, paras3);
			
			
		 }
		 
		 sh0.close();				
	}	
%>

<!DOCTYPE html>
<html>
<head>

 
<script type="text/javascript">
	alert("成功！");
// 	window.location.href="/MR_ST/local/local.jsp";
	if(<%=request.getParameter("confirm").equals("false")%>){
		window.location.href=encodeURI(encodeURI("/MR_ST/mail.jsp?projectId="+"<%=request.getParameter("projectId")%>"+"&sid="+"<%=sid%>"+"&toUsername="+"admin"+"&use=76"));
	}else if(<%=request.getParameter("confirm").equals("true")%>){
		window.location.href=encodeURI(encodeURI("/MR_ST/mail.jsp?projectId="+"<%=request.getParameter("projectId")%>"+"&sid="+"<%=sid%>"+"&toUsername="+"admin"+"&use=78"));
	}
	
</script>

</head>