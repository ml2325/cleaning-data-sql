--cleaning data

select * from PortfolioProject..NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------------------
--change the date format 
select SaleDateConverted,Convert(Date,SaleDate)
from PortfolioProject..NashvilleHousing

--update NashvilleHousing
--set SaleDate=CONVERT(date,SaleDate)

alter table NashvilleHousing
add SaleDateConverted date;
update NashvilleHousing
set SaleDateConverted=convert(date,SaleDate)

----------------------------------------------------------------------------------------------------------------

--populate proprety address data 
select *
from PortfolioProject..NashvilleHousing
order by ParcelID

select  n.ParcelID,n.PropertyAddress,h.ParcelID,h.PropertyAddress, ISNULL(n.PropertyAddress,h.PropertyAddress)
from PortfolioProject..NashvilleHousing n
join
PortfolioProject..NashvilleHousing h
on n.ParcelID=h.ParcelID and n.[UniqueID ]<>h.[UniqueID ]
where n.PropertyAddress is null

update n
set PropertyAddress=ISNULL(n.PropertyAddress,h.PropertyAddress)
from PortfolioProject..NashvilleHousing n
join
PortfolioProject..NashvilleHousing h
on n.ParcelID=h.ParcelID and n.[UniqueID ]<>h.[UniqueID ]
where n.PropertyAddress is null

----------------------------------------------------------------------------------------------------------------
--turn address in multiple column
select PropertyAddress
from PortfolioProject..NashvilleHousing

select SUBSTRING(PropertyAddress , 1, CHARINDEX(',',PropertyAddress)-1)as address
,SUBSTRING(PropertyAddress , CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as address
from PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

select * from NashvilleHousing



select * from PortfolioProject..NashvilleHousing

select PARSENAME(replace(ownerAddress,',','.'),3)
,pARSENAME(replace(ownerAddress,',','.'),2)
,pARSENAME(replace(ownerAddress,',','.'),1)
from PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);
Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);
Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);
Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)





-----------------------------------------------------
--turn y to yes and n to no
select distinct(soldAsVacant),COUNT(soldAsvacant)
from PortfolioProject..NashvilleHousing
group by soldasvacant
order by 2


--try
select soldasvacant,
case 
when soldasvacant='Y' then 'Yes'
when soldasvacant='N' then 'No'
else soldasvacant
end
from PortfolioProject..NashvilleHousing

--it worked so we updated now let's try again with the count query
update NashvilleHousing
set soldasvacant=case 
when soldasvacant='Y' then 'Yes'
when soldasvacant='N' then 'No'
else soldasvacant
end

-------------------------------------------------------------------------------------------------
--remove duplecates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
    ORDER BY UniqueID) row_num

From PortfolioProject.dbo.NashvilleHousing
----order by ParcelID
)
select *
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress



----------------------------------------------------------------------------
--delete unused column
Select *
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate





