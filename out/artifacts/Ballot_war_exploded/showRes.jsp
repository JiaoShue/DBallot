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
</head>
<body style="overflow: hidden;">
<table id="tb" border="0" style="margin: 0 auto;width: 100%;text-align: center">
    <tr>
        <td>投票场次：<input style="width:150px; background: none;margin: 0 auto" id="ballotID" type="text"placeholder="填写投票场次查看结果"/>
        <input type="button" class="easyui-linkbutton" onclick="showRes()" value=" 查看结果"/></td>
    </tr>
</table>
<table title="候选人列表" border="1" style="border-collapse:collapse; margin: 20px auto" id="dg">
    <tr>
        <th bgcolor="#a9a9a9">候选人工号</th>
        <th bgcolor="#a9a9a9">候选人姓名</th>
        <th bgcolor="#a9a9a9">候选人得票数</th>
    </tr>
</table>
</body>
<script type="text/javascript">
    function showRes() {
        var ballotID=$('#ballotID').val();;
        if(!ballotID){
            $.messager.alert("提示","请输入投票场次");
            return;
        }
        var params=new Array(ballotID);
        $.ajax({
            url:'http://localhost:7001/execContractMethod',
            data:JSON.stringify({
                "name":"Ballot",
                "method":"getVictors",
                "callType":"call",
                "caller":"0xcd34d1fcc8f2284fa2af8ea18d6c7d0b60ee17f5",
                "callerPwd":"123456",
                "params":params
            }),
            cache:false,
            type:'post',
            async : true,
            contentType:"application/json",
            dataType:"json",
            success:function (data) {
                showData(data.data);
            }
        })
    }
    function showData(data){
        var str = "";
        for (var i = 0; i < data.victorEmpNos.length; i++) {
            str = "<tr><td>" + data.victorEmpNos[i] + "</td><td>" + data.victorNames[i] + "</td><td>" + data.victorSuports[i] + "</td></tr>";
            $("#dg").append(str);
        }
    }
</script>
</html>
