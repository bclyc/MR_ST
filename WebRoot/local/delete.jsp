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
	
	if(!sid.equals(request.getParameter("sid"))){
		response.sendRedirect("/MR_ST/redirect_login.jsp");
	}else{
		if(userType.equals("1"))	userTypeName="����Ա"; else if(userType.equals("2"))	userTypeName="��Ŀ����Ա";
		else if(userType.equals("3"))	userTypeName="�����˺�";
		else if(userType.equals("4"))	userTypeName="������Ա";
		
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SqlHelper sh0=new SqlHelper(); 		 
		
		String note=userId+"ɾ����"+request.getParameter("projectId")+"����Ŀ";
		String comments = request.getParameter("comments");
		if(comments!=null&&comments!=""&&comments.length()!=0&& !comments.equals("null")){
				note=note+", ��ע:"+comments;			
			}else{
				note=note+", ��ע:��";
		}
		
		//update log
		String sql3="insert into log (USER_ID,PROJECT_ID,DATE,PROGRESS,NOTE) values(?,?,?,'000',?)";
		String paras3[]={userId, request.getParameter("projectId"), df.format(new Date()), note};		
		sh0.update(sql3, paras3);		
				
		//delete from  project_sub
		String sql0="delete from project_sub where SUB_PROJECT_ID=?";
		String[] paras1={request.getParameter("projectId")};
		sh0.update(sql0, paras1);			
		
		
		
// 		String sql4="delete from project where PROJECT_ID=?";
// 		String paras4[]={request.getParameter("projectId")};		
// 		sh0.update(sql4, paras4);
		
		
// 		String sql5="delete from project_filepath where PROJECT_ID=?";
// 		String paras5[]={request.getParameter("projectId")};		
// 		sh0.update(sql5, paras5);
		
		
// 		String sql6="delete from project_pmanager where PROJECT_ID=?";
// 		String paras6[]={request.getParameter("projectId")};		
// 		sh0.update(sql6, paras6);
		 
		 sh0.close();				
	}	
%>

<!DOCTYPE html>
<html>
<head>

 
<script type="text/javascript">
	alert("ɾ���ɹ�");
	
	window.location.href="/MR_ST/local/local.jsp?sid="+"<%=sid%>";
	
</script>

</head>