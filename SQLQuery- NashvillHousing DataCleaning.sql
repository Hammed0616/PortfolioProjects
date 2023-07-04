
-- clearing data in sql queries

select *
from PortfolioProject..NashvillHousing

-- Standardizied SaleDate (converting it to ordinary date and not datetime formart)

select SalesDate, convert (Date,SaleDate) SlaesDate
from PortfolioProject..NashvillHousing

--update PortfolioProject..NashvillHousing
--set SaleDate = convert (Date,SaleDate)

--Adding new column to the table

alter table PortfolioProject..NashvillHousing
add SalesDate Date;

update PortfolioProject..NashvillHousing
set SalesDate = convert(Date,SaleDate)

--Populate property address

select *
from PortfolioProject..NashvillHousing
--where PropertyAddress is null
order by ParcelID

-- To fill the Null PropertyAddress, find the ParcelID that have common address and populate it into the Null PropertyAddress
-- We also had to jion the table to itself 

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from PortfolioProject..NashvillHousing a
 join PortfolioProject..NashvillHousing b
 on a.ParcelID = b.ParcelID
 and a.[UniqueID ]<> b.[UniqueID ]
 where b.PropertyAddress is null

 -- Populating the Address to replace the nulls

 select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(b.PropertyAddress,a.PropertyAddress) MissingAddress
from PortfolioProject..NashvillHousing a
 join PortfolioProject..NashvillHousing b
 on a.ParcelID = b.ParcelID
 and a.[UniqueID ]<> b.[UniqueID ]
 where b.PropertyAddress is null

 -- To update the null PropertyAddress

 update b
 set PropertyAddress = isnull(b.PropertyAddress,a.PropertyAddress)
 from PortfolioProject..NashvillHousing a
 join PortfolioProject..NashvillHousing b
 on a.ParcelID = b.ParcelID
 and a.[UniqueID ]<> b.[UniqueID ]
 where b.PropertyAddress is null

 -- Breaking out address into individual columns (Address,City,State)

 select PropertyAddress
 from PortfolioProject..NashvillHousing

--Seperating the address using substring and character index

select
 substring(PropertyAddress,1, charindex(',',PropertyAddress)-1) Address,
 substring(PropertyAddress, charindex(',',PropertyAddress)+1, len(PropertyAddress)) City
 from PortfolioProject..NashvillHousing

 -- To add another column to the table

 alter table PortfolioProject..NashvillHousing
 add PropertyStreet nvarchar(255);

 update PortfolioProject..NashvillHousing
 set PropertyStreet  = substring(PropertyAddress,1, charindex(',',PropertyAddress)-1)


 alter table PortfolioProject..NashvillHousing
 add PropertyCity nvarchar(255);

 update PortfolioProject..NashvillHousing
 set PropertyCity = substring(PropertyAddress, charindex(',',PropertyAddress)+1, len(PropertyAddress))

--Breaking the OwnerAddress using ParseName syntax

select OwnerAddress
from PortfolioProject..NashvillHousing

select
parsename(replace(OwnerAddress,',','.'),3),
parsename(replace(OwnerAddress,',','.'),2),
parsename(replace(OwnerAddress,',','.'),1)
from PortfolioProject..NashvillHousing



alter table PortfolioProject..NashvillHousing
 add OwnerStreet nvarchar(255);

 update PortfolioProject..NashvillHousing
 set OwnerStreet  = parsename(replace(OwnerAddress,',','.'),3)


 alter table PortfolioProject..NashvillHousing
 add OwnerCity nvarchar(255);

 update PortfolioProject..NashvillHousing
 set OwnerCity = parsename(replace(OwnerAddress,',','.'),2)


 alter table PortfolioProject..NashvillHousing
 add OwnerState nvarchar(255);

 update PortfolioProject..NashvillHousing
 set OwnerState  = parsename(replace(OwnerAddress,',','.'),1)

 --Change Y and N to Yes and No in 'Sold as Vacant'field -- Using CASE Statement

select distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject..NashvillHousing
group by SoldAsVacant
order by 2

select SoldAsVacant,
case
   when SoldAsVacant = 'N' then 'No' 
   when SoldAsVacant = 'Y' then 'Yes'
   else SoldAsVacant
   end 
 from PortfolioProject..NashvillHousing

 update PortfolioProject..NashvillHousing
 set SoldAsVacant = case
   when SoldAsVacant = 'N' then 'No' 
   when SoldAsVacant = 'Y' then 'Yes'
   else SoldAsVacant
   end 
 from PortfolioProject..NashvillHousing

 -- Removing Duplicates
 -- To identify duplicates

with DupDataCTE as (
 select *,
 row_number() over (
 partition by ParcelID,
              PropertyAddress,
			  SalePrice,
			  SaleDate,
			  LegalReference
			  order by
			  UniqueID
			  ) row_num
 from PortfolioProject..NashvillHousing
 --order by ParcelID
 )
 select *
 from DupDataCTE
 where row_num > 1
 order by PropertyAddress

 -- Delete unsued columns

 
 alter table PortfolioProject..NashvillHousing
 drop column OwnerAddress, TaxDistrict, PropertyAddress

 alter table PortfolioProject..NashvillHousing
 drop column SaleDate

 