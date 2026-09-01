using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;

namespace project2sedlia
{
    public partial class AddMedicine : System.Web.UI.Page
    {
        string connString = ConfigurationManager.ConnectionStrings["PharmacyConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
            }

            // قيد الصلاحيات: السماح للمدير فقط (RoleID == 1) بإدارة وإضافة الأدوية
            if (Session["RoleID"] == null || Session["RoleID"].ToString() != "1")
            {
                Response.Redirect("AccessDenied.aspx");
            }

            if (!IsPostBack)
            {
                LoadCategories();
            }
        }

        // دالة لجلب التصنيفات من قاعدة البيانات
        private void LoadCategories()
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT CategoryID, CategoryName FROM Categories";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    try
                    {
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();
                        ddlCategories.DataSource = reader;
                        ddlCategories.DataTextField = "CategoryName"; // ما يراه المستخدم
                        ddlCategories.DataValueField = "CategoryID";  // القيمة المخفية للحفظ
                        ddlCategories.DataBind();
                    }
                    catch (Exception ex)
                    {
                        lblMessage.Text = "خطأ في تحميل التصنيفات: " + ex.Message;
                        lblMessage.CssClass = "msg error";
                    }
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string connString = ConfigurationManager.ConnectionStrings["PharmacyConn"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                SqlTransaction transaction = conn.BeginTransaction();

                try
                {
                    // 1. إضافة الدواء إلى جدول الأدوية وجلب الـ ID
                    string insertMedQuery = @"
                INSERT INTO Medicines (Barcode, TradeName, CategoryID) 
                OUTPUT INSERTED.MedicineID 
                VALUES (@Barcode, @TradeName, @CategoryID)";

                    SqlCommand cmdMed = new SqlCommand(insertMedQuery, conn, transaction);
                    cmdMed.Parameters.AddWithValue("@Barcode", txtBarcode.Text.Trim());
                    cmdMed.Parameters.AddWithValue("@TradeName", txtTradeName.Text.Trim());
                    cmdMed.Parameters.AddWithValue("@CategoryID", ddlCategories.SelectedValue);

                    int newMedicineID = (int)cmdMed.ExecuteScalar();

                    // 2. إضافة بيانات الشحنة والمخزون مع التأكد من قبول الكمية والتاريخ
                    string insertBatchQuery = @"
                INSERT INTO Batches (MedicineID, Quantity, PurchasePrice, SellPrice, ExpiryDate) 
                VALUES (@MedicineID, @Qty, @PurchasePrice, @SellPrice, @ExpiryDate)";

                    SqlCommand cmdBatch = new SqlCommand(insertBatchQuery, conn, transaction);
                    cmdBatch.Parameters.AddWithValue("@MedicineID", newMedicineID);
                    cmdBatch.Parameters.AddWithValue("@Qty", Convert.ToInt32(txtQty.Text));
                    cmdBatch.Parameters.AddWithValue("@PurchasePrice", Convert.ToDecimal(txtPurchasePrice.Text));
                    cmdBatch.Parameters.AddWithValue("@SellPrice", Convert.ToDecimal(txtSellPrice.Text));

                    // التأكد من أن تاريخ الصلاحية مدخل بشكل صحيح
                    cmdBatch.Parameters.AddWithValue("@ExpiryDate", Convert.ToDateTime(txtExpiryDate.Text));

                    cmdBatch.ExecuteNonQuery();
                    transaction.Commit();

                    lblMessage.Text = "تم إضافة الدواء والمخزون بنجاح وأصبح جاهزاً للبيع!";
                    lblMessage.CssClass = "msg success";

                    // تصفير الخانات
                    txtBarcode.Text = "";
                    txtTradeName.Text = "";
                    txtQty.Text = "";
                    txtPurchasePrice.Text = "";
                    txtSellPrice.Text = "";
                    txtExpiryDate.Text = "";
                    txtBarcode.Focus();
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    lblMessage.Text = "حدث خطأ: " + ex.Message;
                    lblMessage.CssClass = "msg error";
                }
            }
        }
    }
}