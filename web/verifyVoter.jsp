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
        <td>投票发起人：<input  style="width:150px; background: none" id="starterID" type="text" placeholder="审核时填写"/>
        交易密码：<input  style="width:150px; background: none" id="password" type="password"placeholder="审核时填写"/>
        投票人：<input  style="width:150px; background: none" id="voterID" type="text"placeholder="查看简介填写,审核时提交数组"/>
        权重：<input  style="width:150px; background: none" id="weight" type="text"placeholder="查看简介填写,审核时提交数组"/>
        <input type="button" class="easyui-linkbutton" onclick="Pass()" value="通过审核" />
        <input type="button" class="easyui-linkbutton" onclick="view()"value="查看详细信息"></td>
    </tr>
</table>
<table title="投票人列表" border="1" style="border-collapse:collapse; margin: 20px auto" id="dg">
    <tr>
        <th bgcolor="#a9a9a9">投票人区块链账户</th>
        <th bgcolor="#a9a9a9">投票人工号</th>
        <th bgcolor="#a9a9a9">投票人姓名</th>
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
                "method":"getVoters",
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

    function Pass() {
        var starterID=$('#starterID').val();;
        if(!starterID){
            $.messager.alert("提示","请输入投票人账号");
            return;
        }
        var voterIDs=eval($('#voterID').val());
        if(!voterIDs){
            $.messager.alert("提示","请输入账户数组");
            return;
        }
        var password=$('#password').val();;
        if(!password){
            $.messager.alert("提示","请输入交易密码");
            return;
        }
        var weight=$('#weight').val();;
        if(!weight){
            $.messager.alert("提示","请输入投票权重");
            return;
        }
        var params=new Array(weight,voterIDs);
        $.ajax({
            url : 'http://localhost:7001/execContractMethod',
            cache: false,
            type : 'post',
            data:JSON.stringify({
                "name":"Ballot",
                "method":"checkVoter",
                "callType":"send",
                "caller":starterID,
                "callerPwd":password,
                "params":params
            }),
            async : true,
            contentType:"application/json",
            dataType : "json",
            success : function(result) {
                if(result.status=="success"){
                    $.messager.alert('审核操作',result.data.events.logcheckVoter.returnValues["0"]);
                }else{
                    $.messager.alert('审核操作','审核失败，'+result.status);
                }
            }
        })
    }
    function view() {
        var voterID=$('#voterID').val();;
        if(!voterID){
            $.messager.alert("提示","请输入投票人账号");
            return;
        }
        var params=new Array(voterID);
        $.ajax({
            url : 'http://localhost:7001/execContractMethod',
            cache: false,
            type : 'post',
            data:JSON.stringify({
                "name":"Ballot",
                "method":"getVoterInfo",
                "callType":"call",
                "caller":"0xcd34d1fcc8f2284fa2af8ea18d6c7d0b60ee17f5",
                "callerPwd":"123456",
                "params":params
            }),
            async : true,
            contentType:"application/json",
            dataType : "json",
            success : function(data) {
                if(data.status=="success"){
                    var desc="投票人工号:"+data.data.empNo+",\n投票人姓名:"+data.data.name
                        +",\n投票人投票场次:"+data.data.ballotID+",\n投票人组织:"+data.data.organization
                        +",\n投票权重:"+data.data.weight;
                    $.messager.alert("投票人信息", desc);
                }else{
                    $.messager.alert('查看操作','查看失败，'+data.status);
                }
            }
        })
    }
    function showData(data){
        var str = "";
        for (var i = 0; i < data.voters.length; i++) {
            str = "<tr><td>" + data.voters[i] + "</td><td>" + data.voterEmpNos[i] + "</td><td>" + data.voterNames[i] + "</td></tr>";
            $("#dg").append(str);
        }
    }
</script>
</html>
