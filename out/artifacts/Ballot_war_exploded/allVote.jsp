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
        <td>投票场次：<input  style="width:150px; background: none" id="BID" type="text"/>
        <input type="button" class="easyui-linkbutton" value="查看详情"  onclick="showInfo()"/></td>
    </tr>
</table>
<table title="历史投票" border="1" style="border-collapse:collapse; margin: 20px auto" id="dg">
    <tr>
        <th bgcolor="#a9a9a9">投票场次</th>
    </tr>
</table>


</body>
<script type="text/javascript">
    $(function () {
        loadlist();
    });
    function loadlist() {
        $.ajax({
            url:'http://localhost:7001/execContractMethod',
            data:JSON.stringify({
                    "name":"Ballot",
                "method":"getBallots",
                "callType":"call",
                "caller":"0xcd34d1fcc8f2284fa2af8ea18d6c7d0b60ee17f5",
                "callerPwd":"123456",
                "params":[]
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
    function showInfo() {
        var BID = $('#BID').val();
        if (!BID) {
            $.messager.alert("提示", "请输入投票场次");
            return;
        }
        var params = new Array(BID);
        $.ajax({
            url: 'http://localhost:7001/execContractMethod',
            data: JSON.stringify({
                "name": "Ballot",
                "method": "getBallotInfo",
                "callType": "call",
                "caller": "0xcd34d1fcc8f2284fa2af8ea18d6c7d0b60ee17f5",
                "callerPwd": "123456",
                "params": params
            }),
            cache: false,
            type: 'post',
            async: true,
            contentType: "application/json",
            dataType: "json",
            success: function (data) {
                var desc="发起人账户:"+data.data.starter+",\n发起人工号:"+data.data.empNo+",\n发起人姓名:"+data.data.name
                +",\n主题:"+data.data.title+",\n胜选人数:"+data.data.victorCount+",\n发起组织:"+data.data.organization
                    +",\n发起时间戳:"+data.data.createTime;
                $.messager.alert("投票场次信息", desc);
            }
        })
    }
    function showData(data){
        var str = "";
        for (var i = 0; i < data.length; i++) {
            str = "<tr><td>" + data[i] + "</td>";
            $("#dg").append(str);
        }
    }
</script>
</html>
