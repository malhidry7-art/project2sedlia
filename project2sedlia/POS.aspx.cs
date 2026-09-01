using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace project2sedlia
{
    public partial class POS : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // الحماية: التأكد من تسجيل الدخول
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
            {
                // تهيئة الفاتورة الفارغة عند فتح الشاشة لأول مرة
                InitializeInvoice();
            }

            lblMessage.Text = ""; // مسح رسائل الخطأ مع كل تحميل
        }

        // دالة لإنشاء جدول مؤقت في الذاكرة لحفظ الأصناف قبل الدفع
        private void InitializeInvoice()
        {
            DataTable dtInvoice = new DataTable();
            dtInvoice.Columns.Add("BatchID");
            dtInvoice.Columns.Add("Barcode");
            dtInvoice.Columns.Add("TradeName");
            dtInvoice.Columns.Add("Price", typeof(decimal));
            dtInvoice.Columns.Add("Qty", typeof(int));
            dtInvoice.Columns.Add("SubTotal", typeof(decimal));

            Session["InvoiceData"] = dtInvoice;
            BindGrid();
        }

        // دالة لتحديث واجهة المستخدم (الجدول والإجماليات)
        private void BindGrid()
        {
            DataTable dt = (DataTable)Session["InvoiceData"];
            gvInvoice.DataSource = dt;
            gvInvoice.DataBind();

            // حساب الإجمالي وعدد الأصناف
            decimal totalAmount = 0;
            int itemsCount = 0;

            foreach (DataRow row in dt.Rows)
            {
                totalAmount += Convert.ToDecimal(row["SubTotal"]);
                itemsCount += Convert.ToInt32(row["Qty"]);
            }

            lblTotal.Text = totalAmount.ToString("0.00");
            lblItemsCount.Text = itemsCount.ToString();
        }

        protected void btnAddItem_Click(object sender, EventArgs e)
        {
            string barcode = txtBarcode.Text.Trim();
            if (string.IsNullOrEmpty(barcode)) return;

            // قراءة الكمية المطلوبة التي أدخلها الصيدلي (إذا كانت فارغة أو خاطئة نعتبرها 1)
            int requestedQty = 1;
            if (!int.TryParse(txtQtyInput.Text.Trim(), out requestedQty) || requestedQty < 1)
            {
                requestedQty = 1;
            }

            // تطبيق عرض العرض الذكي: لكل 12 وحدة مدفوعة، يمنح النظام 3 وحدات مجانية إضافية!
            // حساب عدد العروض (كل 12 حبة تمنح 3 حبات مجانية)
            int freeItems = (requestedQty / 12) * 3;
            int totalQtyToDeduct = requestedQty + freeItems; // الكمية الإجمالية التي ستخصم من المخزن

            string connString = ConfigurationManager.ConnectionStrings["PharmacyConn"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                // استعلام هندسي (FIFO): يجلب الدواء بناءً على الباركود، والشحنة الأقرب للانتهاء
                string query = @"
                    SELECT TOP 1 b.BatchID, m.Barcode, m.TradeName, b.SellPrice, b.Quantity 
                    FROM Medicines m
                    INNER JOIN Batches b ON m.MedicineID = b.MedicineID
                    WHERE m.Barcode = @Barcode AND b.Quantity > 0 AND b.ExpiryDate > GETDATE()
                    ORDER BY b.ExpiryDate ASC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Barcode", barcode);

                    try
                    {
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        if (reader.HasRows)
                        {
                            reader.Read();
                            string batchId = reader["BatchID"].ToString();
                            string tradeName = reader["TradeName"].ToString();
                            decimal price = Convert.ToDecimal(reader["SellPrice"]);
                            int dbQty = Convert.ToInt32(reader["Quantity"]); // الكمية الفعليّة المتوفرة في المخزن

                            // تمرير الكمية المطلوبة مضافاً إليها الهدايا المجانية للدالة المعالجة
                            AddOrUpdateInvoiceData(batchId, barcode, tradeName, price, dbQty, requestedQty, totalQtyToDeduct, freeItems);
                        }
                        else
                        {
                            lblMessage.Text = "تنبيه: الدواء غير موجود، أو الكمية نفدت، أو منتهي الصلاحية!";
                        }
                    }
                    catch (Exception ex)
                    {
                        lblMessage.Text = "حدث خطأ في الاتصال بقاعدة البيانات: " + ex.Message;
                    }
                }
            }

            // تفريغ مربع الباركود وإرجاع خانة الكمية إلى 1، والتركيز على الباركود فوراً
            txtBarcode.Text = "";
            txtQtyInput.Text = "1";
            txtBarcode.Focus();
        }

        // دالة معالجة الجدول المؤقت وتطبيق سياسة (اشترِ 12 واحصل على 3 مجاناً)
        private void AddOrUpdateInvoiceData(string batchId, string barcode, string tradeName, decimal price, int dbQty, int requestedQty, int totalQtyToDeduct, int freeItems)
        {
            DataTable dt = (DataTable)Session["InvoiceData"];
            bool exists = false;

            foreach (DataRow row in dt.Rows)
            {
                if (row["BatchID"].ToString() == batchId)
                {
                    int currentQty = Convert.ToInt32(row["Qty"]);
                    int newTotalQtyToDeduct = currentQty + totalQtyToDeduct;

                    // حماية النظام: التأكد أن إجمالي الكمية المطلوبة + المجانية لا يتجاوز المتوفر في المخزن
                    if (newTotalQtyToDeduct <= dbQty)
                    {
                        row["Qty"] = currentQty + totalQtyToDeduct;
                        // السعر الفرعي يحسب فقط بناءً على الكمية المدفوعة (requestedQty) ولا يحسب المجاني
                        decimal currentSubTotal = Convert.ToDecimal(row["SubTotal"]);
                        row["SubTotal"] = currentSubTotal + (requestedQty * price);

                        if (freeItems > 0)
                        {
                            lblMessage.Text = $"🎉 مبروك للزبون! تم تطبيق العرض وإضافة {freeItems} وحدات مجانية لهذا الصنف.";
                            lblMessage.ForeColor = System.Drawing.Color.FromArgb(16, 185, 129);
                        }
                        else
                        {
                            lblMessage.Text = "";
                        }
                    }
                    else
                    {
                        lblMessage.Text = $"لا يمكنك تجاوز الكمية المتوفرة! المخزن يحتوي على {dbQty} فقط.";
                        lblMessage.ForeColor = System.Drawing.Color.Red;
                    }
                    exists = true;
                    break;
                }
            }

            // إذا لم يكن الدواء موجوداً في الفاتورة مسبقاً
            if (!exists)
            {
                if (totalQtyToDeduct <= dbQty)
                {
                    DataRow newRow = dt.NewRow();
                    newRow["BatchID"] = batchId;
                    newRow["Barcode"] = barcode;
                    // إضافة تبيان في الاسم لو ترافق معها هدية مجانية ليفهم الصيدلي
                    newRow["TradeName"] = freeItems > 0 ? $"{tradeName} (مع {freeItems} مجاناً للعرض)" : tradeName;
                    newRow["Price"] = price;
                    newRow["Qty"] = totalQtyToDeduct; // الكمية الإجمالية (مدفوعة + مجانية) لتخصم من المخزن بدقة
                    newRow["SubTotal"] = requestedQty * price; // السعر يحسب للمدفوع فقط
                    dt.Rows.Add(newRow);

                    if (freeItems > 0)
                    {
                        lblMessage.Text = $"🎉 مبروك للزبون! تم تطبيق عرض (اشترِ 12 واحصل على 3 مجاناً) بإضافة {freeItems} قطع مجانية.";
                        lblMessage.ForeColor = System.Drawing.Color.FromArgb(16, 185, 129);
                    }
                    else
                    {
                        lblMessage.Text = "";
                    }
                }
                else
                {
                    lblMessage.Text = $"الكمية المطلوبة مع الهدايا أكبر من المتوفر في المخزن! المتاح هو {dbQty} فقط.";
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                }
            }

            Session["InvoiceData"] = dt;
            BindGrid();
        }

        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            DataTable dt = (DataTable)Session["InvoiceData"];
            if (dt == null || dt.Rows.Count == 0)
            {
                lblMessage.Text = "الفاتورة فارغة! لا يمكن حفظ فاتورة بدون أصناف.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            string connString = ConfigurationManager.ConnectionStrings["PharmacyConn"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                SqlTransaction transaction = conn.BeginTransaction();

                try
                {
                    // 1. إدخال الفاتورة وجلب الرقم (InvoiceID)
                    string insertInvoiceQuery = "INSERT INTO Invoices (UserID, TotalAmount) OUTPUT INSERTED.InvoiceID VALUES (@UserID, @TotalAmount)";
                    SqlCommand cmdInvoice = new SqlCommand(insertInvoiceQuery, conn, transaction);
                    cmdInvoice.Parameters.AddWithValue("@UserID", Session["UserID"]);
                    cmdInvoice.Parameters.AddWithValue("@TotalAmount", Convert.ToDecimal(lblTotal.Text));

                    int newInvoiceId = (int)cmdInvoice.ExecuteScalar();

                    // 2. تفاصيل الفاتورة وخصم المخزون بالكامل (بما فيها الكميات المجانية من المخزن)
                    foreach (DataRow row in dt.Rows)
                    {
                        string insertDetailsQuery = "INSERT INTO InvoiceDetails (InvoiceID, BatchID, Qty, SubTotal) VALUES (@InvoiceID, @BatchID, @Qty, @SubTotal)";
                        SqlCommand cmdDetails = new SqlCommand(insertDetailsQuery, conn, transaction);
                        cmdDetails.Parameters.AddWithValue("@InvoiceID", newInvoiceId);
                        cmdDetails.Parameters.AddWithValue("@BatchID", row["BatchID"]);
                        cmdDetails.Parameters.AddWithValue("@Qty", row["Qty"]); // ستخصم الكمية الكلية (المدفوعة + المجانية) من المخزن
                        cmdDetails.Parameters.AddWithValue("@SubTotal", row["SubTotal"]);
                        cmdDetails.ExecuteNonQuery();

                        string updateStockQuery = "UPDATE Batches SET Quantity = Quantity - @Qty WHERE BatchID = @BatchID";
                        SqlCommand cmdStock = new SqlCommand(updateStockQuery, conn, transaction);
                        cmdStock.Parameters.AddWithValue("@Qty", row["Qty"]);
                        cmdStock.Parameters.AddWithValue("@BatchID", row["BatchID"]);
                        cmdStock.ExecuteNonQuery();
                    }

                    transaction.Commit();

                    // التوجيه لصفحة طباعة الفاتورة
                    Response.Redirect("PrintInvoice.aspx?id=" + newInvoiceId);
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    lblMessage.Text = "حدث خطأ أثناء الحفظ، تم التراجع لحماية البيانات: " + ex.Message;
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                }
            }
        }
    }
}