using System;

namespace project2sedlia
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // تدمير الجلسة تماماً وحماية النظام
            Session.Clear();
            Session.Abandon();

            // توجيه المستخدم لصفحة تسجيل الدخول فوراً
            Response.Redirect("Login.aspx");
        }
    }
}