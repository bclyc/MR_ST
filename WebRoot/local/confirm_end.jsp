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
		if(userType.equals("1"))	userTypeName="����Ա"; else if(userType.equals("2"))	userTypeName="��Ŀ����Ա";
		else if(userType.equals("3"))	userTypeName="�����˺�";
		else if(userType.equals("4"))	userTypeName="������Ա";
		
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SqlHelper sh0=new SqlHelper(); 
		 
		 if(request.getParameter("confirm").equals("true")){
		 	
			
			String note=userId+"ȷ����"+request.getParameter("projectId")+"��Ŀ���������,��Ŀ����";
			String comments = request.getParameter("comments");
			if(comments!=null&&comments!=""&&comments.length()!=0&& !comments.equals("null")){
					note=note+", ��ע:"+comments;			
				}else{
					note=note+", ��ע:��";
			}
			
			String sql0="update project set PROGRESS='8', NOTE=?, CLIENT_CONFIRM_DATE=? where PROJECT_ID=?";
			String[] paras1={note, df.format(new Date()), request.getParameter("projectId")};
			sh0.update(sql0, paras1);			
			
			String sql3="insert into log (USER_ID,PROJECT_ID,DATE,PROGRESS,NOTE) values(?,?,?,'8',?)";
			String paras3[]={userId, request.getParameter("projectId"), df.format(new Date()), note};		
			sh0.update(sql3, paras3);
			
		 }else if(request.getParameter("confirm").equals("false")){
			
			String note=userId+"Ҫ��"+request.getParameter("projectId")+"��Ŀ����";
			String comments = request.getParameter("comments");
			if(comments!=null&&comments!=""&&comments.length()!=0&& !comments.equals("null")){
					note=note+", ��ע:"+comments;			
				}else{
					note=note+", ��ע:��";
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
	alert("�ɹ���");
// 	window.location.href="/MR_ST/local/local.jsp";
	if(<%=request.getParameter("confirm").equals("false")%>){
		window.location.href=encodeURI(encodeURI("/MR_ST/mail.jsp?projectId="+"<%=request.getParameter("projectId")%>"+"&sid="+"<%=sid%>"+"&toUsername="+"admin"+"&use=76"));
	}else if(<%=request.getParameter("confirm").equals("true")%>){
		window.location.href=encodeURI(encodeURI("/MR_ST/mail.jsp?projectId="+"<%=request.getParameter("projectId")%>"+"&sid="+"<%=sid%>"+"&toUsername="+"admin"+"&use=78"));
	}
	
</script>

</head>