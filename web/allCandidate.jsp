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
        <td>投票人：<input  style="width:150px; background: none" id="voterID" type="text" placeholder="投票填写"/>
        交易密码：<input  style="width:150px; background: none" id="password" type="password"placeholder="投票填写"/>
        候选人：<input  style="width:150px; background: none" id="candidateID" type="text"placeholder="查看简介填写"/>
        投票场次：<input  style="width:150px; background: none" id="ballotID" type="text"placeholder="投票填写"/>
        <input type="button" class="easyui-linkbutton" onclick="vote()" value="支持" />
        <input type="button" class="easyui-linkbutton" onclick="view()"value="查看简介"></td>
    </tr>
</table>
<table title="候选人列表" border="1" style="border-collapse:collapse; margin: 20px auto" id="dg">
    <tr>
        <th bgcolor="#a9a9a9">候选人区块链账户</th>
        <th bgcolor="#a9a9a9">候选人工号</th>
        <th bgcolor="#a9a9a9">候选人姓名</th>
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
                "method":"getCandidates",
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

    function vote() {
        var voterID=$('#voterID').val();;
        if(!voterID){
            $.messager.alert("提示","请输入投票人账号");
            return;
        }
        var candidateID=$('#candidateID').val();;
        if(!candidateID){
            $.messager.alert("提示","请输入候选人账号");
            return;
        }
        var password=$('#password').val();;
        if(!password){
            $.messager.alert("提示","请输入交易密码");
            return;
        }
        var ballotID=$('#ballotID').val();;
        if(!ballotID){
            $.messager.alert("提示","请输入投票场次");
            return;
        }
        var params=new Array(voterID,candidateID,ballotID);
        $.ajax({
            url : 'http://localhost:7001/execContractMethod',
            cache: false,
            type : 'post',
            data:JSON.stringify({
                "name":"Ballot",
                "method":"vote",
                "callType":"send",
                "caller":voterID,
                "callerPwd":password,
                "params":params
            }),
            async : true,
            contentType:"application/json",
            dataType : "json",
            success : function(result) {
                if(result.status=="success"){
                    $.messager.alert('投票操作',result.data.events.logvote.returnValues["0"]);
                }else{
                    $.messager.alert('投票操作','投票失败，'+result.status);
                }
            }
        })
    }
    function view() {
        var candidateID=$('#candidateID').val();
        if(!candidateID){
            $.messager.alert("提示","请输入候选人账号");
            return;
        }
        var params=new Array(candidateID);
        $.ajax({
            url : 'http://localhost:7001/execContractMethod',
            cache: false,
            type : 'post',
            data:JSON.stringify({
                "name":"Ballot",
                "method":"getCandidateInfo",
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
                    var desc="候选人工号:"+data.data.empNo+",\n候选人姓名:"+data.data.name
                        +",\n候选人投票场次:"+data.data.ballotID+",\n候选人自我介绍:"+data.data.describe+",\n候选人组织:"+data.data.organization
                        +",\n候选资格:"+data.data.canBeVote;
                    $.messager.alert("候选人信息", desc);
                }else{
                    $.messager.alert('查看操作','查看失败，'+data.status);
                }
            }
        })
    }
    function showData(data){
        var str = "";
        for (var i = 0; i < data.candidates.length; i++) {
            str = "<tr><td>" + data.candidates[i] + "</td><td>" + data.candidateEmpNos[i] + "</td><td>" + data.candidateNames[i] + "</td></tr>";
            $("#dg").append(str);
        }
    }
</script>
</html>
