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
	String users="";
	
	if(session.getAttribute("userId")!=null||session.getAttribute("userType")!=null){
		userId= (String)session.getAttribute("userId");
		userType= (String)session.getAttribute("userType");
	}
	
	if(!userType.equals("1")||!sid.equals(request.getParameter("sid"))){		
		response.sendRedirect("/MR_ST/redirect_login.jsp");
		
	}else{
		if(userType.equals("1"))	userTypeName="����Ա"; else if(userType.equals("2"))	userTypeName="��Ŀ����Ա";
		else if(userType.equals("3"))	userTypeName="�����˺�";
		else if(userType.equals("4"))	userTypeName="������Ա";
		
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SqlHelper sh0=new SqlHelper();
		
		
		String[] assignments=request.getParameterValues("array");
		
		for(int i=0;i<assignments.length;i++){
			String userid=assignments[i].split(",")[0];
			users=users+userid+",";
			String camNum=assignments[i].split(",")[1];
			String camNote=assignments[i].split(",")[2];
			System.out.println(userid+"__"+camNum+"__"+camNote);
			
			String note="����Ա����Ŀ"+request.getParameter("projectId")+"�Ĺ����������"+userid+",��Ŀ:"+camNum+",˵��:"+camNote;
			String comments = request.getParameter("comments");
			if(comments!=null&&comments!=""&&comments.length()!=0&& !comments.equals("null")){
				note=note+", ��ע:"+comments;			
			}else{
				note=note+", ��ע:��";
			}
			
			String sql11="select ASSIGNMENT_ID from assignment ORDER BY ASSIGNMENT_ID DESC";
			ResultSet rs=sh0.query(sql11);
			
			String assid = "100000" ;
			
			if(rs.next()){
				assid = Integer.toString(rs.getInt(1)+1);
			}
			
			
			String sql0="insert into assignment (ASSIGNMENT_ID, PROJECT_ID, STAFF_ID, ASSIGNMENT_STATUS, STATUS_CHANGE_DATE, CAM_NUMBER, CAM_NOTE) values (?,?,?,?,?,?,?);";
			String[] paras0={assid, request.getParameter("projectId"), userid, "0", df.format(new Date()), camNum, camNote};
			sh0.update(sql0, paras0);
			
			String sql3="insert into log (USER_ID,PROJECT_ID,DATE,PROGRESS,NOTE) values(?,?,?,'4',?)";
			String paras3[]={userId, request.getParameter("projectId"), df.format(new Date()), note};		
			sh0.update(sql3, paras3);
		}
		users = users.substring(0,users.length()-1);
		
		String notegeneral = "����Ա����Ŀ"+request.getParameter("projectId")+"�Ĺ����������"+users;
		String sql4="update project set PROGRESS=4,ASSIGNMENT_DATE=?,NOTE=? where PROJECT_ID=?";
		String paras4[]={ df.format(new Date()), notegeneral, request.getParameter("projectId")};		
		sh0.update(sql4, paras4);
		
		
	}		 
%>
		
		 		 
 
<script type="text/javascript">
	alert("ָ���ɹ���");
	window.location.href=encodeURI(encodeURI("/MR_ST/mail.jsp?projectId="+"<%=request.getParameter("projectId")%>"+"&sid="+"<%=sid%>"+"&toUsername="+"<%=users%>"+"&use=34"));
</script>

</head>