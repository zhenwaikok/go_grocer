<%@ Page Title="" Language="C#" MasterPageFile="~/UserMasterPage.Master" AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="MWMAssignment.WebForm13" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="Cart.css" type="text/css" />
    <script>
        function showSuccessMessage(customerId) {
            alert('Successfully deleted from cart!');
            window.location.href = "Cart.aspx?customerId=" + customerId;
        }

        function openPaymentModal() {
            var paymentModal = new bootstrap.Modal(document.getElementById('paymentModal'));
            paymentModal.show();
        }

        function formatCardNumber(input) {
            var value = input.value.replace(/\D/g, '');
            if (value.length > 16) value = value.slice(0, 16);
            input.value = value.replace(/(\d{4})(?=\d)/g, '$1 ');
        }

        function formatExpiryDate(input) {
            var value = input.value.replace(/\D/g, '');
            if (value.length > 4) value = value.slice(0, 4);
            if (value.length >= 2) {
                input.value = value.slice(0, 2) + '/' + value.slice(2);
            } else {
                input.value = value;
            }
        }

        function limitCVV(input) {
            input.value = input.value.replace(/\D/g, '');
            if (input.value.length > 3) {
                input.value = input.value.slice(0, 3);
            }
        }

        function openSuccessModal() {
            var myModal = new bootstrap.Modal(document.getElementById('successModal'), {
                keyboard: false,
                backdrop: 'static'
            });
            myModal.show();

            setTimeout(function () {
                myModal.hide();
            }, 1000);

            document.getElementById('successModal').addEventListener('hidden.bs.modal', function () {
                window.location.href = "HomePage.aspx";
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="cartTitle">
        <h1 class="cartTitleText">Cart</h1>
    </div>

    <asp:Panel ID="emptyCartPanel" runat="server" Visible="false" CssClass="emptyCartPanel">
        <asp:Label ID="emptyCart" runat="server" Text="Your cart is empty!" CssClass="emptyCart"></asp:Label>
    </asp:Panel>

    <asp:Panel ID="cartPanel" runat="server">
        <div class="container py-5">
            <div class="modal fade" id="successModal" tabindex="-1" aria-labelledby="successModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-body text-center">
                            <i class="bi bi-check-circle-fill" style="font-size: 3rem; color: green;"></i>
                            <p class="mt-3">Thank you for your order!</p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal" id="paymentModal" tabindex="-1">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title modalTitle">Payment Details</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="input-form">
                                <h3 class="form-name">Card Number</h3>
                                <asp:TextBox ID="cardNumber" runat="server" TextMode="Singleline" CssClass="form-control" Placeholder="0125 6780 5569 5529" oninput="formatCardNumber(this)"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ErrorMessage="Please enter card number" ControlToValidate="cardNumber" ForeColor="Red" ValidationGroup="ModalValidation"></asp:RequiredFieldValidator>
                            </div>

                            <div class="input-form">
                                <h3 class="form-name">Expiry Date</h3>
                                <asp:TextBox ID="expiryDate" runat="server" TextMode="Singleline" CssClass="form-control" Placeholder="YY/MM" oninput="formatExpiryDate(this)"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Please enter expiry date" ControlToValidate="expiryDate" ForeColor="Red" ValidationGroup="ModalValidation"></asp:RequiredFieldValidator>
                            </div>

                            <div class="input-form">
                                <h3 class="form-name">CVV</h3>
                                <asp:TextBox ID="CVV" runat="server" TextMode="Singleline" CssClass="form-control" oninput="limitCVV(this)"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Please enter CVV" ControlToValidate="CVV" ForeColor="Red" ValidationGroup="ModalValidation"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <asp:Button ID="cancelBtn" runat="server" Text="Cancel" CssClass="btn btn-secondary" data-bs-dismiss="modal" CausesValidation="false" />
                            <asp:Button ID="proceedBtn" runat="server" Text="Proceed" CssClass="proceedBtn" ValidationGroup="ModalValidation" OnClick="proceedBtn_Click" />
                        </div>
                    </div>
                </div>
            </div>

            <div class="numberOfItemsContainer">
                <asp:Label ID="numOfItemsLabel" runat="server" Text="2 Item(s)" CssClass="numOfItems"></asp:Label>
            </div>

            <div class="row">
                <div class="col-lg-8">

                    <asp:Repeater ID="cartItemsRepeater" runat="server" OnItemDataBound="cartItemsRepeater_ItemDataBound">
                        <ItemTemplate>
                            <div class="card mb-4">
                                <div class="card-body">
                                    <div class="row cart-item mb-3">
                                        <div class="col-md-3">
                                            <asp:Image ID="productImage" runat="server" CssClass="img-fluid rounded productImage" ImageUrl='<%# Eval("image") %>' />
                                        </div>
                                        <div class="col-md-5">
                                            <asp:Label ID="productName" runat="server" Text='<%# Eval("productName") %>' CssClass="productName"></asp:Label>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="input-group">
                                                <asp:Button ID="minusBtn" runat="server" Text="-"
                                                    CssClass="btn btn-outline-secondary btn-sm minusBtn"
                                                    CommandArgument='<%# Eval("productId") %>'
                                                    OnClick="minusBtn_Click" />
                                                <asp:TextBox ID="quantityTextBox" runat="server" Text='<%# Eval("quantity") %>' Style="max-width: 100px" CssClass="form-control form-control-sm text-center quantity-input" ReadOnly="True"></asp:TextBox>
                                                <asp:Button ID="plusBtn" runat="server" Text="+"
                                                    CssClass="btn btn-outline-secondary btn-sm plusBtn"
                                                    CommandArgument='<%# Eval("productId") %>'
                                                    OnClick="plusBtn_Click" />
                                            </div>
                                        </div>
                                        <div class="col-md-2 text-end">
                                            <div class="totalPriceContainer">
                                                <asp:Label ID="totalPrice" runat="server" Text="RM 11.22" CssClass="fw-bold"></asp:Label>
                                            </div>

                                            <div class="deleteBtnContainer">
                                                <asp:LinkButton ID="deleteBtn" runat="server" CommandArgument='<%# Eval("productId") %>' CssClass="btn btn-sm btn-outline-danger" OnClick="deleteBtn_Click">
                                        <i class="bi bi-trash"></i>
                                                </asp:LinkButton>
                                            </div>
                                        </div>
                                    </div>
                                    <hr>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                </div>

                <div class="col-lg-4">

                    <div class="card cart-summary">
                        <div class="card-body">
                            <h5 class="card-title mb-4" style="font-weight: bold;">Order Summary</h5>
                            <div class="d-flex justify-content-between mb-3">
                                <span>Subtotal</span>
                                <asp:Label ID="subTotalLAbel" runat="server" Text="$199.97"></asp:Label>
                            </div>
                            <hr>
                            <div class="d-flex justify-content-between mb-4">
                                <h1 class="totalText">Total</h1>
                                <asp:Label ID="totalLabel" runat="server" Text="$199.97" CssClass="totalLabel"></asp:Label>
                            </div>
                            <asp:Button ID="checkOutBtn" runat="server" Text="Checkout"
                                CssClass="btn btn-primary w-100 checkOutBtn"
                                OnClientClick="openPaymentModal(); return false;" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </asp:Panel>
</asp:Content>
