<%@ Page Title="" Language="C#" MasterPageFile="~/mstr.Master" AutoEventWireup="true" CodeBehind="EventWinnerReport.aspx.cs" Inherits="WebApplication1.EventWinnerReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script src="scripts/jquery-ui-1.8.11.min.js"></script>
    <link href="css/sb-admin-2.min.css" rel="stylesheet" type="text/css" />
    <script src="scripts/jquery-ui.min.js"></script>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
    <link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i" rel="stylesheet" />
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.3/Chart.min.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {

            getData();

        });

        function getData() {
            $.ajax({
                type: "POST",
                url: "EventWinnerReport.aspx/SelectData",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (data) {
                    //var data1 = JSON.stringify(data);
                    //var data2 = JSON.parse(data1); 
                    debugger;
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

        function Fillchart(Winnerdata) {
            debugger;
            var ctx = document.getElementById("myAreaChart").getContext('2d');
            console.log(Winnerdata);
            var myChart = new Chart(ctx,
                {
                    type: 'bar',
                    data: {
                        labels: Winnerdata.Positions, // here i want to show my date value
                        datasets: [
                            {
                                label: 'No of winners at Position',
                                data: Winnerdata.TotalWinner, // here show my total count date wise 
                                backgroundColor: "rgba(153,255,51,1)"
                            }
                        ]
                    }
                });
        }
    </script>
    <div id="wrapper">
        <!-- Content Wrapper -->
        <div id="content-wrapper" class="d-flex flex-column">
            <!-- Main Content -->
            <div id="content">
                <!-- Begin Page Content -->
                <div class="container-fluid">
                    <!-- Page Heading -->
                    <div class="d-sm-flex align-items-center justify-content-between mb-4">
                        <h1 class="h3 mb-0 text-gray-800" style="font-family:Calibri">Event Winner Report</h1>
                    </div>
                      <div class="row">
                        <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card border-left-primary shadow h-100 py-2">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Total Winners of Contest</div>
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
                        <!-- Area Chart -->
                        <div class="col-xl-8 col-lg-7">
                            <div class="card shadow mb-4">
                                <!-- Card Header - Dropdown -->
                                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                                    <h6 class="m-0 font-weight-bold text-primary">No of Winners at positions (Chart View)</h6>
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
                                    <h6 class="m-0 font-weight-bold text-primary">No of Winners at positions in List</h6>
                                </div>
                                <!-- Card Body -->
                                <div class="card-body">
                                    <div class="col-xl-4" style="width: 350px!important">
                                        <asp:GridView ID="GridView1" runat="server" CssClass="Grid" AutoGenerateColumns="false" EmptyDataText="No data found" style="text-align:center;"  >
                                            <HeaderStyle CssClass="HeaderStyle1"/>
                                            <Columns>
                                                <asp:BoundField HeaderText="Positions" DataField="position" />
                                                <asp:BoundField HeaderText="No of User" DataField="totalUser" />

                                            </Columns>
                                        </asp:GridView>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


</asp:Content>
