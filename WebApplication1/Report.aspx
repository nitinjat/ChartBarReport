<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Report.aspx.cs" Inherits="WebApplication1.Report" MasterPageFile="~/mstr.Master" %>

<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>


<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="scripts/jquery-ui-1.8.11.min.js"></script>
    <!-- Custom styles for this template-->
    <link href="css/sb-admin-2.min.css" rel="stylesheet" type="text/css" />
    <script src="scripts/jquery-ui.min.js"></script>
    <link href="datetimepicker-master/jquery.datetimepicker.css" rel="stylesheet" />
    <script src="datetimepicker-master/build/jquery.datetimepicker.full.min.js"></script>
    <link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i" rel="stylesheet" />
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.3/Chart.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#from_dt_picker').datetimepicker(
                {
                    format: 'mm/dd/yyyy'


                });
            $('#ContentPlaceHolder1_from_dt_picker').datepicker('setDate', 'today');

            $('#todt_toggle').datetimepicker(
                {
                    format: 'mm/dd/yyyy',
                    startDate: '-3d'
                });
            $('#todt_toggle').datepicker('setDate', 'today');;
        });
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            
            //var val =  document.getElementById('hdnval');
           // console.log(val);
            if ('False' === '<%= Page.IsPostBack.ToString()%>') {
              
                var data = getData();
            }
            
        });
        function validate()
        {
            //debugger;
            //var fromdt = document.getElementById("ContentPlaceHolder1_from_dt_picker");
            //var fromdt1 = $("#ContentPlaceHolder1_from_dt_picker").datepicker().val();
            //var fromd2t = $("#ContentPlaceHolder1_from_dt_picker").val();
            //if (fromdt == null || fromdt == "undefined")
            //{
            //    var val = "Please select from Date";
            //    $('#fromdt').val("Please select from Date")
            //}
        }
        function getData() {


            $.ajax({
                type: "POST",
                url: "Report.aspx/SelectData",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (data) {
                    //var data1 = JSON.stringify(data);
                    //var data2 = JSON.parse(data1);   
                    Fillchart(data.d);
                    //$.each(data.d, function (index, value) {                     
                    //    countValue[index] = value;
                    //    countValue.push(val.UserCount);
                    //});
                },
                error: function (response) {
                    swal(response.error.text);
                }

            });
        }

        function Fillchart(chartdata) {
            debugger;
            var ctx = document.getElementById("myAreaChart").getContext('2d');
            console.log(chartdata);
            var myChart = new Chart(ctx,
                {
                    type: 'bar',
                    data: {
                        labels: chartdata.WeekDays, // here i want to show my date value
                        datasets: [
                            {
                                label: 'Active User in week days',
                                data: chartdata.UserCount, // here show my total count date wise 
                                backgroundColor: "rgba(153,255,51,1)"
                            }
                        ]
                    }
                });
        }
    </script>
    <style>
        .Grid {
            background-color: #fff;
            margin: 5px 0 10px 0;
            border: solid 1px #525252;
            border-collapse: collapse;
            font-family: Calibri;
            color: #474747;
            text-align: center;
            width: 350px;
        }

        td.HeaderStyle1 {
            text-decoration: none;
            color: #ffffff;
            font-weight: bold;
            font-size: 12px;
            height: 30px;
            border: 0px;
        }
    </style>
    <div id="wrapper">
        <!-- Content Wrapper -->
        <div id="content-wrapper" class="d-flex flex-column">
            <!-- Main Content -->
            <div id="content">

                <!-- Begin Page Content -->
                <div class="container-fluid">
                    <!-- Page Heading -->
                    <div class="d-sm-flex align-items-center justify-content-between mb-4">
                        <h1 class="h3 mb-0 text-gray-800"style="font-family:Calibri">Users Active Report in Week</h1>
                    </div>
                    <!-- Content Row -->
                    <div class="row">
                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card border-left-primary shadow h-100 py-2">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Total Active User in week</div>
                                            <div class="h5 mb-0 font-weight-bold text-gray-800" id="Div_LiveUser">
                                                <label id="lblcount" runat="server"></label>
                                            </div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="fa fa-user-circle fa-2x text-gray-300"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-2">
                            <div class="form-group">
                                <label>From Date</label>
                                <div class="input-group date">
                                    <input type="date" class="form-control" id="from_dt_picker" name="fromdt_picker" runat="server"  />
                                </div>
                                 <asp:label id="fromdt" runat="server" visible="false"></asp:label>
                            </div>
                        </div>

                        <div class="col-md-2">
                            <div class="form-group">
                                <label>To Date</label>
                                <div class="input-group date">
                                    <input type="date" class="form-control" id="to_dt_picker" name="to_dt_picker" runat="server"   />
                                </div>
                                <asp:label id="todt" runat="server" visible="false"></asp:label>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label></label>
                                <div class="input-group-prepend">
                                    <%--<button type="button" id="btnsubmit" class="btn-primary btn" value="Reset" ></button>--%>
                                    <asp:Button Text="Reset" class="btn-primary btn" runat="server" OnClientClick="validate();" OnClick="PopulateChart" Style="width: 91px; height: 34px; margin-top: 8px;" />
                                    <asp:HiddenField ID="hdnval" runat="server" ClientIDMode="Static" Value="0" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <!-- Area Chart -->
                        <div class="col-xl-8 col-lg-7">
                            <div class="card shadow mb-4">
                                <!-- Card Header - Dropdown -->
                                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                                    <h6 class="m-0 font-weight-bold text-primary">Active User Count</h6>
                                    <div class="dropdown no-arrow">
                                        <a class="dropdown-toggle" href="#" role="button" id="dropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                            <i class="fas fa-ellipsis-v fa-sm fa-fw text-gray-400"></i>
                                        </a>
                                    </div>
                                </div>
                                <!-- Card Body -->
                                <div class="card-body">
                                    <div class="chart-area">
                                        <canvas id="myAreaChart" style="height: 320px; width: 768px;"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <!-- Area Chart -->
                        <div class="col-xl-8 col-lg-7">
                            <div class="card shadow mb-4">
                                <!-- Card Header - Dropdown -->
                                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                                    <h6 class="m-0 font-weight-bold text-primary">List of participate users details</h6>
                                </div>
                                <!-- Card Body -->
                                <div class="card-body">
                                    <div class="col-xl-4" style="width: 350px!important">
                                        <asp:GridView ID="GridView1" runat="server" CssClass="Grid" AutoGenerateColumns="false" EmptyDataText="No data found">
                                            <HeaderStyle CssClass="HeaderStyle1" />
                                            <Columns>
                                                <asp:BoundField HeaderText="Day of week" DataField="WeekDays" />
                                                <asp:BoundField HeaderText="User Count of Day" DataField="UserCount" />

                                            </Columns>
                                        </asp:GridView>
                                    </div>
                                    <%-- <div class="col-xl-4">
                                        <asp:Chart ID="chartContainer" runat="server" Height="300px" Width="400px" Visible="false" >
                                            <Titles>
                                                <asp:Title ShadowOffset="3" Name="Items" />
                                            </Titles>
                                            <Legends>
                                                <asp:Legend Alignment="Center" Docking="Bottom" IsTextAutoFit="False" Name="Default"
                                                    LegendStyle="Row" />
                                            </Legends>
                                            <Series>
                                                <asp:Series Name="Active User count" />
                                            </Series>
                                            <ChartAreas>
                                                <asp:ChartArea Name="ChartArea1" BorderWidth="0" />
                                            </ChartAreas>
                                        </asp:Chart>
                                    </div>--%>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>






</asp:Content>
