-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 04, 2022 at 07:05 PM
-- Server version: 10.3.16-MariaDB
-- PHP Version: 7.3.7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `database3`
--

-- --------------------------------------------------------

--
-- Table structure for table `t_accounts`
--

CREATE TABLE `t_accounts` (
  `c_ID` int(11) NOT NULL,
  `c_Branch` varchar(100) NOT NULL,
  `c_Name` varchar(100) NOT NULL,
  `c_Type` varchar(100) NOT NULL,
  `c_Contact` varchar(100) DEFAULT NULL,
  `c_Address` varchar(100) DEFAULT NULL,
  `c_Location` varchar(100) DEFAULT NULL,
  `c_Debit` float DEFAULT 0,
  `c_Credit` float DEFAULT 0,
  `c_OpeningBalance` float NOT NULL,
  `c_Basic` varchar(50) DEFAULT NULL,
  `c_Memo` varchar(100) DEFAULT NULL,
  `c_UserID` int(11) DEFAULT NULL,
  `c_UserName` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `t_accounts`
--

INSERT INTO `t_accounts` (`c_ID`, `c_Branch`, `c_Name`, `c_Type`, `c_Contact`, `c_Address`, `c_Location`, `c_Debit`, `c_Credit`, `c_OpeningBalance`, `c_Basic`, `c_Memo`, `c_UserID`, `c_UserName`) VALUES
(21, 'Branch 1', 'Petty Cash', 'Basic', NULL, NULL, NULL, 0, 0, 0, 'petty_cash', NULL, NULL, NULL),
(22, 'Branch 1', 'Sale', 'Basic', NULL, NULL, NULL, 0, 0, 0, 'sale', NULL, NULL, NULL),
(23, 'Branch 1', 'Purchase', 'Basic', NULL, NULL, NULL, 0, 0, 0, 'purchase', NULL, NULL, NULL),
(24, 'Branch 2', 'Petty Cash', 'Basic', NULL, NULL, NULL, 0, 0, 0, 'petty_cash', NULL, NULL, NULL),
(25, 'Branch 2', 'Sale', 'Basic', NULL, NULL, NULL, 0, 0, 0, 'sale', NULL, NULL, NULL),
(26, 'Branch 2', 'Purchase', 'Basic', NULL, NULL, NULL, 0, 0, 0, 'purchase', NULL, NULL, NULL);

--
-- Triggers `t_accounts`
--
DELIMITER $$
CREATE TRIGGER `before_insert_account` BEFORE INSERT ON `t_accounts` FOR EACH ROW BEGIN

SET new.c_Branch = (SELECT c_Branch FROM t_branches WHERE c_Branch = new.c_Branch);
SET new.c_UserName = (SELECT c_Name FROM t_users WHERE c_ID = new.c_UserID);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_update_account` BEFORE UPDATE ON `t_accounts` FOR EACH ROW BEGIN

IF (new.c_Debit!=0 OR new.c_Credit!=0 OR new.c_Basic!=NULL) THEN
	SET new.c_Name = old.c_Name;
END IF;

SET new.c_ID = old.c_ID;
SET new.c_Branch = old.c_Branch;
SET new.c_Type = old.c_Type;
SET new.c_Basic = old.c_Basic;
SET new.c_UserID = old.c_UserID;
SET new.c_UserName = old.c_UserName;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `t_branches`
--

CREATE TABLE `t_branches` (
  `c_ID` int(11) NOT NULL,
  `c_Branch` varchar(100) NOT NULL,
  `c_Name` varchar(100) DEFAULT NULL,
  `c_Address1` varchar(100) DEFAULT NULL,
  `c_Address2` varchar(100) DEFAULT NULL,
  `c_Contact1` varchar(100) DEFAULT NULL,
  `c_Contact2` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `t_branches`
--

INSERT INTO `t_branches` (`c_ID`, `c_Branch`, `c_Name`, `c_Address1`, `c_Address2`, `c_Contact1`, `c_Contact2`) VALUES
(3, 'Branch 1', 'Branch 1', 'Branch 1 Address 1', 'Branch 1 Address 1', 'Branch 1 Contact 1', 'Branch 1 Contact 2'),
(4, 'Branch 2', 'Branch 2', 'Branch 2 Address 1', 'Branch 2 Address 2', 'Branch 2 Contact 1', 'Branch 2 Contact 2');

--
-- Triggers `t_branches`
--
DELIMITER $$
CREATE TRIGGER `after_insert_branch` AFTER INSERT ON `t_branches` FOR EACH ROW BEGIN

INSERT INTO `t_accounts` (`c_ID`, `c_Branch`, `c_Name`, `c_Type`, `c_Contact`, `c_Address`, `c_Location`, `c_Debit`, `c_Credit`, `c_OpeningBalance`, `c_Basic`, `c_Memo`) VALUES 
(NULL, new.c_Branch, 'Petty Cash', 'Basic', NULL, NULL, NULL, '0', '0', '', 'petty_cash', NULL),
(NULL, new.c_Branch, 'Sale', 'Basic', NULL, NULL, NULL, '0', '0', '', 'sale', NULL),
(NULL, new.c_Branch, 'Purchase', 'Basic', NULL, NULL, NULL, '0', '0', '', 'purchase', NULL);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_delete_branch` BEFORE DELETE ON `t_branches` FOR EACH ROW BEGIN

SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Delete Branches Disabled' ;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_update_branch` BEFORE UPDATE ON `t_branches` FOR EACH ROW BEGIN

SET new.c_Branch= old.c_Branch;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `t_invoices`
--

CREATE TABLE `t_invoices` (
  `c_ID` int(11) NOT NULL,
  `c_Branch` varchar(100) DEFAULT NULL,
  `c_Type` varchar(100) NOT NULL,
  `c_AccountType` varchar(100) DEFAULT NULL,
  `c_AccountID` int(11) NOT NULL,
  `c_AccountName` varchar(100) DEFAULT 'NULL',
  `c_SecondAccountType` varchar(100) NOT NULL,
  `c_SecondAccountID` int(11) DEFAULT NULL,
  `c_SecondAccountName` varchar(100) DEFAULT NULL,
  `c_Total` float DEFAULT 0,
  `c_Discount` float DEFAULT 0,
  `c_Date` date DEFAULT NULL,
  `c_Memo` varchar(100) DEFAULT NULL,
  `c_UserID` int(11) NOT NULL,
  `c_UserName` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `t_invoices`
--
DELIMITER $$
CREATE TRIGGER `after_delete_invoice` AFTER DELETE ON `t_invoices` FOR EACH ROW BEGIN

DELETE FROM t_journal WHERE c_ParentID =old.c_ID AND c_Type =old.c_Type;

DELETE FROM t_items WHERE c_InvoiceID =old.c_ID;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_insert_invoice` AFTER INSERT ON `t_invoices` FOR EACH ROW BEGIN

DECLARE my_debit FLOAT;
DECLARE my_credit FLOAT;
DECLARE my_second_debit FLOAT;
DECLARE my_second_credit FLOAT;
    
IF (new.c_Type='Sale' OR new.c_Type='R Purchase' OR new.c_Type='Income' ) THEN
	SET my_debit=new.c_Total-new.c_Discount;
	SET my_credit=0;
	SET my_second_debit=0;
	SET my_second_credit=new.c_Total-new.c_Discount;
ELSE
	SET my_debit=0;
	SET my_credit=new.c_Total-new.c_Discount;
	SET my_second_debit=new.c_Total-new.c_Discount;
	SET my_second_credit=0;
END IF;

INSERT INTO `t_journal` (`c_ParentID`, `c_Branch`, `c_Type`, `c_AccountID`, `c_AccountName`, `c_AccountType`, `c_Debit`, `c_Credit`, `c_Date`, `c_UserID`, `c_UserName`) VALUES 
(new.c_ID, new.c_Branch, new.c_Type, new.c_SecondAccountID, new.c_SecondAccountName, new.c_SecondAccountType, my_second_debit, my_second_credit, new.c_Date, new.c_UserID, new.c_UserName),
    
(new.c_ID, new.c_Branch, new.c_Type, new.c_AccountID, new.c_AccountName, new.c_AccountType, my_debit, my_credit, new.c_Date, new.c_UserID, new.c_UserName);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_invoice` BEFORE INSERT ON `t_invoices` FOR EACH ROW BEGIN

SET new.c_Date =CURRENT_DATE;
set NEW.c_ID = (SELECT SUM(c_ID) FROM t_transaction_id LIMIT 1);
UPDATE t_transaction_id SET c_ID=c_ID+1;

IF(  new.c_Type!='Income' AND  new.c_Type!='Outcome' AND new.c_Type!='Sale' AND new.c_Type!='R Sale' AND new.c_Type!='Purchase' AND new.c_Type!='R Purchase' ) THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Wrong Type Value' ;
END IF;


IF ( new.c_Type = 'Income' OR new.c_Type = 'Outcome' ) THEN
	SET new.c_Discount = 0;
END IF;

SET new.c_UserName = (SELECT c_Name FROM t_users WHERE c_ID = new.c_UserID);
IF ( new.c_UserName ='' OR new.c_UserName IS NULL ) THEN
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'Incorrect User Value';
END IF;

SET new.c_AccountName =(SELECt c_Name FROM t_accounts WHERE c_ID =new.c_AccountID);
SET new.c_AccountType =(SELECt c_Type FROM t_accounts WHERE c_ID =new.c_AccountID);

IF ( new.c_AccountName ='' ) OR ( new.c_AccountName IS NULL ) THEN
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'Incorrect Account Name';
END IF;

SET new.c_Branch = (SELECT c_Branch FROM t_accounts WHERE c_ID = new.c_AccountID);

SET new.c_SecondAccountName = (SELECT c_Name FROM t_accounts WHERE c_ID = new.c_SecondAccountID AND c_Branch = new.c_Branch);
SET new.c_SecondAccountType = (SELECT c_Type FROM t_accounts WHERE c_ID = new.c_SecondAccountID AND c_Branch = new.c_Branch);
IF (new.c_SecondAccountName IS NULL OR new.c_SecondAccountName = '') THEN
	
    IF ( new.c_Type = 'Income' OR new.c_Type = 'Sale' OR new.c_Type = 'R Sale' ) THEN
		SET new.c_SecondAccountID = (SELECT c_ID FROM t_accounts WHERE c_Basic = 'sale' AND c_Branch = new.c_Branch);
        SET new.c_SecondAccountType = (SELECT c_Type FROM t_accounts WHERE c_Basic = 'sale' AND c_Branch = new.c_Branch);
		SET new.c_SecondAccountName = (SELECT c_Name FROM t_accounts WHERE c_Basic = 'sale' AND c_Branch = new.c_Branch);
	ELSE
    	SET new.c_SecondAccountID = (SELECT c_ID FROM t_accounts WHERE c_Basic = 'purchase' AND c_Branch = new.c_Branch);
        SET new.c_SecondAccountType = (SELECT c_Type FROM t_accounts WHERE c_Basic = 'purchase' AND c_Branch = new.c_Branch);
    	SET new.c_SecondAccountName = (SELECT c_Name FROM t_accounts WHERE c_Basic = 'purchase' AND c_Branch = new.c_Branch);
    END IF;
        
END IF;
    
IF ( new.c_SecondAccountName ='' ) OR ( new.c_SecondAccountName IS NULL ) THEN
	SIGNAL SQLSTATE '45000'
   	SET MESSAGE_TEXT = 'Incorrect Second Name Value';		 
END IF;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_update_invoice` BEFORE UPDATE ON `t_invoices` FOR EACH ROW BEGIN

DECLARE my_debit FLOAT;
DECLARE my_credit FLOAT;
DECLARE my_second_debit FLOAT;
DECLARE my_second_credit FLOAT;

SET new.c_ID = old.c_ID;
SET new.c_Branch = old.c_Branch;
SET new.c_Type = old.c_Type;
SET new.c_AccountID = old.c_AccountID;
SET new.c_AccountType = old.c_AccountType;
SET new.c_AccountName = old.c_AccountName;
SET new.c_SecondAccountID = old.c_SecondAccountID;
SET new.c_SecondAccountName = old.c_SecondAccountName;
SET new.c_Date = old.c_Date;
SET new.c_UserID = old.c_UserID;
SET new.c_UserName = old.c_UsernAME;

IF ( new.c_Type = 'Income' ) THEN
	SET new.c_Discount = 0;
END IF;
    
IF (new.c_Type='Sale' OR new.c_Type='R Purchase' OR new.c_Type='Income') THEN
	SET my_debit=new.c_Total-new.c_Discount;
	SET my_credit=0;
	SET my_second_debit=0;
	SET my_second_credit=new.c_Total-new.c_Discount;
ELSE
	SET my_debit=0;
	SET my_credit=new.c_Total-new.c_Discount;
	SET my_second_debit=new.c_Total-new.c_Discount;
	SET my_second_credit=0;
END IF;

DELETE FROM t_journal WHERE c_ParentID = new.c_ID;
INSERT INTO `t_journal` (`c_ParentID`, `c_Branch`, `c_Type`, `c_AccountID`, `c_AccountName`, `c_AccountType`, `c_Debit`, `c_Credit`, `c_Date`, `c_UserID`, `c_UserName`) VALUES 
(new.c_ID, new.c_Branch, new.c_Type, new.c_SecondAccountID, new.c_SecondAccountName, new.c_SecondAccountType, my_second_debit, my_second_credit, new.c_Date, new.c_UserID, new.c_UserName),
    
(new.c_ID, new.c_Branch, new.c_Type, new.c_AccountID, new.c_AccountName, new.c_AccountType, my_debit, my_credit, new.c_Date, new.c_UserID, new.c_UserName);


END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `t_items`
--

CREATE TABLE `t_items` (
  `c_ID` int(11) NOT NULL,
  `c_Branch` varchar(100) DEFAULT NULL,
  `c_InvoiceType` varchar(100) NOT NULL,
  `c_InvoiceID` int(11) NOT NULL,
  `c_AccountType` varchar(100) DEFAULT NULL,
  `c_AccountID` int(11) DEFAULT NULL,
  `c_AccountName` varchar(100) DEFAULT NULL,
  `c_SecondAccountID` int(11) DEFAULT NULL,
  `c_SecondAccountName` varchar(100) DEFAULT NULL,
  `c_StockID` int(11) NOT NULL,
  `c_StockName` varchar(100) DEFAULT NULL,
  `c_StockCategory1` varchar(100) DEFAULT NULL,
  `c_StockCategory2` varchar(10) DEFAULT NULL,
  `c_StockCategory3` varchar(100) DEFAULT NULL,
  `c_StockCategory4` varchar(100) DEFAULT NULL,
  `c_StockCategory5` varchar(100) DEFAULT NULL,
  `c_StockCategory6` varchar(100) DEFAULT NULL,
  `c_StockCategory7` varchar(100) DEFAULT NULL,
  `c_StockCategory8` varchar(100) DEFAULT NULL,
  `c_StockAverageCost` float DEFAULT NULL,
  `c_Price` float DEFAULT 0,
  `c_Qty` float DEFAULT 0,
  `c_Discount` float DEFAULT 0,
  `c_InvoiceDate` date DEFAULT NULL,
  `c_UserID` int(11) DEFAULT NULL,
  `c_UserName` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `t_items`
--
DELIMITER $$
CREATE TRIGGER `after_delete_item` AFTER DELETE ON `t_items` FOR EACH ROW BEGIN

DECLARE my_invoice_count INT;

DECLARE stock FLOAT;
DECLARE stock_average_cost FLOAT;

DECLARE this_qty FLOAT;
DECLARE this_cost FLOAT;
DECLARE this_type VARCHAR(100);

DECLARE stock_opening_qty FLOAT;
DECLARE stock_opening_cost FLOAT;

DECLARE items_count INT;
DECLARE i INT;

SET stock_opening_qty = (SELECT c_OpeningQty FROM t_stock WHERE c_ID = old.c_StockID);
SET stock_opening_cost = (SELECT c_OpeningCost FROM t_stock WHERE c_ID = old.c_StockID);


SET stock = stock_opening_qty;
SET stock_average_cost =0;

IF ( stock_opening_qty*stock_opening_cost>0 ) THEN

	SET stock_average_cost = ( stock*stock_opening_cost )/( stock );

END IF;

SET i =0;
SET items_count = (SELECT COUNT(c_ID) FROM t_items WHERE c_StockID = old.c_StockID);

WHILE items_count>i DO

    SET this_type = (SELECT c_InvoiceType FROM t_items WHERE c_StockID = old.c_StockID ORDER BY c_InvoiceID ASC LIMIT i,1 );
    SET this_qty = (SELECT c_Qty FROM t_items WHERE c_StockID = old.c_StockID ORDER BY c_InvoiceID ASC LIMIT i,1 );
    SET this_cost = (SELECT (c_Price)-( c_Price*( c_Discount/100 ) ) FROM t_items WHERE c_StockID = old.c_StockID ORDER BY c_InvoiceID ASC LIMIT i,1 );
    
    IF ( stock<0 ) THEN
    	SET stock = 0;
    END IF;
    
    IF ( this_type='Sale' ) THEN
    	SET stock = stock-this_qty;
    END IF;
    
    IF ( this_type='R Sale' ) THEN
    	SET stock = stock+this_qty;
    END IF;
    
    IF ( this_type='Purchase' ) THEN

        IF ( stock>0 ) THEN        
        	SET stock_average_cost = GREATEST( IFNULL( NULLIF( ( ( stock*stock_average_cost )+( this_qty*this_cost ) ) ,0)/NULLIF( ( stock+this_qty ) ,0) ,0) ,0);
        ELSE
        	SET stock_average_cost = this_cost;
        END IF;
        
        SET stock = stock+this_qty;

    END IF;
    
    IF ( this_type='R Purchase' ) THEN
        
        SET stock_average_cost = GREATEST( IFNULL( NULLIF( ( ( stock*stock_average_cost )-( this_qty*this_cost ) ) ,0)/NULLIF( ( stock-this_qty ) ,0) ,0) ,0);
        SET stock = stock-this_qty;
        
    END IF;
    
	SET i= i+1;

END WHILE;


UPDATE t_stock SET 

c_AverageCost= stock_average_cost,


c_PurchaseQty= IFNULL((SELECT SUM(c_Qty) FROM t_items WHERE c_StockID=old.c_StockID AND c_InvoiceType='Purchase'),0)-IFNULL((SELECT SUM(c_Qty)  FROM t_items WHERE c_StockID=old.c_StockID AND c_InvoiceType='R Purchase'),0),

c_SaleQty= IFNULL((SELECT SUM(c_Qty) FROM t_items WHERE c_StockID=old.c_StockID AND c_InvoiceType='Sale'),0)-IFNULL((SELECT SUM(c_Qty)  FROM t_items WHERE c_StockID=old.c_StockID AND c_InvoiceType='R Sale'),0),

c_SaleLossProfit= IFNULL((SELECT SUM( ( (c_Price*c_Qty) - ( (c_Price*c_Qty)*(c_Discount/100) ) ) -(c_StockAverageCost*c_Qty)) FROM t_items WHERE c_StockID=old.c_StockID AND c_InvoiceType='Sale'),0),

c_RSaleLossProfit= IFNULL((SELECT SUM(( (c_Price*c_Qty) - ( (c_Price*c_Qty)*(c_Discount/100) ) )-(c_StockAverageCost*c_Qty)) FROM t_items WHERE c_StockID=old.c_StockID AND c_InvoiceType='R Sale'),0)

WHERE c_ID=old.c_StockID;

SET my_invoice_count= ( SELECT COUNT(c_ID) FROM t_invoices WHERE c_ID =old.c_InvoiceID );

IF (  my_invoice_count !=0 ) THEN

    UPDATE t_invoices SET c_Total=IFNULL((SELECT SUM( (c_Price*c_Qty) - ( (c_Price*c_Qty)*(c_Discount/100) ) ) FROM t_items WHERE c_InvoiceID=old.c_InvoiceID), 0)  WHERE c_ID=old.c_InvoiceID;

END IF;


END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_insert_item` AFTER INSERT ON `t_items` FOR EACH ROW BEGIN

DECLARE stock FLOAT;
DECLARE stock_average_cost FLOAT;

DECLARE this_qty FLOAT;
DECLARE this_cost FLOAT;
DECLARE this_type VARCHAR(100);

DECLARE stock_opening_qty FLOAT;
DECLARE stock_opening_cost FLOAT;

DECLARE items_count INT;
DECLARE i INT;


IF new.c_InvoiceType='Sale' OR new.c_InvoiceType='R Sale' THEN	
    UPDATE t_stock SET c_Price= new.c_Price WHERE c_ID=new.c_StockID;    
ELSE
	UPDATE t_stock SET c_LastCost= new.c_Price WHERE c_ID=new.c_StockID;
END IF;

SET stock_opening_qty = (SELECT c_OpeningQty FROM t_stock WHERE c_ID = new.c_StockID);
SET stock_opening_cost = (SELECT c_OpeningCost FROM t_stock WHERE c_ID = new.c_StockID);


SET stock = stock_opening_qty;
SET stock_average_cost =0;

IF ( stock_opening_qty*stock_opening_cost>0 ) THEN

	SET stock_average_cost = ( stock*stock_opening_cost )/( stock );

END IF;

SET i =0;
SET items_count = (SELECT COUNT(c_ID) FROM t_items WHERE c_StockID = new.c_StockID);

WHILE items_count>i DO

    SET this_type = (SELECT c_InvoiceType FROM t_items WHERE c_StockID = new.c_StockID ORDER BY c_InvoiceID ASC LIMIT i,1 );
    SET this_qty = (SELECT c_Qty FROM t_items WHERE c_StockID = new.c_StockID ORDER BY c_InvoiceID ASC LIMIT i,1 );
    SET this_cost = (SELECT (c_Price)-( c_Price*( c_Discount/100 ) ) FROM t_items WHERE c_StockID = new.c_StockID ORDER BY c_InvoiceID ASC LIMIT i,1 );
    
    IF ( stock<0 ) THEN
    	SET stock = 0;
    END IF;
    
    IF ( this_type='Sale' ) THEN
    	SET stock = stock-this_qty;
    END IF;
    
    IF ( this_type='R Sale' ) THEN
    	SET stock = stock+this_qty;
    END IF;
    
    IF ( this_type='Purchase' ) THEN

        IF ( stock>0 ) THEN        
        	SET stock_average_cost = GREATEST( IFNULL( NULLIF( ( ( stock*stock_average_cost )+( this_qty*this_cost ) ) ,0)/NULLIF( ( stock+this_qty ) ,0) ,0) ,0);
        ELSE
        	SET stock_average_cost = this_cost;
        END IF;
        
        SET stock = stock+this_qty;

    END IF;
    
    IF ( this_type='R Purchase' ) THEN
        
        SET stock_average_cost = GREATEST( IFNULL( NULLIF( ( ( stock*stock_average_cost )-( this_qty*this_cost ) ) ,0)/NULLIF( ( stock-this_qty ) ,0) ,0) ,0);
        SET stock = stock-this_qty;
        
    END IF;
    
	SET i= i+1;

END WHILE;


UPDATE t_stock SET 

c_AverageCost= stock_average_cost ,

c_PurchaseQty= IFNULL((SELECT SUM( (c_Qty) ) FROM t_items WHERE c_StockID=new.c_StockID AND c_InvoiceType='Purchase'),0)-IFNULL((SELECT SUM( (c_Qty) ) FROM t_items WHERE c_StockID=new.c_StockID AND c_InvoiceType='R Purchase'),0),

c_SaleQty= IFNULL((SELECT SUM( (c_Qty) ) FROM t_items WHERE c_StockID=new.c_StockID AND c_InvoiceType='Sale'),0)-IFNULL((SELECT SUM( (c_Qty) ) FROM t_items WHERE c_StockID=new.c_StockID AND c_InvoiceType='R Sale'),0),

c_SaleLossProfit= IFNULL((SELECT SUM( ( (c_Price*c_Qty) - ( (c_Price*c_Qty)*(c_Discount/100) ) ) - (c_StockAverageCost*c_Qty)) FROM t_items WHERE c_StockID=new.c_StockID AND c_InvoiceType='Sale'),0),

c_RSaleLossProfit= IFNULL((SELECT SUM(( (c_Price*c_Qty) - ( (c_Price*c_Qty)*(c_Discount/100) ) )-(c_StockAverageCost*c_Qty)) FROM t_items WHERE c_StockID=new.c_StockID AND c_InvoiceType='R Sale'),0)

WHERE c_ID=new.c_StockID;

UPDATE t_invoices SET c_Total=(SELECT SUM((c_Price*c_Qty)-((c_Price*c_Qty))*(c_Discount/100)) FROM t_items WHERE c_InvoiceID=new.c_InvoiceID)
WHERE c_ID=new.c_InvoiceID;



END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_item` BEFORE INSERT ON `t_items` FOR EACH ROW BEGIN

SET new.c_Branch = (SELECT c_Branch FROM t_invoices WHERE c_ID = new.c_InvoiceID);

SET new.c_StockName =(SELECT c_Name FROM t_stock WHERE c_ID =new.c_StockID AND c_Branch = new.c_Branch);

SET new.c_StockAverageCost =(SELECT c_AverageCost FROM t_stock WHERE c_ID =new.c_StockID AND c_Branch = new.c_Branch);

SET new.c_InvoiceDate =(SELECT c_Date FROM t_invoices WHERE c_ID =new.c_InvoiceID AND c_Branch = new.c_Branch);

SET new.c_StockCategory1 =(SELECT c_Category1 FROM t_stock WHERE c_ID =new.c_StockID AND c_Branch = new.c_Branch);
SET new.c_StockCategory2 =(SELECT c_Category2 FROM t_stock WHERE c_ID =new.c_StockID AND c_Branch = new.c_Branch);
SET new.c_StockCategory3 =(SELECT c_Category3 FROM t_stock WHERE c_ID =new.c_StockID AND c_Branch = new.c_Branch);
SET new.c_StockCategory4 =(SELECT c_Category4 FROM t_stock WHERE c_ID =new.c_StockID AND c_Branch = new.c_Branch);
SET new.c_StockCategory5 =(SELECT c_Category5 FROM t_stock WHERE c_ID =new.c_StockID AND c_Branch = new.c_Branch);
SET new.c_StockCategory6 =(SELECT c_Category6 FROM t_stock WHERE c_ID =new.c_StockID AND c_Branch = new.c_Branch);
SET new.c_StockCategory7 =(SELECT c_Category7 FROM t_stock WHERE c_ID =new.c_StockID AND c_Branch = new.c_Branch);
SET new.c_StockCategory8 =(SELECT c_Category8 FROM t_stock WHERE c_ID =new.c_StockID AND c_Branch = new.c_Branch);

SET new.c_InvoiceType =(SELECT c_Type FROM t_invoices WHERE c_ID =new.c_InvoiceID AND c_Branch = new.c_Branch);

SET new.c_AccountID =(SELECT c_AccountID FROM t_invoices WHERE c_ID =new.c_InvoiceID);

SET new.c_AccountName =(SELECT c_AccountName FROM t_invoices WHERE c_ID =new.c_InvoiceID);

SET new.c_SecondAccountID =(SELECT c_SecondAccountID FROM t_invoices WHERE c_ID =new.c_InvoiceID);

SET new.c_SecondAccountName =(SELECT c_SecondAccountName FROM t_invoices WHERE c_ID =new.c_InvoiceID);

SET new.c_UserID = (SELECT c_UserID FROM t_invoices WHERE c_ID = new.c_InvoiceID);
SET new.c_UserName = (SELECT c_Name FROM t_users WHERE c_ID = new.c_UserID);
IF ( new.c_UserName ='' OR new.c_UserName IS NULL ) THEN
    SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'Incorrect User Name';
END IF;

IF ( new.c_StockName IS NULL ) THEN
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'Incorrect Stock Name';
END IF;


IF ( (new.c_Discount/100) >1 OR (new.c_Discount/100) <0) THEN
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'Incorrect Discount';
END IF;

IF !( ( (new.c_Price*new.c_Qty) )-( (new.c_Price*new.c_Qty) *(new.c_Discount/100) ) >0) THEN
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'Incorrect Ammount';
END IF;


END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_update_item` BEFORE UPDATE ON `t_items` FOR EACH ROW BEGIN

#SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Items Update Disabled' ;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `t_journal`
--

CREATE TABLE `t_journal` (
  `c_ID` int(11) NOT NULL,
  `c_Branch` varchar(100) NOT NULL,
  `c_ParentID` int(11) NOT NULL,
  `c_Type` varchar(100) NOT NULL,
  `c_AccountID` int(11) NOT NULL,
  `c_AccountName` varchar(100) NOT NULL,
  `c_AccountType` varchar(100) NOT NULL,
  `c_Debit` float NOT NULL,
  `c_Credit` float NOT NULL,
  `c_Date` date DEFAULT NULL,
  `c_UserID` int(11) NOT NULL,
  `c_UserName` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `t_journal`
--
DELIMITER $$
CREATE TRIGGER `after_delete_journal` AFTER DELETE ON `t_journal` FOR EACH ROW BEGIN

UPDATE t_accounts SET 
    c_Debit=IFNULL((SELECT SUM(c_Debit) FROM t_journal WHERE c_AccountID=old.c_AccountID ),0),

    c_Credit=IFNULL((SELECT SUM(c_Credit) FROM t_journal WHERE c_AccountID=old.c_AccountID ),0)

WHERE c_ID=old.c_AccountID;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_insert_journal` AFTER INSERT ON `t_journal` FOR EACH ROW BEGIN

UPDATE t_accounts SET 
    c_Debit=IFNULL((SELECT SUM(c_Debit) FROM t_journal WHERE c_AccountID=new.c_AccountID ),0),

    c_Credit=IFNULL((SELECT SUM(c_Credit) FROM t_journal WHERE c_AccountID=new.c_AccountID ),0)
WHERE c_ID=new.c_AccountID;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_update_journal` AFTER UPDATE ON `t_journal` FOR EACH ROW BEGIN

UPDATE t_accounts SET 
    c_Debit=IFNULL((SELECT SUM(c_Debit) FROM t_journal WHERE c_AccountID=new.c_AccountID),0),

    c_Credit=IFNULL((SELECT SUM(c_Credit) FROM t_journal WHERE c_AccountID=new.c_AccountID),0)

WHERE c_ID=new.c_AccountID;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `t_payments`
--

CREATE TABLE `t_payments` (
  `c_ID` int(11) NOT NULL,
  `c_Branch` varchar(100) DEFAULT NULL,
  `c_Type` varchar(100) NOT NULL,
  `c_AccountType` varchar(100) DEFAULT NULL,
  `c_AccountID` int(11) NOT NULL,
  `c_AccountName` varchar(100) DEFAULT NULL,
  `c_SecondAccountType` varchar(100) NOT NULL,
  `c_SecondAccountID` int(11) DEFAULT NULL,
  `c_SecondAccountName` varchar(100) DEFAULT NULL,
  `c_Date` date DEFAULT NULL,
  `c_Ammount` float NOT NULL,
  `c_Memo` varchar(100) DEFAULT NULL,
  `c_UserID` int(11) NOT NULL,
  `c_UserName` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `t_payments`
--
DELIMITER $$
CREATE TRIGGER `after_insert_payment` AFTER INSERT ON `t_payments` FOR EACH ROW BEGIN

DECLARE my_debit FLOAT;
DECLARE my_credit FLOAT;
DECLARE my_second_debit FLOAT;
DECLARE my_second_credit FLOAT;
    
IF new.c_Type='Receipt' THEN
	SET my_debit=0;
	SET my_credit=new.c_Ammount;
	SET my_second_debit=new.c_Ammount;
	SET my_second_credit=0;
ELSE
	SET my_debit=new.c_Ammount;
	SET my_credit=0;
	SET my_second_debit=0;
	SET my_second_credit=new.c_Ammount;
END IF;
    
INSERT INTO `t_journal` (`c_ParentID`,`c_Branch`, `c_Type`, `c_AccountID`, `c_AccountName`, `c_AccountType`, `c_Debit`, `c_Credit`, `c_Date`, `c_UserID`, `c_UserName`) VALUES 
   
(new.c_ID, new.c_Branch, new.c_Type, new.c_SecondAccountID, new.c_SecondAccountName, new.c_SecondAccountType, my_second_debit, my_second_credit, new.c_Date, new.c_UserID, new.c_UserName),

(new.c_ID, new.c_Branch, new.c_Type, new.c_AccountID, new.c_AccountName, new.c_AccountType, my_debit, my_credit, new.c_Date, new.c_UserID, new.c_UserName);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_delete_payment` BEFORE DELETE ON `t_payments` FOR EACH ROW BEGIN

DELETE FROM t_journal WHERE c_ParentID =old.c_ID AND c_Type =old.c_Type;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_payment` BEFORE INSERT ON `t_payments` FOR EACH ROW BEGIN

SET new.c_Date =CURRENT_DATE;
set NEW.c_ID = (SELECT SUM(c_ID) FROM t_transaction_id LIMIT 1);
UPDATE t_transaction_id SET c_ID=c_ID+1;

IF !(new.c_Ammount >0) THEN
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'Incorrect Ammount Value';
END IF;

IF( new.c_Type!='Payment' ) THEN
	SET new.c_Type ='Receipt';
END IF;

SET new.c_UserName = (SELECT c_Name FROM t_users WHERE c_ID = new.c_UserID);
IF ( new.c_UserName ='' OR new.c_UserName IS NULL ) THEN
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'Incorrect User Value';
END IF;

SET new.c_AccountName =(SELECt c_Name FROM t_accounts WHERE c_ID =new.c_AccountID);
SET new.c_AccountType =(SELECt c_Type FROM t_accounts WHERE c_ID =new.c_AccountID);
SET new.c_Branch = (SELECT c_Branch FROM t_accounts WHERE c_ID = new.c_AccountID);
SET new.c_SecondAccountName =(SELECt c_Name FROM t_accounts WHERE c_ID =new.c_SecondAccountID AND c_Branch = new.c_Branch);
SET new.c_SecondAccountType =(SELECt c_Type FROM t_accounts WHERE c_ID =new.c_SecondAccountID AND c_Branch = new.c_Branch);
       
IF ( new.c_AccountName ='' ) OR ( new.c_AccountName IS NULL ) THEN
	SIGNAL SQLSTATE '45000'
   	SET MESSAGE_TEXT = 'Incorrect Account Name';
END IF;
        
IF ( new.c_SecondAccountName ='' ) OR ( new.c_SecondAccountName IS NULL ) THEN
	SET new.c_SecondAccountName =(SELECt c_Name FROM t_accounts WHERE c_Basic ='petty_cash' AND c_Branch = new.c_Branch);
    SET new.c_SecondAccountType =(SELECt c_Type FROM t_accounts WHERE c_Basic ='petty_cash' AND c_Branch = new.c_Branch);
    SET new.c_SecondAccountID =(SELECt c_ID FROM t_accounts WHERE c_Basic ='petty_cash' AND c_Branch = new.c_Branch);
END IF;
        
IF ( new.c_SecondAccountName ='' ) OR ( new.c_SecondAccountName IS NULL ) THEN
	SIGNAL SQLSTATE '45000'
   	SET MESSAGE_TEXT = 'Incorrect Second Account Name ';
END IF;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_update_payment` BEFORE UPDATE ON `t_payments` FOR EACH ROW BEGIN

DECLARE my_debit FLOAT;
DECLARE my_credit FLOAT;
DECLARE my_second_debit FLOAT;
DECLARE my_second_credit FLOAT;

SET new.c_ID = old.c_ID;
SET new.c_Branch = old.c_Branch;
SET new.c_Type = old.c_Type;
SET new.c_AccountID = old.c_AccountID;
SET new.c_AccountType = old.c_AccountType;
SET new.c_AccountName = old.c_AccountName;
SET new.c_SecondAccountID = old.c_SecondAccountID;
SET new.c_SecondAccountName = old.c_SecondAccountName;
SET new.c_Date = old.c_Date;
SET new.c_UserID = old.c_UserID;
SET new.c_UserName = old.c_UserName;

IF !(new.c_Ammount >0) THEN
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'Incorrect Ammount Value';
END IF;
	
IF new.c_Type='Receipt' THEN
	SET my_debit=0;
	SET my_credit=new.c_Ammount;
	SET my_second_debit=new.c_Ammount;
	SET my_second_credit=0;
ELSE
	SET my_debit=new.c_Ammount;
	SET my_credit=0;
	SET my_second_debit=0;
	SET my_second_credit=new.c_Ammount;
END IF;

DELETE FROM t_journal WHERE c_ParentID = new.c_ID;
INSERT INTO `t_journal` (`c_ParentID`,`c_Branch`, `c_Type`, `c_AccountID`, `c_AccountName`, `c_AccountType`, `c_Debit`, `c_Credit`, `c_Date`, `c_UserID`, `c_UserName`) VALUES 
   
(new.c_ID, new.c_Branch, new.c_Type, new.c_SecondAccountID, new.c_SecondAccountName, new.c_SecondAccountType, my_second_debit, my_second_credit, new.c_Date, new.c_UserID, new.c_UserName),

(new.c_ID, new.c_Branch, new.c_Type, new.c_AccountID, new.c_AccountName, new.c_AccountType, my_debit, my_credit, new.c_Date, new.c_UserID, new.c_UserName);

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `t_stock`
--

CREATE TABLE `t_stock` (
  `c_ID` int(11) NOT NULL,
  `c_Branch` varchar(100) NOT NULL,
  `c_Name` varchar(200) NOT NULL,
  `c_OpeningQty` float DEFAULT 0,
  `c_OpeningCost` float DEFAULT 0,
  `c_LastCost` float DEFAULT 0,
  `c_AverageCost` float DEFAULT 0,
  `c_Price` float DEFAULT 0,
  `c_Minimum` float DEFAULT 0,
  `c_Maximum` int(11) DEFAULT 0,
  `c_Category1` varchar(100) DEFAULT 'NULL',
  `c_Category2` varchar(100) DEFAULT NULL,
  `c_Category3` varchar(100) DEFAULT NULL,
  `c_Category4` varchar(100) DEFAULT NULL,
  `c_Category5` varchar(100) DEFAULT NULL,
  `c_Category6` varchar(100) DEFAULT NULL,
  `c_Category7` varchar(100) DEFAULT NULL,
  `c_Category8` varchar(100) DEFAULT NULL,
  `c_Memo` varchar(100) DEFAULT NULL,
  `c_PurchaseQty` float DEFAULT 0,
  `c_SaleQty` float DEFAULT 0,
  `c_SaleLossProfit` float DEFAULT 0,
  `c_RSaleLossProfit` float DEFAULT 0,
  `c_UserID` int(11) NOT NULL,
  `c_UserName` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `t_stock`
--
DELIMITER $$
CREATE TRIGGER `before_insert_product` BEFORE INSERT ON `t_stock` FOR EACH ROW BEGIN
    
SET new.c_LastCost = new.c_OpeningCost;
    
SET new.c_AverageCost = IFNULL( ( new.c_OpeningCost*new.c_OpeningQty )/(new.c_OpeningQty), 0);
    
SET new.c_Branch = (SELECT c_Branch FROM t_branches WHERE c_Branch = new.c_Branch);
    
SET new.c_UserName = (SELECT c_Name FROM t_users WHERE c_ID = new.c_UserID);
IF ( new.c_UserName ='' OR new.c_UserName IS NULL ) THEN
    SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'Incorrect User Value';
END IF;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_update_product` BEFORE UPDATE ON `t_stock` FOR EACH ROW BEGIN
DECLARE stock FLOAT;
DECLARE stock_average_cost FLOAT;

DECLARE this_qty FLOAT;
DECLARE this_cost FLOAT;
DECLARE this_type VARCHAR(100);

DECLARE stock_opening_qty FLOAT;
DECLARE stock_opening_cost FLOAT;

DECLARE items_count INT;
DECLARE i INT;

IF ( new.c_SaleQty!=0 OR new.c_PurchaseQty!=0 ) THEN
	SET new.c_Name = old.c_Name;
END IF;

SET new.c_ID = old.c_ID;
SET new.c_Branch = old.c_Branch;
SET new.c_UserID = old.c_UserID;
SET new.c_UserName = old.c_UserName;


SET stock_opening_qty = new.c_OpeningQty;
SET stock_opening_cost = new.c_OpeningCost;


SET stock = stock_opening_qty;
SET stock_average_cost =0;

IF ( stock_opening_qty*stock_opening_cost>0 ) THEN

	SET stock_average_cost = ( stock*stock_opening_cost )/( stock );

END IF;

SET i =0;
SET items_count = (SELECT COUNT(c_ID) FROM t_items WHERE c_StockID = new.c_ID);

WHILE items_count>i DO

    SET this_type = (SELECT c_InvoiceType FROM t_items WHERE c_StockID = new.c_ID ORDER BY c_InvoiceID ASC LIMIT i,1 );
    SET this_qty = (SELECT c_Qty FROM t_items WHERE c_StockID = new.c_ID ORDER BY c_InvoiceID ASC LIMIT i,1 );
    SET this_cost = (SELECT (c_Price)-( c_Price*( c_Discount/100 ) ) FROM t_items WHERE c_StockID = new.c_ID ORDER BY c_InvoiceID ASC LIMIT i,1 );
    
    IF ( stock<0 ) THEN
    	SET stock = 0;
    END IF;
    
    IF ( this_type='Sale' ) THEN
    	SET stock = stock-this_qty;
    END IF;
    
    IF ( this_type='R Sale' ) THEN
    	SET stock = stock+this_qty;
    END IF;
    
    IF ( this_type='Purchase' ) THEN

        IF ( stock>0 ) THEN        
        	SET stock_average_cost = GREATEST( IFNULL( NULLIF( ( ( stock*stock_average_cost )+( this_qty*this_cost ) ) ,0)/NULLIF( ( stock+this_qty ) ,0) ,0) ,0);
        ELSE
        	SET stock_average_cost = this_cost;
        END IF;
        
        SET stock = stock+this_qty;

    END IF;
    
    IF ( this_type='R Purchase' ) THEN
        
        SET stock_average_cost = GREATEST( IFNULL( NULLIF( ( ( stock*stock_average_cost )-( this_qty*this_cost ) ) ,0)/NULLIF( ( stock-this_qty ) ,0) ,0) ,0);
        SET stock = stock-this_qty;
        
    END IF;
    
	SET i= i+1;

END WHILE;


IF ( new.c_OpeningQty!=new.c_OpeningQty OR new.c_OpeningCost!=new.c_OpeningCost ) THEN
	SET new.c_AverageCost= stock_average_cost;
END IF;


END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `t_transaction_id`
--

CREATE TABLE `t_transaction_id` (
  `c_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `t_transaction_id`
--

INSERT INTO `t_transaction_id` (`c_ID`) VALUES
(2162);

--
-- Triggers `t_transaction_id`
--
DELIMITER $$
CREATE TRIGGER `before_delete_transaction_id` BEFORE DELETE ON `t_transaction_id` FOR EACH ROW BEGIN
	IF ( (SELECT COUNT(c_ID) FROM t_transaction_id )=1 ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Can not Empty Table';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_insert_transaction_id` BEFORE INSERT ON `t_transaction_id` FOR EACH ROW BEGIN

	IF ( (SELECT COUNT(c_ID) FROM t_transaction_id )=1 ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Can not Have More Than One Recored';
    END IF;
    
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_update_transaction_id` BEFORE UPDATE ON `t_transaction_id` FOR EACH ROW BEGIN
	IF ( old.c_ID>new.c_ID ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Wrong ID Value';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `t_users`
--

CREATE TABLE `t_users` (
  `c_ID` int(11) NOT NULL,
  `c_Branch` varchar(100) NOT NULL,
  `c_Name` varchar(100) NOT NULL,
  `c_Password` longtext NOT NULL,
  `c_ViewAccount` varchar(5) DEFAULT NULL,
  `c_InsertAccount` varchar(5) DEFAULT NULL,
  `c_UpdateAccount` varchar(5) DEFAULT NULL,
  `c_DeleteAccount` varchar(5) DEFAULT NULL,
  `c_ExportAccounts` varchar(5) DEFAULT NULL,
  `c_ViewStock` varchar(5) DEFAULT NULL,
  `c_InsertStock` varchar(5) DEFAULT NULL,
  `c_UpdateStock` varchar(5) DEFAULT NULL,
  `c_DeleteStock` varchar(5) DEFAULT NULL,
  `c_AllItems` varchar(5) DEFAULT 'NULL',
  `c_Cost` varchar(5) DEFAULT 'NULL',
  `c_ExportStock` varchar(5) DEFAULT NULL,
  `c_ViewSale` varchar(5) DEFAULT NULL,
  `c_InsertSale` varchar(5) DEFAULT NULL,
  `c_UpdateSale` varchar(5) DEFAULT NULL,
  `c_DeleteSale` varchar(5) DEFAULT NULL,
  `c_ViewRSale` varchar(5) DEFAULT NULL,
  `c_InsertRSale` varchar(5) DEFAULT NULL,
  `c_UpdateRSale` varchar(5) DEFAULT NULL,
  `c_DeleteRSale` varchar(5) DEFAULT NULL,
  `c_ViewPurchase` varchar(5) DEFAULT NULL,
  `c_InsertPurchase` varchar(5) DEFAULT NULL,
  `c_UpdatePurchase` varchar(5) DEFAULT NULL,
  `c_DeletePurchase` varchar(5) DEFAULT NULL,
  `c_ViewRPurchase` varchar(5) DEFAULT NULL,
  `c_InsertRPurchase` varchar(5) DEFAULT NULL,
  `c_UpdateRPurchase` varchar(5) DEFAULT NULL,
  `c_DeleteRPurchase` varchar(5) DEFAULT NULL,
  `c_ViewIncome` varchar(5) DEFAULT NULL,
  `c_InsertIncome` varchar(5) DEFAULT NULL,
  `c_UpdateIncome` varchar(5) DEFAULT NULL,
  `c_DeleteIncome` varchar(5) DEFAULT NULL,
  `c_ViewOutcome` varchar(5) DEFAULT NULL,
  `c_InsertOutcome` varchar(5) DEFAULT NULL,
  `c_UpdateOutcome` varchar(5) DEFAULT NULL,
  `c_DeleteOutcome` varchar(5) DEFAULT NULL,
  `c_ViewReceipt` varchar(5) DEFAULT NULL,
  `c_InsertReceipt` varchar(5) DEFAULT NULL,
  `c_UpdateReceipt` varchar(5) DEFAULT NULL,
  `c_DeleteReceipt` varchar(5) DEFAULT NULL,
  `c_ViewPayment` varchar(5) DEFAULT NULL,
  `c_InsertPayment` varchar(5) DEFAULT NULL,
  `c_UpdatePayment` varchar(5) DEFAULT NULL,
  `c_DeletePayment` varchar(5) DEFAULT NULL,
  `c_AllBranches` varchar(5) DEFAULT NULL,
  `c_Journal` varchar(5) DEFAULT NULL,
  `c_ExportJournal` varchar(5) DEFAULT NULL,
  `c_Users` varchar(5) DEFAULT NULL,
  `c_LossProfit` varchar(5) DEFAULT NULL,
  `c_BackUp` varchar(5) DEFAULT NULL,
  `c_Restore` varchar(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `t_users`
--

INSERT INTO `t_users` (`c_ID`, `c_Branch`, `c_Name`, `c_Password`, `c_ViewAccount`, `c_InsertAccount`, `c_UpdateAccount`, `c_DeleteAccount`, `c_ExportAccounts`, `c_ViewStock`, `c_InsertStock`, `c_UpdateStock`, `c_DeleteStock`, `c_AllItems`, `c_Cost`, `c_ExportStock`, `c_ViewSale`, `c_InsertSale`, `c_UpdateSale`, `c_DeleteSale`, `c_ViewRSale`, `c_InsertRSale`, `c_UpdateRSale`, `c_DeleteRSale`, `c_ViewPurchase`, `c_InsertPurchase`, `c_UpdatePurchase`, `c_DeletePurchase`, `c_ViewRPurchase`, `c_InsertRPurchase`, `c_UpdateRPurchase`, `c_DeleteRPurchase`, `c_ViewIncome`, `c_InsertIncome`, `c_UpdateIncome`, `c_DeleteIncome`, `c_ViewOutcome`, `c_InsertOutcome`, `c_UpdateOutcome`, `c_DeleteOutcome`, `c_ViewReceipt`, `c_InsertReceipt`, `c_UpdateReceipt`, `c_DeleteReceipt`, `c_ViewPayment`, `c_InsertPayment`, `c_UpdatePayment`, `c_DeletePayment`, `c_AllBranches`, `c_Journal`, `c_ExportJournal`, `c_Users`, `c_LossProfit`, `c_BackUp`, `c_Restore`) VALUES
(20, 'Branch 1', 'admin', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true', 'true');

--
-- Triggers `t_users`
--
DELIMITER $$
CREATE TRIGGER `before_insert_user` BEFORE INSERT ON `t_users` FOR EACH ROW BEGIN

	SET new.c_Branch = (SELECT c_Branch FROM t_branches WHERE c_Branch = new.C_Branch);

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_update_user` BEFORE UPDATE ON `t_users` FOR EACH ROW BEGIN

SET new.c_ID = old.c_ID;
SET new.c_Name = old.c_Name;

END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `t_accounts`
--
ALTER TABLE `t_accounts`
  ADD PRIMARY KEY (`c_ID`);

--
-- Indexes for table `t_branches`
--
ALTER TABLE `t_branches`
  ADD PRIMARY KEY (`c_ID`);

--
-- Indexes for table `t_invoices`
--
ALTER TABLE `t_invoices`
  ADD PRIMARY KEY (`c_ID`);

--
-- Indexes for table `t_items`
--
ALTER TABLE `t_items`
  ADD PRIMARY KEY (`c_ID`);

--
-- Indexes for table `t_journal`
--
ALTER TABLE `t_journal`
  ADD PRIMARY KEY (`c_ID`);

--
-- Indexes for table `t_payments`
--
ALTER TABLE `t_payments`
  ADD PRIMARY KEY (`c_ID`);

--
-- Indexes for table `t_stock`
--
ALTER TABLE `t_stock`
  ADD PRIMARY KEY (`c_ID`);

--
-- Indexes for table `t_transaction_id`
--
ALTER TABLE `t_transaction_id`
  ADD PRIMARY KEY (`c_ID`);

--
-- Indexes for table `t_users`
--
ALTER TABLE `t_users`
  ADD PRIMARY KEY (`c_ID`),
  ADD UNIQUE KEY `c_Name` (`c_Name`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `t_accounts`
--
ALTER TABLE `t_accounts`
  MODIFY `c_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `t_branches`
--
ALTER TABLE `t_branches`
  MODIFY `c_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `t_invoices`
--
ALTER TABLE `t_invoices`
  MODIFY `c_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2162;

--
-- AUTO_INCREMENT for table `t_items`
--
ALTER TABLE `t_items`
  MODIFY `c_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5020;

--
-- AUTO_INCREMENT for table `t_journal`
--
ALTER TABLE `t_journal`
  MODIFY `c_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=323069;

--
-- AUTO_INCREMENT for table `t_payments`
--
ALTER TABLE `t_payments`
  MODIFY `c_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2156;

--
-- AUTO_INCREMENT for table `t_stock`
--
ALTER TABLE `t_stock`
  MODIFY `c_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `t_users`
--
ALTER TABLE `t_users`
  MODIFY `c_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
