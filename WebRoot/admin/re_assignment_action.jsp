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
	String staffId=URLDecoder.decode(request.getParameter("staffId"),"UTF-8");
	
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
		
		String projectId=request.getParameter("projectId");
		String assId=request.getParameter("assId");
		
		
		String sql00="select CAM_NUMBER,CAM_NOTE,STAFF_ID from assignment where ASSIGNMENT_ID=? order by STATUS_CHANGE_DATE DESC";
		String[] paras00={assId};
		ResultSet rs00=sh0.query(sql00,paras00);
		rs00.next();
		
		String camNum=rs00.getString(1);
		String camNote=rs00.getString(2);
		String oldstaff=rs00.getString(3);
		
		String note="管理员将项目"+projectId+"的部分工作重新指定给了"+staffId+",数目:"+camNum+",说明:"+camNote;
		String comments = request.getParameter("comments");
		if(comments!=null&&comments!=""&&comments.length()!=0&& !comments.equals("null")){
			note=note+", 备注:"+comments;			
		}else{
			note=note+", 备注:无";
		}
		
		//assignment table
		String sql0="insert into assignment (ASSIGNMENT_ID, PROJECT_ID, STAFF_ID, ASSIGNMENT_STATUS, STATUS_CHANGE_DATE, CAM_NUMBER, CAM_NOTE) values (?,?,?,?,?,?,?);";
		String[] paras0={assId, projectId, oldstaff, "-1", df.format(new Date()), camNum, camNote};
		sh0.update(sql0, paras0);
		
		Date d=new Date();
		String sql0000="insert into assignment (ASSIGNMENT_ID, PROJECT_ID, STAFF_ID, ASSIGNMENT_STATUS, STATUS_CHANGE_DATE, CAM_NUMBER, CAM_NOTE) values (?,?,?,?,?,?,?);";
		String[] paras0000={assId, projectId, staffId, "1", df.format(new Date(d.getTime() + 1000)), camNum, camNote};
		sh0.update(sql0000, paras0000);
		
		//log table
		String sql3="insert into log (USER_ID,PROJECT_ID,DATE,PROGRESS,NOTE) values(?,?,?,'88',?)";
		String paras3[]={userId, request.getParameter("projectId"), df.format(new Date()), note};		
		sh0.update(sql3, paras3);
		
		//project table
		//String notegeneral = "管理员将项目"+request.getParameter("projectId")+"的工作分配给了"+users;
		String sql4="update project set NOTE=? where PROJECT_ID=?";
		String paras4[]={ note, projectId};		
		sh0.update(sql4, paras4);
		
		//check if all staff accepts the assignment
		String sql1="select distinct ASSIGNMENT_ID from assignment where PROJECT_ID=?;";
		String[] paras1={request.getParameter("projectId")};
		ResultSet rs1=sh0.query(sql1, paras1);
		int allacceptflag=1;
		while(rs1.next()){
			String sql11="select ASSIGNMENT_ID,STAFF_ID,ASSIGNMENT_STATUS from assignment where ASSIGNMENT_ID=? order by STATUS_CHANGE_DATE DESC;";
			String[] paras11={rs1.getString(1)};
			ResultSet rs11=sh0.query(sql11, paras11);
			rs11.next();
			
			if(!rs11.getString(3).equals("1")&&!rs11.getString(3).equals("2")){
				allacceptflag=0;
			}
		}
		
		//if all staff accepts,change project progress to 5
		if(allacceptflag==1){
			String sql2="update project set PROGRESS='5', NOTE=?, START_DATE=? where PROJECT_ID=?";
			String[] paras2={"所有人员接受了任务，开始制作", df.format(new Date()), request.getParameter("projectId")};
			sh0.update(sql2, paras2);
		}
		
		
	}		 
%>
		
		 		 
 
<script type="text/javascript">
	alert("指定成功！");	
	window.location.href=encodeURI(encodeURI("/MR_ST/mail.jsp?projectId="+"<%=request.getParameter("projectId")%>"+"&sid="+"<%=sid%>"+"&toUsername="+"<%=staffId%>"+"&use=34"));
</script>

</head>