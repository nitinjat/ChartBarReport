<%@ Page Title="" Language="C#" MasterPageFile="~/mstr.Master" AutoEventWireup="true" CodeBehind="EventReport.aspx.cs" Inherits="WebApplication1.EventReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <link href="css/sb-admin-2.min.css" rel="stylesheet" type="text/css" />     
     <script src="scripts/jquery-3.4.1.min.js"></script>
       <script src="scripts/sb-admin-2.min.js"></script>
       <script src="scripts/jquery.dataTables.min.js"></script>
      <script type="text/javascript" src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
   
     <script type="text/javascript">
        $(document).ready(function () {

            $.noConflict();
           
            $('#GridView1').DataTable({
                "paging": true,
                "lengthChange": false,
                "searching": false,
                "ordering": true,
                "info": true,
                "autoWidth": false,
            });


            $('#GridView1').dataTable({
                "bServerSide": true,
                "sAjaxSource": "EventReport.aspx/GetFromDb"
            }).columnFilter({
                "aoColumns": [
                               { "type": "number-range" },
                               { "type": "text" },
                               { "type": "select" },
                               { "type": "date-range" }
                ]
            });
            $("[id*=GridView1]").DataTable(
            {
                bLengthChange: true,
                lengthMenu: [[5, 10, -1], [5, 10, "All"]],
                bFilter: true,
                bSort: true,
                bPaginate: true
                //data: response.d,
                //columns: [{ 'data': 'UserId' },
                //          { 'data': 'UserName' },
                //          { 'data': 'LottoNumber' },
                //          { 'data': 'EventName' },
                //          { 'data': 'Eventdate' },
                //          { 'data': 'StartTime' },
                //          { 'data': 'CloseTime' },
                //          { 'data': 'Drawtime' }]
            });
        
        });       
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
            width: auto;
        }

        td.HeaderStyle1 {
            text-decoration: none;
            color: cornflowerblue;
            font-family:Calibri;
            
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
                        <h1 class="h3 mb-0 text-gray-800" style="font-family:Calibri">Participate Users in Contest</h1>
                    </div>
                     <div class="row">
                        <!-- Area Chart -->
                        <div class="col-xl-8 col-lg-7">
                            <div class="card shadow mb-4">
                                <!-- Card Header - Dropdown -->
                                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                                    <h6 class="m-0 font-weight-bold text-primary">Participate Users List</h6>
                                    <div class="dropdown no-arrow">
                                        <a class="dropdown-toggle" href="#" role="button" id="dropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                            <i class="fas fa-ellipsis-v fa-sm fa-fw text-gray-400"></i>
                                        </a>
                                    </div>
                                </div>
                                <!-- Card Body -->
                                <div class="card-body">
                                   
                                        <asp:GridView ID="GridView1" runat="server" CssClass="Grid" AutoGenerateColumns="false" EmptyDataText="No data found"
                                             ClientIDMode="Static" AllowPaging="true" PageSize="10"  OnPageIndexChanging="GridView1_PageIndexChanging">
                                            <HeaderStyle CssClass="HeaderStyle1" />
                                            <Columns>
                                                <asp:BoundField HeaderText="User Id" DataField="UserId" />
                                                <asp:BoundField HeaderText="Name" DataField="UserName" ItemStyle-Width="120px" />
                                                   <asp:BoundField HeaderText="Posted Number" DataField="LottoNumber" />
                                                   <asp:BoundField HeaderText="Event Name" DataField="EventName" />
                                                   <asp:BoundField HeaderText="Contest Name" DataField="ContestName" />                                                   
                                                <asp:BoundField HeaderText="Event Date" DataField="Eventdate" />
                                                <asp:BoundField HeaderText="Start Time" DataField="StartTime" />
                                                <asp:BoundField HeaderText="Close Time" DataField="CloseTime" />
                                                <asp:BoundField HeaderText="Draw Time" DataField="Drawtime" />
                                                <asp:BoundField HeaderText="Event Type" DataField="EventFrequency" />
                                                									
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
</asp:Content>
