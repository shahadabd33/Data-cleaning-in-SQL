
/*

Cleaning Data in SQL Queries

*/




select *
from protfolioproject.dbo.NashvilleHousing 
order by 1

-------------------------------------------------------------------------------------------
---- Populate Property Address data



select *
from protfolioproject.dbo.[NashvilleHousing]
--where PropertyAddress is null
order by ParcelID 


select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from protfolioproject.dbo.[NashvilleHousing ] a
join protfolioproject.dbo.[NashvilleHousing ] b
 on a.ParcelID=b.ParcelID
 and a.UniqueID <> b.UniqueID
 where a.PropertyAddress is null

 update a
 set PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
   from protfolioproject.dbo.[NashvilleHousing ] a
join protfolioproject.dbo.[NashvilleHousing ] b
 on a.ParcelID=b.ParcelID
 and a.UniqueID <> b.UniqueID
  where a.PropertyAddress is null
  ---------------------------------------------------------------------------------------------------------

   -- Breaking out Address into Individual Columns (Address, City, State)

  select
  SUBSTRING(propertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as address,
  SUBSTRING(propertyAddress, CHARINDEX(',',PropertyAddress)+1 ,len(propertyAddress)) as Address
  from protfolioproject.dbo.[NashvilleHousing ]

  alter table NashvilleHousing 
  add propertySiplitAddress nvarchar(255);

  update NashvilleHousing 
  set propertySiplitAddress  = SUBSTRING(propertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

  alter table NashvilleHousing 
  add propertySiplitcity nvarchar(255);

  update NashvilleHousing 
  set  propertySiplitcity =SUBSTRING(propertyAddress, CHARINDEX(',',PropertyAddress)+1 ,len(propertyAddress))


  select*
  from protfolioproject.dbo.NashvilleHousing 


  -----anthoer way to do it

  select
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
  from protfolioproject.dbo.NashvilleHousing 

   alter table NashvilleHousing 
  add OwnerSiplitAddress nvarchar(255);

  update NashvilleHousing 
  set OwnerSiplitAddress  = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

  alter table NashvilleHousing 
  add OwnerSiplitcity nvarchar(255);

  update NashvilleHousing 
  set  OwnerSiplitcity =PARSENAME(REPLACE(OwnerAddress,',','.'),2)

  alter table NashvilleHousing 
  add OwnerSiplitstate nvarchar(255);

  update NashvilleHousing 
  set  OwnerSiplitstate = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

  ------------------------------------------------------------------------------------------------------------------------

  ---- Change 1 and 0 to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From protfolioproject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2



ALTER TABLE NashvilleHousing
ALTER COLUMN SoldASVacant VARCHAR(10); -- Change to VARCHAR(10)


  
 
  select SoldASVacant
, case when SoldASVacant='1' then 'YES'
       when SoldASVacant='0' then 'NO'
	   Else SoldASVacant
	   End
  from NashvilleHousing 

  update NashvilleHousing 
  set  SoldASVacant= case when SoldASVacant='1' then 'YES'
       when SoldASVacant='0' then 'NO'
	   Else SoldASVacant
	   End 
 
 ------------------------------------------------------------------------------------------------
-- Remove Duplicates

 with ROW_NUM as(
select*,
 ROW_number() Over(PARTITION BY ParcelID , PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by 
				 UniqueID) row_num
from protfolioproject.dbo.NashvilleHousing )
select*
from  ROW_NUM
where row_num> 1	



--------------------------------------------------------------------
-- drop useless columns 

select*
from protfolioproject.dbo.NashvilleHousing

alter table protfolioproject.dbo.NashvilleHousing
drop column OwnerAddress,TaxDistrict, PropertyAddress


