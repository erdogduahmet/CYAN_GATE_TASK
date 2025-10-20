# 🧩 AccountPayments Project

## 📘 Project Description

This project is developed as part of the second phase of the Cyangate interview process.  
It demonstrates the ability to design, develop, and test a **Salesforce Lightning Web Component (LWC)** that integrates with custom and standard objects using **Apex controllers**.

The purpose of the project is to display **Accounts** and their related **Payments** in a single Lightning Web Component, allowing users to view and create Payment records directly.

---

## ⚙️ Project Requirements

### 1. Custom Object: **Payment**

| Field Name   | Field Type | Values / Description |
|---------------|-------------|----------------------|
| Payment Type* | Picklist | Service, Product, Other |
| Amount* | Currency | Required field |
| Due Date* | Date | Must be a future date |
| Notes | Long Text | Optional notes field |

### Validation Rule
- **Name:** `Validate_Due_Date`
- **Description:** Ensures that the “Due Date” field is always a future date.  
  **Formula:**  
  ``` 
  Due_Date__c <= TODAY()
  ```  
  **Error Message:** `Due Date must be a future date.`

### Relationship
A **Lookup Relationship** is created between **Payment** and **Account**.

#### Reason for Lookup Relationship
A **Lookup Relationship** was chosen instead of a **Master-Detail Relationship** to maintain data integrity and flexibility.  
If an Account record is deleted, related Payment records should **not** be deleted automatically — as Payment records may represent important historical data.  
Therefore, a Lookup relationship ensures that Payment records can exist independently of the Account if necessary.

---

## 💡 LWC Component: `AccountPayments`

### Features:
- Displays a list of all **Accounts**.
- Allows the user to **select only one Account**.
- When an Account is selected:
  - Displays the list of related **Payments**.
  - Shows a form to **create a new Payment** for the selected Account.
- If no Account is selected, the Payment section remains hidden.
- The form includes all required fields from the Payment object.
- A **“Create Payment”** button allows the user to add new Payments.
- The list of Payments updates dynamically when a new Payment is created.

### Example Layout:
```
--------------------------------------------------------
| Account List |   Payment List   |   New Payment Form  |
--------------------------------------------------------
```

---

## 🧠 Apex Controller

**Controller Name:** `AccountPaymentController`  
- Retrieves all Accounts.
- Retrieves Payments for a selected Account.
- Handles the creation of new Payment records.

**Test Class:** `AccountPaymentController_Test`  
- Includes unit tests covering all methods in the controller.
- Uses test data to validate logic and DML operations.
- Achieved **>80% code coverage** with assertions ensuring code correctness.

---

## 📊 Report and Dashboard

A **custom Report** and **Dashboard** have been created to visualize Accounts and their related Payments.

- **Report Name:** `Accounts with Payments`
  - Filter: Show Accounts with related Payment records.
- **Dashboard Name:** `Account Payments Dashboard`
  - Displays total payment amounts grouped by Account and Payment Type.

---

## 🧪 Test Coverage

| Class | Coverage |
|--------|-----------|
| AccountPaymentController | 100% |

---

## 📸 Attachments (included in GitHub)
- `Payment-Account Schema` 
- `Report and Dashboard Screenshots`
-https://drive.google.com/drive/folders/1Fk7U7W4YdCPyO-Vz0WuRF8cGm1qoO9ir

---



- **Trailhead Profile (Public):**  
  [*(Add your Trailhead profile link here)*  ](https://www.salesforce.com/trailblazer/rrxbykb8d0c12m367e)

---

## 🧑‍💻 Technologies Used
- Salesforce Lightning Web Components (LWC)
- Apex Classes & Test Classes
- Salesforce Object Manager (Custom Object & Validation Rule)
- Reports & Dashboards
- GitHub for version control

---

## 🏁 Author
**Ahmet Erdoğdu**  
Gazi University – Computer Engineer  
Cyangate Custom Task Submission  
Date: 20/10/2025  
