<%@ page contentType="text/html;charset=GBK"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<!DOCTYPE html>
<html>
<head>
<title>�ϴ�padfile</title>

<script type="text/javascript">

</script> 

  

</head>

<body>


<form action="STMarkUpload" method="post" enctype="multipart/form-data">         
                          
    <input type="file" name="upload" /> <br>                
      
    <input class="btn" type="submit" value='�ύ'/>           
    
    <input type="hidden" name="username" value="padtest">
    <input type="hidden" name="password" value="padtest">
    <input type="hidden" name="use" value="mark">
</form> 
<s:fielderror/>

<script type="text/javascript">

</script>    

</body>
</html>