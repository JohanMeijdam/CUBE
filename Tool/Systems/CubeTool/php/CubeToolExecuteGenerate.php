<?php
session_start();
$_SESSION['views']=0;
?><html>
<head>
<link rel="stylesheet" href="base_css.php" />
<!--

-->
</script>
</head><body oncontextmenu="return false;" onload="InitBody()" onbeforeunload="return parent.CheckChangePending()" ondrop="Drop(event)" ondragover="AllowDrop(event)">
<div><img src="icons/service_large.bmp" /><span> <SERVICE:U>>
<tr><td><br></td><td style="width:100%"></td></tr>
<tr><td/><td>
<button id="ButtonExec" type="button" disabled>Execute</button>&nbsp;&nbsp;&nbsp;
<button id="ButtonCancel" type="button" disabled onclick="CancelExecution()">Cancel</button></td></tr>
</table>
</body>
</html>
