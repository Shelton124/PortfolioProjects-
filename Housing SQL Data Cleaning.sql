Select *
from portfolioproject..NashvilleHousing

-- We will Standardize The Date Formate 



Select saledateconverted, convert(date,saledate)
from portfolioproject..NashvilleHousing

update NashvilleHousing
Set saledate = convert(date,SaleDate)

Alter Table Nashvillehousing
add saledateconverted date;

update NashvilleHousing
Set saledateconverted = convert(date,SaleDate)

-- Pooulate property Addresss data 


Select *
from portfolioproject..NashvilleHousing
where PropertyAddress is null 


--where PropertyAddress is null


order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from portfolioproject..NashvilleHousing a
join portfolioproject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set propertyaddress =  ISNULL(a.PropertyAddress,b.PropertyAddress)
from portfolioproject..NashvilleHousing a
join portfolioproject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- Breaking out Address into individual columns (adress, city, state) 


Select PropertyAddress
from portfolioproject..NashvilleHousing
--where PropertyAddress is null 

select 
SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress)-1) as address,
SUBSTRING (propertyaddress, CHARINDEX(',', propertyaddress)+1, len(PropertyAddress)) as address

from portfolioproject..NashvilleHousing

Alter Table Nashvillehousing
add propertysplitaddress nvarchar(255);

update NashvilleHousing
Set propertysplitaddress = SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress)-1) 

Alter Table Nashvillehousing
add propertysplitcity nvarchar(255);

update NashvilleHousing
Set propertysplitcity = SUBSTRING (propertyaddress, CHARINDEX(',', propertyaddress)+1, len(PropertyAddress))

Select * 
from portfolioproject..NashvilleHousing

Select OwnerAddress
from portfolioproject..NashvilleHousing

select
PARSENAME(Replace(OwnerAddress,',','.'),3)
,PARSENAME(Replace(OwnerAddress,',','.'),2)
,PARSENAME(Replace(OwnerAddress,',','.'),1)
from portfolioproject..NashvilleHousing

Alter Table Nashvillehousing
add ownersplitaddress nvarchar(255);

update NashvilleHousing
Set ownersplitaddress = PARSENAME(Replace(OwnerAddress,',','.'),3)

Alter Table Nashvillehousing
add ownersplitcity nvarchar(255);

update NashvilleHousing
Set ownersplitcity = PARSENAME(Replace(OwnerAddress,',','.'),2)

Alter Table Nashvillehousing
add Ownersplitstate nvarchar(255);

update NashvilleHousing
Set Ownersplitstate = PARSENAME(Replace(OwnerAddress,',','.'),1)

Select * 
from portfolioproject..NashvilleHousing

-- Change Y and N to Yes and No in "Sold as Vacant" feild

Select Distinct(SoldAsVacant), count(SoldAsVacant)
from portfolioproject..NashvilleHousing
group by SoldAsVacant
order by 2 

Select SoldAsVacant
,case when SoldAsVacant = 'Y' Then 'Yes'
When SoldAsVacant = 'N' Then 'No'
ElSE SoldAsVacant
END
from portfolioproject..NashvilleHousing

Update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' Then 'Y'
When SoldAsVacant = 'N' Then 'No'
ElSE SoldAsVacant
END

-- remove duplicates 

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
)
Select *
from RowNumCTE
where row_num > 1
order by PropertyAddress

-- Delete unused Columns 

Select * 
From PortfolioProject.dbo.NashvilleHousing

alter table PortfolioProject.dbo.NashvilleHousing
drop column owneraddress, taxDistrict, Propertyaddress

alter table PortfolioProject.dbo.NashvilleHousing
drop column saledate