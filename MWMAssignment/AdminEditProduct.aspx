<%@ Page Title="" Language="C#" MasterPageFile="~/AdminMasterPage.Master" AutoEventWireup="true" CodeBehind="AdminEditProduct.aspx.cs" Inherits="MWMAssignment.WebForm6" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="AdminEditProduct.css" type="text/css" />
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
            window.location.href = 'AdminManageProduct.aspx';
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="editProductContainer">
        <div class="modal-header">
            <h5 class="modal-title modalTitle">Edit Product</h5>
        </div>
        <div class="modal-body">
            <div class="input-form">
                <h3 class="form-name">Product Name</h3>
                <asp:TextBox ID="productName" runat="server" TextMode="SingleLine" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage="Please enter product name" ControlToValidate="productName"  ForeColor="Red" ValidationGroup="ModalValidation"></asp:RequiredFieldValidator>
            </div>

                <div class="input-form">
                <h3 class="form-name">Description</h3>
                    <asp:TextBox ID="description" runat="server" TextMode="MultiLine" CssClass="descriptionTextBox form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Please enter product description" ControlToValidate="description"  ForeColor="Red" ValidationGroup="ModalValidation"></asp:RequiredFieldValidator>
                </div>

            <div class="input-form">
                <h3 class="form-name">Category</h3>
                <asp:DropDownList ID="category" runat="server" CssClass="form-control">
                    <asp:ListItem Value="" Disabled="True" Selected="True">Select product category</asp:ListItem>
                        <asp:ListItem Value="SelectProductCategory" >Select product category</asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" ErrorMessage="Please select product category" ControlToValidate="category"  ForeColor="Red" ValidationGroup="ModalValidation"></asp:RequiredFieldValidator>
                </div>

            <div class="input-form">
                <h3 class="form-name">Price</h3>
                <asp:TextBox ID="price" runat="server" TextMode="Number" CssClass="form-control" step="any"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Please enter product price" ControlToValidate="price"  ForeColor="Red" ValidationGroup="ModalValidation"></asp:RequiredFieldValidator>
                </div>

            <div class="input-form">
                <h3 class="form-name">Product Image</h3>
                <asp:FileUpload ID="imageFileUpload" runat="server" accept="image/*" CssClass="form-control" onchange="showImagePreview(this)"/>
                <br />
                <asp:Image ID="imagePreview" runat="server" Visible="false" CssClass="imagePreview"/>
            </div>
        </div>
        <div class="modal-footer">
            <asp:Button ID="cancelBtn" runat="server" Text="Cancel" CssClass="btn btn-secondary" CausesValidation="false" OnClick="cancelBtn_Click"/>
            <asp:Button ID="saveBtn" runat="server" Text="Save" CssClass="saveBtn" ValidationGroup="ModalValidation" OnClick="saveBtn_Click"/>
        </div>
    </div>
</asp:Content>
