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
	String mailto = "";
	
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
		
		
		if(request.getParameter("validation").equals("true")){
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SqlHelper sh0=new SqlHelper(); 
			
			String note="管理员审核通过了该项目的制作结果审核和合并";
			String comments = request.getParameter("comments");
			if(comments!=null&&comments!=""&&comments.length()!=0&& !comments.equals("null")){
					note=note+", 备注:"+comments;			
				}else{
					note=note+", 备注:无";
			}
				
			 String sql0="update project set PROGRESS='7',NOTE=?,RESULT_VALIDATION_DATE=? where PROJECT_ID=?";
			 String[] paras0={note, df.format(new Date()), request.getParameter("projectId")};
			 sh0.update(sql0, paras0);
			 
			 String sql3="insert into log (USER_ID,PROJECT_ID,DATE,PROGRESS,NOTE) values(?,?,?,'7',?)";
			String paras3[]={userId, request.getParameter("projectId"), df.format(new Date()), note};		
			sh0.update(sql3, paras3);
			
			String sql5="select SUBMIT_BY from project where PROJECT_ID=?";
			String paras5[]={request.getParameter("projectId")};		
			ResultSet rs5 = sh0.query(sql5, paras5);
			rs5.next();
			mailto = rs5.getString(1);	
		}else if(request.getParameter("validation").equals("false")){
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SqlHelper sh0=new SqlHelper(); 
			
			
			String assId=request.getParameter("assId");
			
			//look up ass info
			String sql00="select PROJECT_ID,STAFF_ID,CAM_NUMBER,CAM_NOTE from assignment where ASSIGNMENT_ID=? order by STATUS_CHANGE_DATE DESC";
			String[] paras00={assId};
			ResultSet rs00=sh0.query(sql00,paras00);
			rs00.next();
			
			String note="管理员要求该项目的制作人员返工";
			String comments = request.getParameter("comments");
			if(comments!=null&&comments!=""&&comments.length()!=0&& !comments.equals("null")){
					note=note+", 备注:"+comments;			
				}else{
					note=note+", 备注:无";
				}
			
			//insert into assignment
			String sql000="insert into assignment (ASSIGNMENT_ID,PROJECT_ID,STAFF_ID,ASSIGNMENT_STATUS,STATUS_CHANGE_DATE,CAM_NUMBER,CAM_NOTE) values(?,?,?,?,?,?,?)";
			String[] paras000={assId, rs00.getString(1), rs00.getString(2), "3", df.format(new Date()), rs00.getString(3), rs00.getString(4)};
			sh0.update(sql000, paras000);
			
			//update project
			String sql0="update project set NOTE=? where PROJECT_ID=?";
			String[] paras0={note,  rs00.getString(1)};
			sh0.update(sql0, paras0);
			
			//insert into log
			String sql3="insert into log (USER_ID,PROJECT_ID,DATE,PROGRESS,NOTE) values(?,?,?,'6',?)";
			String paras3[]={userId, rs00.getString(1), df.format(new Date()), note};		
			sh0.update(sql3, paras3);
			
			
			mailto = rs00.getString(2);
			
		}
					
	}		 

			
		 		 
%> 
<script type="text/javascript">
	alert("成功！");
	if(<%=request.getParameter("validation").equals("false")%>){
		window.location.href=encodeURI(encodeURI("/MR_ST/mail.jsp?projectId="+"<%=request.getParameter("projectId")%>"+"&sid="+"<%=sid%>"+"&toUsername="+"<%=mailto%>"+"&use=65"));
	}else if(<%=request.getParameter("validation").equals("true")%>){
		window.location.href=encodeURI(encodeURI("/MR_ST/mail.jsp?projectId="+"<%=request.getParameter("projectId")%>"+"&sid="+"<%=sid%>"+"&toUsername="+"<%=mailto%>"+"&use=67"));
	}

</script>

</head>