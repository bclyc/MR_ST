<%@ page contentType="text/html;charset=GBK" import="java.io.*,java.util.*,javax.mail.*,database.SqlHelper,java.sql.*,javax.mail.internet.*,javax.activation.*,java.text.SimpleDateFormat"%>
<%
String resetType = request.getParameter("reset_type");
String sid = request.getParameter("sid");

String publicIP = "101.200.218.244";

if(resetType.equals("F_PW")){
	

	String to = request.getParameter("email");
	String user_id = "";

	SimpleDateFormat df = new SimpleDateFormat("yyyyMMddHHmmss");
	SqlHelper sh0=new SqlHelper();
	String sql="select ID from user where EMAIL=?";
	String[] paras={to};
	ResultSet rs=sh0.query(sql, paras);
	if(!rs.next()){
		System.out.println("redi");
		
		RequestDispatcher rd;
       	rd = getServletContext().getRequestDispatcher("/reset/forget_pw.jsp");
       	request.setAttribute("message", "������û�а��κ��˺ţ�");
       	rd.forward(request,response);		
		
	}else{
		
		user_id = rs.getString(1);
		String sidstring = sid+resetType+df.format(new java.util.Date());
		
		String sql0="insert into reset (SID_STRING,RESET_TYPE,USER_ID,DONE) values(?,?,?,'0')";
		String[] paras0={sidstring,resetType,user_id};
		sh0.update(sql0, paras0);
		
		
		
		String result;
//  		String from = "bigviewservice@sina.com";			 
// 		String host = "smtp.sina.com";
// 		String username = "bigviewservice@sina.com";  
// 		String password = "bigviewVR";

		String from = "work@bigviewcloud.com";			 
		String host = "smtp.mxhichina.com";
		String username = "work@bigviewcloud.com";  
		String password = "5tgb6YHN";
		
		Properties properties = System.getProperties();
		
		properties.put("mail.smtp.host", host);
		properties.put("mail.smtp.auth", "true");
		properties.put("mail.debug", "true");
		properties.setProperty("mail.smtp.port", "25");
		
		Session mailSession = Session.getDefaultInstance(properties);
		
		  
		MimeMessage message = new MimeMessage(mailSession);
		message.setFrom(new InternetAddress(from));
		message.addRecipient(Message.RecipientType.TO,new InternetAddress(to));
		
		message.setSubject("Bigview������ʵ  ���������ʼ�");
		message.setText(      
		"�𾴵��û� "+",\n\n"+
		
		"���������������룬���ʴ��������ã� http://"+publicIP+"/MR_ST/reset/reset_pw.jsp?sidstring="+sidstring+" \n\n"+
		
		"ף��,\n"+
		"Bigview�ʼ����� \n\n\n"+
		
		"*���ʼ���Bigview������ʵ��Ƶ�ں���Ŀ����ϵͳ�Զ�������������¼��Ϣ����ת�����ˣ�����ֱ�ӻظ���"
		);
		
		Transport transport = mailSession.getTransport("smtp");  
		transport.connect(host, username, password);  
		transport.sendMessage(message, message.getAllRecipients());  
		transport.close();
		
		System.out.println(message.getAllRecipients());
		System.out.println(message.getAllRecipients().length);
		result = "Sent message successfully....";
		System.out.println(result);
	}	 
	
}else if(resetType.equals("CH_EM")){

	String to = request.getParameter("email");
	String user_id = request.getParameter("user_id");

	SimpleDateFormat df = new SimpleDateFormat("yyyyMMddHHmmss");
	SqlHelper sh0=new SqlHelper();
	String sql="select ID from user where EMAIL=?";
	String[] paras={to};
	ResultSet rs=sh0.query(sql, paras);
	if(rs.next()){
		System.out.println("redi");
		
		RequestDispatcher rd;
       	rd = getServletContext().getRequestDispatcher("/reset/change_email.jsp?sid="+session.getId());
       	request.setAttribute("message", "�������ѱ��󶨣�");
       	rd.forward(request,response);		
		
	}else{
		
		String sidstring = sid+resetType+df.format(new java.util.Date());
		
		String sql0="insert into reset (SID_STRING,RESET_TYPE,USER_ID,DONE,NEW_EMAIL) values(?,?,?,'0',?)";
		String[] paras0={sidstring,resetType,user_id,to};
		sh0.update(sql0, paras0);
		
		
		
		String result;
//		String from = "bigviewservice@sina.com";			 
//		String host = "smtp.sina.com";
//		String username = "bigviewservice@sina.com";  
//		String password = "bigviewVR";

		String from = "work@bigviewcloud.com";			 
		String host = "smtp.mxhichina.com";
		String username = "work@bigviewcloud.com";  
		String password = "5tgb6YHN";
		
		Properties properties = System.getProperties();
		
		properties.put("mail.smtp.host", host);
		properties.put("mail.smtp.auth", "true");
		properties.put("mail.debug", "true");
		properties.setProperty("mail.smtp.port", "25");
		
		Session mailSession = Session.getDefaultInstance(properties);
		
		  
		MimeMessage message = new MimeMessage(mailSession);
		message.setFrom(new InternetAddress(from));
		message.addRecipient(Message.RecipientType.TO,new InternetAddress(to));
		
		message.setSubject("Bigview������ʵ  ������ʼ�");
		message.setText(      
		"�𾴵��û� "+user_id+",\n\n"+
		
		"�������˰󶨸����䣬���ʴ�������Ч�� http://"+publicIP+"/MR_ST/reset/change_email_action.jsp?sidstring="+sidstring+" \n\n"+
		
		"ף��,\n"+
		"Bigview�ʼ����� \n\n\n"+
		
		"*���ʼ���Bigview������ʵ��Ƶ�ں���Ŀ����ϵͳ�Զ�������������¼��Ϣ����ת�����ˣ�����ֱ�ӻظ���"
		);
		
		Transport transport = mailSession.getTransport("smtp");  
		transport.connect(host, username, password);  
		transport.sendMessage(message, message.getAllRecipients());  
		transport.close();
		
		System.out.println(message.getAllRecipients());
		System.out.println(message.getAllRecipients().length);
		result = "Sent message successfully....";
		System.out.println(result);
	}
}
%>



<!DOCTYPE html>
<html>
<head>

 
<script type="text/javascript">
	alert("���ͳɹ���");
	if(<%=resetType.equals("F_PW")%>){window.location.href="/MR_ST/login.jsp";	}
	else if(<%=resetType.equals("CH_EM")%>){window.location.href="/MR_ST/reset/change_email.jsp?sid=<%=sid%>";	}
	
</script>

</head>