<%@ page contentType="text/html;charset=GBK" import="database.SqlHelper,java.sql.*,java.io.*,java.text.*,java.util.Date"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<!DOCTYPE html>
<html>
<head>
<%
	response.setCharacterEncoding("GBK");
	String userId="";	
	String userType="";
	String userTypeName="";
	String sid = session.getId();
	String mailto = "";
	
	if(session.getAttribute("userId")!=null||session.getAttribute("userType")!=null){
		userId= (String)session.getAttribute("userId");
		userType= (String)session.getAttribute("userType");
	}
	
	if(!userType.equals("2")||!sid.equals(request.getParameter("sid"))){		
		response.sendRedirect("/MR_ST/redirect_login.jsp");
	}else{
		if(userType.equals("1"))	userTypeName="管理员"; else if(userType.equals("2"))	userTypeName="项目管理员";
		else if(userType.equals("3"))	userTypeName="当地账号";
		else if(userType.equals("4"))	userTypeName="制作人员";
		
		
		if(request.getParameter("validation").equals("true")){
			SqlHelper sh0=new SqlHelper(); 
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String note="管理员通过了该项目的材料审核";
			String comments = request.getParameter("comments");
			if(comments!=null&&comments!=""&&comments.length()!=0&& !comments.equals("null")){
				note=note+", 备注:"+comments;			
			}else{
				note=note+", 备注:无";
			}
			
			 String sql0="update project set VALIDATION='1', VALIDATION_DATE=?, PROGRESS='3',NOTE=? where PROJECT_ID=?";
			 String[] paras0={df.format(new Date()),note, request.getParameter("projectId")};
			 sh0.update(sql0, paras0);
			 
			 String sql3="insert into log (USER_ID,PROJECT_ID,DATE,PROGRESS,NOTE) values(?,?,?,'3',?)";
			String paras3[]={userId, request.getParameter("projectId"), df.format(new Date()), note};		
			sh0.update(sql3, paras3);		
		}else if(request.getParameter("validation").equals("false")){
			SqlHelper sh0=new SqlHelper(); 
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String note="该项目的材料未通过审核";
			String comments = request.getParameter("comments");
			
			if(comments!=null&&comments!=""&&comments.length()!=0&& !comments.equals("null")){
				note=note+", 备注:"+comments;			
			}else{
				note=note+", 备注:无";
			}
			
			 String sql0="update project set VALIDATION='0', VALIDATION_DATE=?, PROGRESS='1',NOTE=? where PROJECT_ID=?";
			 String[] paras0={df.format(new Date()),note, request.getParameter("projectId")};
			 sh0.update(sql0, paras0);
			 
			 String sql3="insert into log (USER_ID,PROJECT_ID,DATE,PROGRESS,NOTE) values(?,?,?,'1',?)";
			String paras3[]={userId, request.getParameter("projectId"), df.format(new Date()), note};		
			sh0.update(sql3, paras3);
			
			String sql4="select SUBMIT_BY from project where PROJECT_ID=?";
			String paras4[]={request.getParameter("projectId")};		
			ResultSet rs4 = sh0.query(sql4, paras4);
			rs4.next();
			mailto = rs4.getString(1);
		}
	}		 

			
		 		 
%> 
<script type="text/javascript">
	alert("成功！");
	
	if(<%=request.getParameter("validation").equals("false")%>){
		window.location.href=encodeURI(encodeURI("/MR_ST/mail.jsp?projectId="+"<%=request.getParameter("projectId")%>"+"&sid="+"<%=sid%>"+"&toUsername="+"<%=mailto%>"+"&use=21"));
	}else if(<%=request.getParameter("validation").equals("true")%>){
		window.location.href="/MR_ST/pm/pm.jsp";
	} 
	
</script>

</head>