use Portfolioproject1;

select * from NashvillHousing;

----------------------------------------------------------------------------------------------------------------------------------------------

--Standarize Date Format

select SaleDate,CONVERT(date,saledate) as saledateconverted
from NashvillHousing;

update NashvillHousing
set SaleDate = CONVERT(date,saledate);

Alter table NashvillHousing
add saledateconverted date;

update NashvillHousing
set saledateconverted = CONVERT(date,saledate);


-----------------------------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address

select PropertyAddress
from NashvillHousing
--where propertyAddress is null
order by ParcelID;

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from NashvillHousing a
join NashvillHousing b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;


update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from NashvillHousing a
join NashvillHousing b
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;

-----------------------------------------------------------------------------------------------------------------------------------------------

--Breaking Address into Individual Columns (Address, City, State)

select 
 SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
 , SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address
 From NashvillHousing

Alter table NashvillHousing
add PropertySplitAddress nvarchar(225);

update NashvillHousing
set  PropertySplitAddress =  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 );

Alter table NashvillHousing
add PropertySplitCity nvarchar(225);

update NashvillHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


select OwnerAddress  from NashvillHousing 

Select
 PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
 ,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
 ,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
 From NashvillHousing
 where OwnerAddress is not null
 
 Alter table NashvillHousing
add OwnerSplitAddress nvarchar(225);

update NashvillHousing
set  OwnerSplitAddress =  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);

Alter table NashvillHousing
add OwnerSplitCity nvarchar(225);

update NashvillHousing
set  OwnerSplitCity =  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

Alter table NashvillHousing
add OwnerSplitState nvarchar(225);

update NashvillHousing
set  OwnerSplitState =  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);

-----------------------------------------------------------------------------------------------------------------------------------------------

--Changing Y & N to Yes & No in "SoldAsVacant" field

Select Distinct(SoldAsVacant), count(SoldAsVacant)
From NashvillHousing
Group by SoldAsVacant
Order by 2

select SoldAsVacant
,Case When SoldAsVacant = 'Y' Then 'Yes'
     When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End
From NashvillHousing

Update NashvillHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
     When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End

-----------------------------------------------------------------------------------------------------------------------------------------------

---------------Removing Duplicate

With RowNumCTE As(
Select *,
   ROW_NUMBER() over(
   partition by ParcelID,
                propertyaddress,
				saleprice,
				saledate,
				legalreference
				order by
				   uniqueid
				   ) row_num

From NashvillHousing
--order by ParcelID
)
Select *
From  RowNumCTE
where row_num > 1
order by propertyaddress
 
-----------------------------------------------------------------------------------------------------------------------------------------------

------Deleting unused columns

Select *
From NashvillHousing;

Alter table NashvillHousing
Drop column owneraddress, TaxDistrict, propertyaddress,

Alter table NashvillHousing
Drop column sale_date




