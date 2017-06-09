<%@ page contentType="text/html;charset=GBK" import="database.SqlHelper,java.sql.*,java.io.*,org.apache.struts2.ServletActionContext"%><%@ taglib prefix="s" uri="/struts-tags"%><%
	String userId="";	
	String userType="";
	String userTypeName="";
	String sid = session.getId();
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
		
		
		SqlHelper sh0=new SqlHelper(); 
		 String sql0="select FILE_PATH from ass_filepath where ASSIGNMENT_ID=?";
		 String[] paras0={request.getParameter("assId")};
		 ResultSet rs0=sh0.query(sql0, paras0);
		 
		 String config_file = "";
		 if(rs0.next()){
		 	config_file =rs0.getString(1);		 	
		 }else{
		 	System.out.println("no result!!!");
		 }
		 
		 String filedownload = ""; 
    	 String filedisplay = ""; 
		 
    	 if(config_file.equals("")){
    		 
    	 }else{
    		 filedownload = config_file; 
    	    	filedisplay = config_file.substring(config_file.lastIndexOf("/")+1, config_file.length()); 
    	    	System.out.println("filedisplay:"+filedisplay);
    	    	
    			filedownload = filedownload.substring(filedownload.indexOf("MR_ST")+5);
    			filedownload = ServletActionContext.getServletContext().getRealPath(filedownload) ;
    			System.out.println("filedownload path:"+filedownload);
    			
    	    	response.addHeader("Content-Disposition","attachment;filename=" + new String( filedisplay.getBytes("gb2312"), "ISO8859-1" )); 
    	    	
    	    	java.io.OutputStream outp = null; 
    	    	java.io.FileInputStream in = null; 
    	    	try 
    	    	{
    	    		outp = response.getOutputStream(); 
    	    		in = new FileInputStream(filedownload); 
    	    		
    	    		byte[] b = new byte[1024]; 
    	    		int i = 0; 
    	    		
    	    		while((i = in.read(b)) > 0) 
    	    		{ 
    	    		outp.write(b, 0, i); 
    	    		} 
    	    		//   
    	    		outp.flush(); 
    	    		 
    	    		out.clear(); 
    	    		out = pageContext.pushBody();
    	    		response.reset(); 
    	    	} catch(Exception e)  { 
    	    	  //System.out.println("Error!"); 
    	    	  //e.printStackTrace(); 
    	    	}finally{ 
    		    	  if(in != null) 
    		    	  { 
    		    	  in.close(); 
    		    	  in = null; 
    		    	  } 
    	    	
    	    	}
    	 }
						
	}	 
%>