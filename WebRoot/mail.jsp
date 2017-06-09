<%@ page contentType="text/html;charset=GBK" import="java.io.*,java.util.*,javax.mail.*,database.SqlHelper,java.sql.*,java.net.URLDecoder"%>
<%@ page import="javax.mail.internet.*,javax.activation.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%
	
	String userId="";	
	String userType="";
	String userTypeName="";
	String sid = session.getId();
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
	}
	
	
	
	String result;
	
	
	String toUsername = URLDecoder.decode(request.getParameter("toUsername"), "UTF-8");	
	String projectId = request.getParameter("projectId");
	
	if(toUsername.contains(","))	toUsername=toUsername.split(",")[0];
	
	SqlHelper sh0=new SqlHelper(); 
	String sql0="select EMAIL from user where ID=?";
	String[] paras0={toUsername};
	ResultSet rs0=sh0.query(sql0, paras0);
	if(rs0.next()){
		String to =rs0.getString(1);
		
		String mailtext="";
		String mailtext2="";
		
//		String from = "bigviewservice@sina.com";			 
//		String host = "smtp.sina.com";
//		String username = "bigviewservice@sina.com";  
//		String password = "bigviewVR";

		String from = "nave@bigviewcloud.com";			 
		String host = "smtp.qq.com";
		String username = "nave@bigviewcloud.com";  
		String password = "fnonnkegktxxeahd";
		final String SSL_FACTORY = "javax.net.ssl.SSLSocketFactory";
		
		
		Properties properties = System.getProperties();
		
		
		properties.put("mail.smtp.host", host);
		properties.put("mail.smtp.auth", "true");
		//properties.put("mail.debug", "true");
		properties.put("mail.smtp.socketFactory.class", SSL_FACTORY);
		properties.put("mail.smtp.socketFactory.fallback", "false");
		properties.setProperty("mail.smtp.port", "465");
		
		
		Session mailSession = Session.getDefaultInstance(properties);
		
		  
		MimeMessage message = new MimeMessage(mailSession);
		message.setFrom(new InternetAddress(from));
		message.addRecipient(Message.RecipientType.TO,new InternetAddress(to));
		
		String mailuse=request.getParameter("use");
		//Multiple recipients
		if(mailuse.equals("56")||mailuse.equals("76")||mailuse.equals("78")||mailuse.equals("43")){
			String sql1 = "select EMAIL from user as a,project_pmanager as b,project_sub as c"+
		" where c.SUB_PROJECT_ID=? and c.MAIN_PROJECT_ID=b.PROJECT_ID and b.P_MANAGER=a.ID";
			String paras1[] = {request.getParameter("projectId")};
			ResultSet rs1 = sh0.query(sql1, paras1);
			if(rs1.next()){
				message.addRecipient(Message.RecipientType.TO,new InternetAddress(rs1.getString(1)));
			}
		}else if(request.getParameter("use").equals("75")){
			String sql1 = "select distinct ASSIGNMENT_ID from assignment where PROJECT_ID=?";
			String paras1[] = {request.getParameter("projectId")};
			ResultSet rs1 = sh0.query(sql1, paras1);
			while(rs1.next()){
				String sql2 = "select STAFF_ID from assignment where ASSIGNMENT_ID=? order by STATUS_CHANGE_DATE DESC";
				String paras2[]={rs1.getString(1)};
				ResultSet rs2 = sh0.query(sql2, paras2);
				if(rs2.next()){
					String sql3 = "select EMAIL from user where ID=?";
					String paras3[]={rs2.getString(1)};
					ResultSet rs3 = sh0.query(sql3, paras3);
					
					if(rs3.next()){
						message.addRecipient(Message.RecipientType.TO,new InternetAddress(rs3.getString(1)));
						System.out.println("Add Recipient:"+rs3.getString(1));
					}
				}
								
			}
		}else if(request.getParameter("use").equals("34")){
			toUsername = URLDecoder.decode(request.getParameter("toUsername"), "UTF-8");
			String[] users = toUsername.split(",");
			for(int i=1; i<users.length;i++){
				String sql1="select EMAIL from user where ID=?";
				String[] paras1={users[i]};
				ResultSet rs1=sh0.query(sql1, paras1);
				if(rs1.next())	message.addRecipient(Message.RecipientType.TO,new InternetAddress(rs1.getString(1)));
			}
		}
		
		//set mailtext
		String sql = "select TITLE from project where PROJECT_ID=?";
		String[] paras={projectId};
		ResultSet rs = sh0.query(sql, paras);
		
		if(rs.next()){
			mailtext="��Ŀ"+projectId+"--"+rs.getString(1)+" ";
		}		
		
		if(request.getParameter("use").equals("12")){
			mailtext=mailtext+"�Ĳ����Ѿ�����ύ����ǰ��ϵͳ��ˣ�";
		}else if(request.getParameter("use").equals("21")){
			mailtext=mailtext+"�Ĳ���δͨ����ˣ���ǰ��ϵͳ�޸ģ�";
		}else if(request.getParameter("use").equals("34")){
			mailtext=mailtext+"����������������������ǰ��ϵͳ����";
		}else if(request.getParameter("use").equals("43")){
			mailtext=mailtext+"������������䱻�ܾ�����ǰ��ϵͳ���·��䣡";
		}else if(request.getParameter("use").equals("56")){
			mailtext=mailtext+"��������������ɣ���ǰ��ϵͳ��˽����";
		}else if(request.getParameter("use").equals("65")){
			mailtext=mailtext+"���������δͨ����ˣ���ǰ��ϵͳ����������";
		}else if(request.getParameter("use").equals("67")){
			mailtext=mailtext+"����������ɣ���ǰ��ϵͳ�鿴��ȷ�Ͻ����";
		}else if(request.getParameter("use").equals("78")){
			mailtext=mailtext+"�Ľ���ѱ��ͻ�ȷ�ϣ���Ŀ������";
		}else if(request.getParameter("use").equals("75")){
			mailtext=mailtext+"�Ľ�����ͻ�Ҫ�󷵹�����ǰ��ϵͳ����������";
		}else if(request.getParameter("use").equals("75-2")){
			mailtext=mailtext+"�Ľ�����ͻ�Ҫ�󷵹����ѷ��ʼ�����������Ա��";			
		}else if(request.getParameter("use").equals("76")){
			mailtext=mailtext+"�Ľ�����ͻ�Ҫ�󷵹�����ǰ��ϵͳָ����Ա��";
		}else if(request.getParameter("use").equals("00")){
			mailtext=mailtext+"�Ĺ���ָ������������ǰ��ϵͳ�鿴��";
		}
		
		message.setSubject("Bigview������ʵ ��Ŀ"+projectId+" �����ʼ�");
		message.setText(      
		"�𾴵��û� "+",\n\n"+
		
		mailtext+"\n\n"+
		
		"ף��,\n"+
		"Bigview�ʼ����� \n\n\n"+
		
		"*���ʼ���Bigview������ʵ��Ƶ�ں���Ŀ����ϵͳ�Զ�������������¼��Ϣ����ת�����ˣ�����ֱ�ӻظ���"
		);
		     
		try{
			Transport transport = mailSession.getTransport("smtp");  
			transport.connect(host, username, password);  
			transport.sendMessage(message, message.getAllRecipients());  
			transport.close();			
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			for(int i=0;i<message.getAllRecipients().length;i++)
				System.out.println("Recipient"+i+":"+message.getAllRecipients()[i].toString());
			System.out.println("Recipient num:"+message.getAllRecipients().length);
			result = "Sent message successfully....";
			System.out.println(result);
		}
	}else{
		System.out.println("No user"+toUsername);
	}
	
   		
%>
<html>
<head>
<script type="text/javascript">
if(<%=request.getParameter("use").equals("12")%>){
	window.location.href="/MR_ST/local/local.jsp";
}else if(<%=request.getParameter("use").equals("21")%>){
	if(<%=userType.equals("1")%>)	window.location.href="/MR_ST/admin/admin_proj.jsp";
	else if(<%=userType.equals("2")%>)	window.location.href="/MR_ST/pm/pm.jsp";
}else if(<%=request.getParameter("use").equals("34")%>){
	if(<%=userType.equals("1")%>)	window.location.href="/MR_ST/admin/admin_proj.jsp";
	else if(<%=userType.equals("2")%>)	window.location.href="/MR_ST/pm/pm.jsp";
}else if(<%=request.getParameter("use").equals("43")%>){
	window.location.href="/MR_ST/staff/staff.jsp";
}else if(<%=request.getParameter("use").equals("56")%>){
	window.location.href="/MR_ST/staff/staff.jsp";
}else if(<%=request.getParameter("use").equals("65")%>){
	if(<%=userType.equals("1")%>)	window.location.href="/MR_ST/admin/admin_proj.jsp";
	else if(<%=userType.equals("2")%>)	window.location.href="/MR_ST/pm/pm.jsp";
}else if(<%=request.getParameter("use").equals("67")%>){
	if(<%=userType.equals("1")%>)	window.location.href="/MR_ST/admin/admin_proj.jsp";
	else if(<%=userType.equals("2")%>)	window.location.href="/MR_ST/pm/pm.jsp";
}else if(<%=request.getParameter("use").equals("78")%>){
	window.location.href="/MR_ST/local/local.jsp";
}else if(<%=request.getParameter("use").equals("75")%>){
	window.location.href="/MR_ST/mail.jsp?projectId="+"<%=request.getParameter("projectId")%>"+"&sid="+"<%=sid%>"+"&toUsername="+"admin"+"&use=75-2";
}else if(<%=request.getParameter("use").equals("75-2")%>){
	window.location.href="/MR_ST/local/local.jsp";
}else if(<%=request.getParameter("use").equals("76")%>){
	window.location.href="/MR_ST/local/local.jsp";
}else if(<%=request.getParameter("use").equals("00")%>){
	window.location.href="/MR_ST/admin/admin_proj.jsp";
}
</script>
</head>
<body>



</body>
</html>