-- Cleaning Data in SQL Queries

--Standarize Date Format
SELECT SaleDate From NashvilleHousing

ALTER TABLE NashvilleHousing
ALTER COLUMN Saledate Date

--Populate Property Adress Data

SELECT a.ParcelID,a.PropertyAddress,a.ParcelID,b.PropertyAddress, ISNULL( a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b ON
a.ParcelID = b.ParcelID
AND
a.[UniqueID ]<> b.[UniqueID ]
WHERE a.PropertyAddress is NULL

-- Breaking out Address into different columns( city, State, Address)



SELECT PropertyAddress, SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)AS Address,
SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))
FROM NashvilleHousing AS City

Alter Table NashvilleHousing 
ADD PropertySplitAddress nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


Alter Table NashvilleHousing 
ADD PropertySplitCity nvarchar(255)

UPDATE NashvilleHousing
SET PropertySplitCity =  SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select OwnerAddress from NashvilleHousing

SELECT PARSENAME(REPLACE( OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE( OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE( OwnerAddress, ',', '.'), 1)
FROM NashvilleHousing

Alter Table NashvilleHousing 
ADD OwnerSplitAddress nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE( OwnerAddress, ',', '.'), 3)


Alter Table NashvilleHousing 
ADD OwnerSplitCity nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE( OwnerAddress, ',', '.'), 2)


Alter Table NashvilleHousing 
ADD OwnerSplitState nvarchar(255)

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE( OwnerAddress, ',', '.'), 1)




-- Change Y and N to Yes and No in column SoldasVacant

SELECT DISTINCT(SoldAsVacant),  COUNT  ( soldasvacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2



SELECT 
SoldasVacant,
CASE WHEN  SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END 
FROM NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant= CASE WHEN  SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END  


-- Remove Duplicates
WITH RownumCte as (
SELECT  * ,ROW_NUMBER() OVER (PARTITION BY
ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
ORDER BY UniqueID) row_num

FROM NashvilleHousing)


delete  FROM RownumCte WHERE row_num> 1


--DELETE UNUESED COLUMNS(Not for raw data)

SELECT * FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, PropertyAddress, TaxDistrict



