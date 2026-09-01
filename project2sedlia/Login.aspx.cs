using System;
using System.Data.SqlClient;
using System.Configuration;

namespace project2sedlia
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // عدم مسح رسالة الخطأ إذا كان هناك PostBack يعرض خطأً فعلياً
            if (!IsPostBack)
            {
                lblError.Text = "";
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            // جلب نص الاتصال من ملف Web.config
            string connString = ConfigurationManager.ConnectionStrings["PharmacyConn"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                // استعلام محمي ضد الاختراق (SQL Injection)
                string query = "SELECT UserID, FullName, RoleID FROM Users WHERE FullName = @Username AND Password = @Password";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Username", txtUsername.Text.Trim());
                    cmd.Parameters.AddWithValue("@Password", txtPassword.Text.Trim());

                    try
                    {
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.HasRows)
                        {
                            reader.Read();
                            // حفظ بيانات المستخدم والصلاحية في الجلسة (Session)
                            Session["UserID"] = reader["UserID"].ToString();
                            Session["FullName"] = reader["FullName"].ToString();
                            Session["RoleID"] = reader["RoleID"].ToString(); // 1 للمدير، 2 للصيدلي مثلاً

                            // التوجيه إلى الصفحة الرئيسية
                            Response.Redirect("Default.aspx");
                        }
                        else
                        {
                            lblError.Text = "اسم المستخدم أو كلمة المرور غير صحيحة.";
                        }
                    }
                    catch (Exception ex)
                    {
                        lblError.Text = "حدث خطأ في الاتصال: " + ex.Message;
                    }
                }
            }
        }
    }
}