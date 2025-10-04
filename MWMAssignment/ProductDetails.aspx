<%@ Page Title="" Language="C#" MasterPageFile="~/UserMasterPage.Master" AutoEventWireup="true" CodeBehind="ProductDetails.aspx.cs" Inherits="MWMAssignment.WebForm11" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="ProductDetails.css" type="text/css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
    <script type="text/javascript">
        function openSuccessModal(productId) {
            var myModal = new bootstrap.Modal(document.getElementById('successModal'), {
                keyboard: false,
                backdrop: 'static'
            });
            myModal.show();

            setTimeout(function () {
                myModal.hide();
            }, 1000);

            document.getElementById('successModal').addEventListener('hidden.bs.modal', function () {
                window.location.href = "ProductDetails.aspx?productId=" + productId;
            });
        }

        function showSuccessMessage(productId) {
            alert('Review submitted!');
            window.location.href = 'ProductDetails.aspx?productId=' + productId;
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="modal fade" id="successModal" tabindex="-1" aria-labelledby="successModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-body text-center">
                    <i class="bi bi-check-circle-fill" style="font-size: 3rem; color: green;"></i>
                    <p class="mt-3">Product added to cart successfully!</p>
                </div>
            </div>
        </div>
    </div>
    <div class="productDetailsContainer mt-5">
        <div class="row g-3">
            <div class="col-lg-6 col-md-6 col-sm-12 mb-4 d-flex align-items-center justify-content-center">
                <asp:Image ID="productImage" runat="server" CssClass="productImage" />
            </div>

            <div class="col-lg-6 col-md-6 col-sm-12">
                <div class="productName">
                    <asp:Label ID="productNameLabel" runat="server" Text="Frozen fish" CssClass="productNameLabel"></asp:Label>
                </div>

                <div class="productPrice">
                    <asp:Label ID="priceLabel" runat="server" Text="Price:" CssClass="priceLabel"></asp:Label>
                    <br />
                    <asp:Label ID="productPriceLabel" runat="server" Text="RM 13.55" CssClass="productPriceLabel"></asp:Label>
                </div>

                <div class="productQuantity">
                    <asp:Label ID="quantityLabel" runat="server" Text="Quantity:" CssClass="quantityLabel"></asp:Label>
                    <br />
                    <asp:TextBox ID="quantity" runat="server" TextMode="Number" CssClass="formControl" AutoPostBack="true" OnTextChanged="quantity_TextChanged"></asp:TextBox>
                </div>

                <div class="addToCartBtn mt-auto">
                    <asp:Button ID="cartBtn" runat="server" Text="Add to cart" CssClass="addCartBtn" OnClick="cartBtn_Click" CausesValidation="false" />
                </div>
            </div>
        </div>

        <div class="productDescription">
            <div class="productDescriptionTitle">
                <asp:Label ID="productDescriptionLabel" runat="server" Text="Product Description" CssClass="productDescriptionLabel"></asp:Label>
            </div>

            <div class="productDescriptionMessage">
                <asp:Label ID="productDescriptionMessage" runat="server" Text="Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed imperdiet dictum lectus eget fringilla. Sed bibendum mi sit amet risus posuere suscipit. Sed congue rhoncus sodales." CssClass="productDescriptionMessage"></asp:Label>
            </div>
        </div>

        <div class="reviews">
            <div class="reviewsTitle">
                <asp:Label ID="reviewsLabel" runat="server" Text="Reviews" CssClass="reviewsLabel"></asp:Label>
                <br />
                <asp:Label ID="noReviewsLabel" runat="server" Text="No reviews yet." Visible="false" CssClass="noReviewsLabel"></asp:Label>
            </div>

            <asp:Repeater ID="reviewDetailsRepeater" runat="server">
                <ItemTemplate>
                    <div class="reviewDetails">
                        <div class="reviewUser">
                            <asp:Label ID="reviewUserLabel" runat="server" Text='<%# Eval("username") %>' CssClass="reviewUserLabel"></asp:Label>
                        </div>

                        <div class="reviewMessage">
                            <asp:Label ID="reviewMessageLabel" runat="server" Text='<%# Eval("reviewMssg") %>' CssClass="reviewMessageLabel"></asp:Label>
                        </div>

                        <hr />
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <div class="submitReview d-flex justify-content-between">
                <asp:TextBox ID="reviewTextBox" runat="server" Placeholder="Write your review..." CssClass="reviewTextBox"></asp:TextBox>
                <asp:Button ID="submitBtn" runat="server" Text="Submit" CssClass="submitBtn" OnClick="submitBtn_Click" />
            </div>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Please provide your review before submitting" ControlToValidate="reviewTextBox" ForeColor="Red"></asp:RequiredFieldValidator>
        </div>
    </div>
</asp:Content>
