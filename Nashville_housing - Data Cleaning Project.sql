/* 
Cleaning data project

Nashville housing dataset

Skills used: Joins and Self Joins, Windows, CTE's,CASE statement
*/

use nashv_housing;

-- overview
SELECT 
    *
FROM
    housing_data
LIMIT 100;

-- standarize date format
SELECT 
    SaleDate
FROM
    housing_data
ORDER BY saledate;

SELECT 
    SaleDate,
    STR_TO_DATE(SaleDate, '%m/%d/%Y') AS converted_date
FROM
    housing_data;

commit;

UPDATE housing_data 
SET 
    SaleDate = STR_TO_DATE(SaleDate, '%m/%d/%Y');
    
-- Populate Property Address data
-- Adding the property address into rows where the property is the same but the addres is missing

ALTER TABLE housing_data MODIFY COLUMN PropertyAddress varchar(250) NULL; -- Adding Null in the cells with no values

commit;

UPDATE housing_data 
SET 
    propertyaddress = NULL
WHERE
    propertyaddress = '';

commit;
    
SELECT 
    a.parcelid,
    a.propertyaddress,
    b.parcelid,
    b.propertyaddress,
    IFNULL(a.propertyaddress, b.propertyaddress)
FROM
    housing_data a
        JOIN
    housing_data b ON a.parcelid = b.parcelid
        AND a.uniqueid <> b.uniqueid
WHERE
    a.propertyaddress IS NULL;
    
UPDATE housing_data a
        JOIN
    housing_data b ON a.parcelid = b.parcelid
        AND a.uniqueid <> b.uniqueid 
SET 
    a.propertyaddress = IFNULL(a.propertyaddress, b.propertyaddress)
WHERE
    a.propertyaddress IS NULL;
    
-- Separate property address into individual columns (address and city)

SELECT 
    SUBSTRING(propertyaddress,
        1,
        INSTR(propertyaddress, ',') - 1) AS Address,
    SUBSTRING(propertyaddress,
        INSTR(propertyaddress, ',') + 1) AS City
FROM
    housing_data;
    
commit;

Alter table housing_data
Add PropertySplitAddress varchar(255);

Alter table housing_data
Add PropertyCity varchar(255);

UPDATE housing_data 
SET 
    PropertySplitAddress = SUBSTRING(propertyaddress,
        1,
        INSTR(propertyaddress, ',') - 1);

UPDATE housing_data 
SET 
    PropertyCity = SUBSTRING(propertyaddress,
        INSTR(propertyaddress, ',') + 1);

-- Separate owner's address into individual columns (address, city and state)

SELECT 
    owneraddress
FROM
    housing_data;

SELECT 
    SUBSTRING_INDEX(owneraddress, ',', 1) AS OwnerSplitAddress,
    SUBSTRING_INDEX(SUBSTRING_INDEX(owneraddress, ',', - 2),
            ',',
            1) AS OwnerCity,
    SUBSTRING_INDEX(owneraddress, ',', - 1) AS OwnerState
FROM
    housing_data;
    
commit;

Alter table housing_data
Add OwnerSplitAddress varchar(255);
Alter table housing_data
Add OwnerCity varchar(255);
Alter table housing_data
add OwnerState varchar(255);

UPDATE housing_data 
SET 
    OwnerSplitAddress = SUBSTRING_INDEX(owneraddress, ',', 1);
    
UPDATE housing_data 
SET 
    OwnerCity = SUBSTRING_INDEX(SUBSTRING_INDEX(owneraddress, ',', - 2),
            ',',
            1);

UPDATE housing_data 
SET 
    OwnerState = SUBSTRING_INDEX(owneraddress, ',', - 1);
    
-- Change the values 'Y' and 'N' in the SoldasVacant column to Yes and No

SELECT DISTINCT
    (soldasvacant), COUNT(soldasvacant)
FROM
    housing_data
GROUP BY soldasvacant;

SELECT 
    soldasvacant,
    CASE
        WHEN soldasvacant = 'Y' THEN 'Yes'
        WHEN soldasvacant = 'N' THEN 'No'
        ELSE soldasvacant
    END
FROM
    housing_data;

commit;

UPDATE housing_data 
SET 
    soldasvacant = CASE
        WHEN soldasvacant = 'Y' THEN 'Yes'
        WHEN soldasvacant = 'N' THEN 'No'
        ELSE soldasvacant
    END;
    
-- Remove Duplicates

SELECT DISTINCT -- no duplicate UniqueID
    (uniqueid), COUNT(uniqueid)
FROM
    housing_data
GROUP BY uniqueid
ORDER BY COUNT(uniqueid) DESC;


With duplicates As -- looking for duplicate rows even thou there aren't duplicate uniqueID
(
Select
*,
Row_number() over (partition by parcelid,propertyaddress,saleprice,saledate,legalreference order by uniqueid) as row_num
From housing_data
Order by parcelid
)
Select * 
From duplicates 
Where row_num > 1 
Order by row_num desc;

-- Eliminating duplicates
commit;

Create temporary table duplicates
Select
*,
Row_number() over (partition by parcelid,propertyaddress,saleprice,saledate,legalreference order by uniqueid) as row_num
From housing_data
Order by parcelid;

SELECT 
    *
FROM
    duplicates
LIMIT 100;

commit;

DELETE h FROM housing_data h
        JOIN
    duplicates d ON h.uniqueid = d.uniqueid 
WHERE
    d.row_num > 1;

-- Deleting Unused Columns
commit;

Alter table housing_data
Drop column PropertyAddress,drop column OwnerAddress;

-- Organizing column postions
commit;

Alter table housing_data
Change PropertySplitAddress PropertyAddress varchar(255) AFTER LandUse;

Alter table housing_data
Change PropertyCity PropertyCity varchar(255) AFTER PropertyAddress;

Alter table housing_data
Change OwnerSplitAddress OwnerAddress varchar(255) After OwnerName;

Alter table housing_data
Change OwnerCity OwnerCity varchar(255) AFTER OwnerAddress;

Alter table housing_data
Change OwnerState OwnerState varchar(255) AFTER OwnerCity;
