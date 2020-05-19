<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<% String basePath = request.getScheme() + "://" + request.getServerName() + ":"
        + request.getServerPort() + request.getContextPath() + "/"; %>

<!Doctype html>
<html>
<head>
    <base href="<%=basePath%>">
    <title>去中心化投票系统</title>
    <meta charset="utf-8">

    <script src="static/js/jquery-1.11.1.min.js"></script>
    <link href="static/css/style.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" type="text/css" href="static/jquery-easyui-1.5.4.2/themes/bootstrap/easyui.css">
    <link rel="stylesheet" type="text/css" href="static/jquery-easyui-1.5.4.2/themes/icon.css">
    <script type="text/javascript" src="static/jquery-easyui-1.5.4.2/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="static/js/sha256.js"></script>
</head>
<body style="background: #607d8b4f;">
<div style="position: fixed;top:5%;left:31%">
    <div class="easyui-panel" title="获取手续费" style="width:400px;padding:30px 70px 20px 70px;">
        <div style="margin-bottom:10px">
            <input class="easyui-textbox" style="width:55%;height:40px;padding:12px"  id="account" data-options="prompt:'请输入用户ID'" />
            <a onclick="getFee()" class="easyui-linkbutton" style="padding:5px auto;float: right; height:40px;width:43%;">
                <span style="font-size:14px;">获取手续费</span>
            </a>
        </div>
    </div>
</div>
</body>
<script type="text/javascript">
    function getFee() {
        var account=$('#account').val();
        var reqUrl='http://localhost:7001/sendTransaction';
        if(!account){
            $.messager.alert('申请提示','账号不能为空');
            return;
        }
        $.ajax({
            url : reqUrl,
            cache : false,
            type : 'post',
            data:JSON.stringify({
                "sourceAccount":"0xcd34d1fcc8f2284fa2af8ea18d6c7d0b60ee17f5",
                "txPassword":"123456",
                "distAccount":account,
                "amount":"10000",
                "data":"0x01"}),
            async : true,
            contentType:"application/json",
            dataType : "json",
            success : function(result) {
                if (result.status=="success") {
                    $.messager.alert('申请提示',"申请成功！");
                }else {
                    $.messager.alert('申请提示','申请失败，'+'\n错误码'+result.status+'！');
                }
            },
            error: function(err){
                $.messager.alert('申请提示',"申请异常"+err.state());
            }
        });
    }
</script>
</html>
