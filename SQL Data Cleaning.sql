

/* cleaning data */

Select *
From [PortfolioProjetCleaning].[dbo].[Nashvill]


/* Standardize Date Format */


alter table [dbo].[Nashvill]
add salesdateconverted date


update [dbo].[Nashvill]
set salesdateconverted = CONVERT(Date,SaleDate)


select salesdateconverted 
from [dbo].[Nashvill]



/* Populate Property Address data */



select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from [dbo].[Nashvill] a join  [dbo].[Nashvill] b
  on a.ParcelID = b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is null



  update a 
  set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
  from [dbo].[Nashvill] a join  [dbo].[Nashvill] b
  on a.ParcelID = b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is null

/* Breaking out Address into Individual Columns (Address, City, State) */

select  PropertyAddress
from [dbo].[Nashvill]




SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From [PortfolioProjetCleaning].[dbo].[Nashvill]



alter table [dbo].[Nashvill]
add PropertySplitAdress varchar(50)


update [dbo].[Nashvill]
set PropertySplitAdress =SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) 


alter table [dbo].[Nashvill]
add PropertySplitCity varchar(50)


update [dbo].[Nashvill]
set PropertySplitCity =  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


select *
from [dbo].[Nashvill]



Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [PortfolioProjetCleaning].[dbo].[Nashvill]


alter table [dbo].[Nashvill]
add OwnerSplitAddress varchar(50)


update [dbo].[Nashvill]
set OwnerSplitAddress =PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


alter table [dbo].[Nashvill]
add OwnerSplitCity varchar(50)

update [dbo].[Nashvill]
set OwnerSplitCity =PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


alter table [dbo].[Nashvill]
add OwnerSplitState varchar(50)


update [dbo].[Nashvill]
set OwnerSplitState =PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


select *
from [dbo].[Nashvill]




/* Change Y and N to Yes and No in "Sold as Vacant" field */

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [PortfolioProjetCleaning].[dbo].[Nashvill]
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [PortfolioProjetCleaning].[dbo].[Nashvill]


Update [PortfolioProjetCleaning].[dbo].[Nashvill]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END



/* Remove Duplicates */
WITH RowNumCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY ParcelID,
                         PropertyAddress,
                         SalePrice,
                         SaleDate,
                         LegalReference
            ORDER BY UniqueID
        ) AS row_num
    FROM [PortfolioProjetCleaning].[dbo].[Nashvill]
)


DELETE FROM RowNumCTE
WHERE row_num > 1;

SELECT *
FROM RowNumCTE;

Select *
From [PortfolioProjetCleaning].[dbo].[Nashvill]


 /* Delete Unused Columns */



Select *
From [PortfolioProjetCleaning].[dbo].[Nashvill]


ALTER TABLE [PortfolioProjetCleaning].[dbo].[Nashvill]
DROP COLUMN salesdateconverted



Select *
From [PortfolioProjetCleaning].[dbo].[Nashvill]