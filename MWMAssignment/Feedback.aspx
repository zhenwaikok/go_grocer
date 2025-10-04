<%@ Page Title="" Language="C#" MasterPageFile="~/UserMasterPage.Master" AutoEventWireup="true" CodeBehind="Feedback.aspx.cs" Inherits="MWMAssignment.WebForm2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="feedback.css" type="text/css">
    <script type="text/javascript">
        function showSuccessMessage() {
            alert('Successfully submitted!');
            window.location.href = 'Feedback.aspx';
        }
     </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="feedbackFormContainer">
        <div class="titleDescription">
            <h1 class="feedbackTitle">Feedback</h1>
            <p class="feedbackDesc">Tell us what you think!</p>
        </div>

        <div class="feedbackFormContent">
            <div class="feedbackForm">
                <h3 class="feedbackFormTitle">Feedback Form</h3>
                <p class="feedbackFormDesc">Your thoughts and suggestions help us improve. Whether you're a guest or a customer, we’d love to hear from you!</p>
            </div>

            <div class="feedbackType">
                <h5 class="feedbackTypeTitle">Feedback type:</h5>
                <asp:RadioButton ID="suggestion" runat="server" GroupName="FeedbackType" Text="Suggestion" class="radioButton" Checked="true"/>
                <asp:RadioButton ID="comment" runat="server" GroupName="FeedbackType" Text="Comment" class="radioButton"/>
            </div>

            <div class="feedbackMessage">
                <h5 class="feedbackMessageTitle">Describe your feedback:</h5>
                <asp:TextBox ID="feedbackMessageTextBox" runat="server" TextMode="MultiLine" CssClass="feedbackMessageTextBox" placeholder="Write your feedback here"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Please enter review before submitting" ControlToValidate="feedbackMessageTextBox" ForeColor="Red"></asp:RequiredFieldValidator>
            </div>

            <div class="submitButtonContainer">
                <asp:Button ID="submitButton" runat="server" Text="Submit" class="submitButton" OnClick="submitButton_Click"/>
            </div>
        </div>
    </div>
</asp:Content>
