<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMasterPage.Master" AutoEventWireup="true" CodeBehind="AdminEditCategory.aspx.cs" Inherits="MWMAssignment.WebForm8" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="AdminEditCategory.css" type="text/css" />
    <script type="text/javascript">
        function showImagePreview(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
            
                reader.onload = function (e) {
                    document.getElementById('<%= imagePreview.ClientID %>').src = e.target.result;
                    document.getElementById('<%= imagePreview.ClientID %>').style.display = 'block';
                }
            
                reader.readAsDataURL(input.files[0]);
            }
        }

        function showSuccessMessage() {
            alert('Successfully updated!');
            window.location.href = 'AdminManageCategory.aspx';
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="editProductContainer">
        <div class="modal-header">
            <h5 class="modal-title modalTitle">Edit Category</h5>
        </div>
        <div class="modal-body">
            <div class="input-form">
                <h3 class="form-name">Category Name</h3>
                <asp:TextBox ID="categoryName" runat="server" TextMode="SingleLine" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage="Please enter product name" ControlToValidate="categoryName"  ForeColor="Red" ValidationGroup="ModalValidation"></asp:RequiredFieldValidator>
            </div>

            <div class="input-form">
                <h3 class="form-name">Product Image</h3>
                <asp:FileUpload ID="imageFileUpload" runat="server" accept="image/*" CssClass="form-control" onchange="showImagePreview(this)"/>
                <br />
                <asp:Image ID="imagePreview" runat="server" Visible="false" CssClass="imagePreview"/>
            </div>
        </div>
        <div class="modal-footer">
            <asp:Button ID="cancelBtn" runat="server" Text="Cancel" CssClass="btn btn-secondary" CausesValidation="false" OnClick="cancelBtn_Click" />
            <asp:Button ID="saveBtn" runat="server" Text="Save" CssClass="saveBtn" ValidationGroup="ModalValidation" OnClick="saveBtn_Click" style="height: 44px" />
        </div>
    </div>
</asp:Content>
