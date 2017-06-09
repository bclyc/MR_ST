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
	int allfinishflag=1;
	
	if(session.getAttribute("userId")!=null||session.getAttribute("userType")!=null){
		userId= (String)session.getAttribute("userId");
		userType= (String)session.getAttribute("userType");
	}
	
	if(!userType.equals("4")||!sid.equals(request.getParameter("sid"))){
		
		response.sendRedirect("/MR_ST/redirect_login.jsp");
	}else{
		if(userType.equals("1"))	userTypeName="管理员"; else if(userType.equals("2"))	userTypeName="项目管理员";
		else if(userType.equals("3"))	userTypeName="当地账号";
		else if(userType.equals("4"))	userTypeName="制作人员";
		
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SqlHelper sh0=new SqlHelper();
		String staffId = URLDecoder.decode(request.getParameter("staffId"),"UTF-8");
		
		//check if there is record in ass_filepath, if not, add an empty one
		String sql_0="select distinct ASSIGNMENT_ID from ass_filepath where ASSIGNMENT_ID=?";	
		String []paras_0={request.getParameter("assId")};
		ResultSet rs_0 = sh0.query(sql_0,paras_0);
				
		if(!rs_0.next()){
			String sql="insert into ass_filepath (ASSIGNMENT_ID,PROJECT_ID,FILE_PATH,LINKS,SUBMIT_DATE) values(?,?,?,?,?)";	
    		String []paras={request.getParameter("assId"), request.getParameter("projectId"), "", "", df.format(new Date())};
    		sh0.update(sql,paras);
		}
		
		//copy assignment id,cam number,cam note to the new record
		String sql00="select distinct ASSIGNMENT_ID,CAM_NUMBER,CAM_NOTE from assignment where PROJECT_ID=? and STAFF_ID=? and ASSIGNMENT_ID=?"; 
		String[] paras00={request.getParameter("projectId"), staffId, request.getParameter("assId")};
		ResultSet rs00=sh0.query(sql00, paras00);
		rs00.next();
		
	 	String sql0="insert into assignment (ASSIGNMENT_ID,PROJECT_ID, STAFF_ID, ASSIGNMENT_STATUS, STATUS_CHANGE_DATE,CAM_NUMBER,CAM_NOTE) values (?,?,?,?,?,?,?);";
		String[] paras0={rs00.getString(1),request.getParameter("projectId"), staffId, "2", df.format(new Date()),rs00.getString(2),rs00.getString(3)};
		sh0.update(sql0, paras0);
		
		String note=staffId+"完成了"+request.getParameter("projectId")+"子项目的任务，数量"+rs00.getString(2)+", "+rs00.getString(3);
		String comments = request.getParameter("comments");
		if(comments!=null&&comments!=""&&comments.length()!=0&& !comments.equals("null")){
			note=note+", 备注:"+comments;			
		}else{
			note=note+", 备注:无";
		}
		
		//log
		String sql3="insert into log (USER_ID,PROJECT_ID,DATE,PROGRESS,NOTE) values(?,?,?,'5',?)";
		String paras3[]={userId, request.getParameter("projectId"), df.format(new Date()), note};		
		sh0.update(sql3, paras3);
		
		//check if all staff finished the assignment
		String sql1="select distinct ASSIGNMENT_ID from assignment where PROJECT_ID=?;";
		String[] paras1={request.getParameter("projectId")};
		ResultSet rs1=sh0.query(sql1, paras1);
		
		while(rs1.next()){
			String sql11="select ASSIGNMENT_ID,STAFF_ID,ASSIGNMENT_STATUS from assignment where ASSIGNMENT_ID=? order by STATUS_CHANGE_DATE DESC;";
			String[] paras11={rs1.getString(1)};
			ResultSet rs11=sh0.query(sql11, paras11);
			rs11.next();
			
			if(!rs11.getString(3).equals("2")){
				allfinishflag=0;
			}
		}
		
		//if all staff accepts,change project progress to 6
		if(allfinishflag==1){
			String sql2="update project set PROGRESS='6', NOTE=?, FINISH_DATE=? where PROJECT_ID=?";
			String[] paras2={"所有人员完成了任务，开始审核合并", df.format(new Date()), request.getParameter("projectId")};
			sh0.update(sql2, paras2);
			
			String sql22="insert into log (USER_ID,PROJECT_ID,DATE,PROGRESS,NOTE) values(?,?,?,'6',?)";
			String paras22[]={"全部员工", request.getParameter("projectId"), df.format(new Date()), "所有人员完成了任务，开始审核合并"};		
			sh0.update(sql22, paras22);
		}
		
			
		sh0.close();				
	}
		
		 		 
%> 
<script type="text/javascript">
	alert("你的部分制作完成！");
	if(<%=allfinishflag==1%>){
		window.location.href=encodeURI(encodeURI("/MR_ST/mail.jsp?projectId="+"<%=request.getParameter("projectId")%>"+"&sid="+"<%=sid%>"+"&toUsername="+"admin"+"&use=56"));
	}else{
		window.location.href="/MR_ST/staff/staff.jsp";
	}
	
</script>

</head>