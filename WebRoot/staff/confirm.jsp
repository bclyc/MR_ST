<%@ page contentType="text/html;charset=GBK" import="database.SqlHelper,java.sql.*,java.io.*,java.text.*,java.util.Date,java.net.URLDecoder"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%
	String userId="";	
	String userType="";
	String userTypeName="";
	String sid = session.getId();	
	
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
		 System.out.println("staffId:"+staffId);
		 if(request.getParameter("confirm").equals("A")){
			 //copy assignment id,cam number,cam note to the new record
			String sql00="select distinct ASSIGNMENT_ID,CAM_NUMBER,CAM_NOTE from assignment where PROJECT_ID=? and STAFF_ID=? and ASSIGNMENT_ID=?"; 
			String[] paras00={request.getParameter("projectId"), staffId, request.getParameter("assId")};
			ResultSet rs00=sh0.query(sql00, paras00);
			if(rs00.next()){

			 	String sql0="insert into assignment (ASSIGNMENT_ID,PROJECT_ID, STAFF_ID, ASSIGNMENT_STATUS, STATUS_CHANGE_DATE,CAM_NUMBER,CAM_NOTE) values (?,?,?,?,?,?,?);";
				String[] paras0={rs00.getString(1),request.getParameter("projectId"), staffId, "1", df.format(new Date()),rs00.getString(2),rs00.getString(3)};
				sh0.update(sql0, paras0);
				
				String note=staffId+"接受了"+request.getParameter("projectId")+"子项目的任务分配，数量"+rs00.getString(2)+", "+rs00.getString(3);
				String comments = request.getParameter("comments");
				if(comments!=null&&comments!=""&&comments.length()!=0&& !comments.equals("null")){
					note=note+", 备注:"+comments;			
				}else{
					note=note+", 备注:无";
				}
				
				//log
				String sql3="insert into log (USER_ID,PROJECT_ID,DATE,PROGRESS,NOTE) values(?,?,?,'4',?)";
				String paras3[]={userId, request.getParameter("projectId"), df.format(new Date()), note};		
				sh0.update(sql3, paras3);
				
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
					
					if(!rs11.getString(3).equals("1")){
						allacceptflag=0;
					}
				}
				
				//if all staff accepts,change project progress to 5
				if(allacceptflag==1){
					String sql2="update project set PROGRESS='5', NOTE=?, START_DATE=? where PROJECT_ID=?";
					String[] paras2={"所有人员接受了任务，开始制作", df.format(new Date()), request.getParameter("projectId")};
					sh0.update(sql2, paras2);
					
					String sql22="insert into log (USER_ID,PROJECT_ID,DATE,PROGRESS,NOTE) values(?,?,?,'5',?)";
					String paras22[]={"全部员工", request.getParameter("projectId"), df.format(new Date()), "所有人员接受了任务，开始制作"};
					sh0.update(sql22, paras22);
				}
			}			
								
			
		 }else if(request.getParameter("confirm").equals("R")){
			//copy assignment id,cam number,cam note to the new record
			String sql00="select distinct ASSIGNMENT_ID,CAM_NUMBER,CAM_NOTE from assignment where PROJECT_ID=? and STAFF_ID=? and ASSIGNMENT_ID=?"; 
			String[] paras00={request.getParameter("projectId"), staffId, request.getParameter("assId")};
			ResultSet rs00=sh0.query(sql00, paras00);
			if(rs00.next()){
				
				String sql0="insert into assignment (ASSIGNMENT_ID,PROJECT_ID, STAFF_ID, ASSIGNMENT_STATUS, STATUS_CHANGE_DATE,CAM_NUMBER,CAM_NOTE) values (?,?,?,?,?,?,?);";
				String[] paras0={rs00.getString(1),request.getParameter("projectId"), staffId, "-1", df.format(new Date()),rs00.getString(2),rs00.getString(3)};
				sh0.update(sql0, paras0);
				
				String note="待重新分配："+staffId+"拒绝了"+request.getParameter("projectId")+"项目的任务分配，数量"+rs00.getString(2)+", "+rs00.getString(3);
				String comments = request.getParameter("comments");
				if(comments!=null&&comments!=""&&comments.length()!=0&& !comments.equals("null")){
					note=note+", 备注:"+comments;			
				}else{
					note=note+", 备注:无";
				}
				
				//log
				String sql3="insert into log (USER_ID,PROJECT_ID,DATE,PROGRESS,NOTE) values(?,?,?,'4',?)";
				String paras3[]={userId, request.getParameter("projectId"), df.format(new Date()), note};		
				sh0.update(sql3, paras3);
				
				//project
				String sql2="update project set NOTE=? where PROJECT_ID=?";
				String[] paras2={note, request.getParameter("projectId")};
				sh0.update(sql2, paras2);
				
			 }
			 
			 sh0.close();
			}
							
	}	
%>

<!DOCTYPE html>
<html>
<head>

 
<script type="text/javascript">
	alert("成功！");
	if(<%=request.getParameter("confirm").equals("R")%>){
		window.location.href=encodeURI(encodeURI("/MR_ST/mail.jsp?projectId="+"<%=request.getParameter("projectId")%>"+"&sid="+"<%=sid%>"+"&toUsername="+"admin"+"&use=43"));
	}else if(<%=request.getParameter("confirm").equals("A")%>){
		window.location.href="/MR_ST/staff/staff.jsp";
	} 
	
</script>

</head>