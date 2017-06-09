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
		
		if("re".equals(request.getParameter("re"))){	//Recovery
			String note=userId+"��ԭ��"+request.getParameter("projectId")+"����Ŀ";
			String comments = request.getParameter("comments");
			if(comments!=null&&comments!=""&&comments.length()!=0&& !comments.equals("null")){
					note=note+", ��ע:"+comments;			
				}else{
					note=note+", ��ע:��";
			}
			
			//update project_sub
			String sql0="update project_sub set ABANDON='0' where SUB_PROJECT_ID=?";
			String[] paras1={request.getParameter("projectId")};
			sh0.update(sql0, paras1);			
			
			//update log
			String sql3="insert into log (USER_ID,PROJECT_ID,DATE,PROGRESS,NOTE) values(?,?,?,'111',?)";
			String paras3[]={userId, request.getParameter("projectId"), df.format(new Date()), note};		
			sh0.update(sql3, paras3);		
			
			//update project
			String sql4="update project set NOTE=? where PROJECT_ID=?";
			String paras4[]={note, request.getParameter("projectId")};		
			sh0.update(sql4, paras4);
			 
			 sh0.close();
			 
		}else{		//Abandon
			String note=userId+"������"+request.getParameter("projectId")+"����Ŀ";
			String comments = request.getParameter("comments");
			if(comments!=null&&comments!=""&&comments.length()!=0&& !comments.equals("null")){
					note=note+", ��ע:"+comments;			
				}else{
					note=note+", ��ע:��";
			}
			
			//update project_sub
			String sql0="update project_sub set ABANDON='1' where SUB_PROJECT_ID=?";
			String[] paras1={request.getParameter("projectId")};
			sh0.update(sql0, paras1);			
			
			//update log
			String sql3="insert into log (USER_ID,PROJECT_ID,DATE,PROGRESS,NOTE) values(?,?,?,'111',?)";
			String paras3[]={userId, request.getParameter("projectId"), df.format(new Date()), note};		
			sh0.update(sql3, paras3);		
			
			//update project
			String sql4="update project set NOTE=? where PROJECT_ID=?";
			String paras4[]={note, request.getParameter("projectId")};		
			sh0.update(sql4, paras4);
			 
			 sh0.close();				
			
		}
	}	
%>

<!DOCTYPE html>
<html>
<head>

 
<script type="text/javascript">
	alert("�����ɹ�");
	<%if(userType.equals("1")){ %>
	window.location.href="/MR_ST/admin/admin_proj.jsp?sid="+"<%=sid%>";
	<%}else if(userType.equals("2")){%>
	window.location.href="/MR_ST/pm/pm.jsp?sid="+"<%=sid%>";
	<%}else if(userType.equals("3")){%>
	window.location.href="/MR_ST/local/local.jsp?sid="+"<%=sid%>";
	<%}%>
</script>

</head>