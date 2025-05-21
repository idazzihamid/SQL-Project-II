# FDA Drug Study Clinical Trial Database (SQL Project)

**Student:** Hamid Id Azzi  
**Professor:** Raymond Harmon  
**Course:** IT-112 – Database Design and SQL  
**Project:** Final Project – Experimental Drug Study Database  
**Repository:** `fda-drug-study-sql-project`

---

## 🧠 Project Summary

This project simulates the backend database design for an FDA-regulated clinical trial system conducted by Acme Pharmaceuticals. The study is structured to manage two simultaneous **double-blind experimental drug trials** and is built using SQL Server.

This system is designed to:
- Track patients enrolled in experimental drug studies
- Assign randomized treatment (Active or Placebo) based on study rules
- Record visits including screening, randomization, and withdrawal
- Maintain drug kit inventories and assignment
- Provide procedural tools for managing randomized codes and withdrawals

---

## 💾 Features & Functionalities

### 📊 Database Design
- 10+ relational tables with full primary and foreign key relationships
- Tables: `TStudies`, `TSites`, `TPatients`, `TVisits`, `TDrugKits`, `TRandomCodes`, `TGenders`, etc.

### 🔁 Business Rules Implemented
- **Study 12345**: Uses a random pick list for treatment
- **Study 54321**: Ensures treatment counts differ by no more than 2
- Sites assigned to each study track patients independently
- Patients are automatically assigned randomized treatments and drug kits

### 🧪 Visit Types
- **Screening**
- **Randomization**
- **Withdrawal**

### 🔧 SQL Stored Procedures
- `uspRandom`: Assigns treatment types
- `uspInsertIntoTrandomCode`: Adds randomized treatment entries
- `uspInsertIntoTPatientsAndTVisits`: Registers new patients with visit records
- `uspWithdrawlPatient`: Handles patient withdrawal scenarios

### 👁️‍🗨️ SQL Views for Reporting
- `VpatientANDsitesANDstudies`: All patients and their site/study info
- `VRandomizedPatientsAndTreatmentStaduy`: Randomized patients with treatment
- `vNextRandomCode`: Shows next available random code
- `vDrugKitAndSite`: Available drug kits at all sites

---

## 🔍 Sample Business Questions Answered

- Which patients are enrolled at each site?
- What are the
