--Cleaning data

Select *
From PortfolioProject.dbo.NashvilleHousing
--Order by 2

---Date Format

Select SaleDateConverted, CONVERT(Date, SaleDate3)
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
Set SaleDate3 = CONVERT(Date, SaleDate3)

Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate3)

--SaleDateConverted is also been added to the table 

-----------------------------------------

--Property Address

Select *
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, f.ParcelID, f.PropertyAddress, ISNULL(a.PropertyAddress, f.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing f
on a.ParcelID = f.ParcelID
And a.[UniqueID ] <> f.[UniqueID ]
Where a.PropertyAddress is null
--Order by 1,2

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, f.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing f
on a.ParcelID = f.ParcelID
And a.[UniqueID ] <> f.[UniqueID ]
Where a.PropertyAddress is null

---- Breaking address into individual (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
Order by ParcelID

--Removing Comma in the Address Position 1

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
From PortfolioProject.dbo.NashvilleHousing
Order by ParcelID

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.NashvilleHousing
Order by ParcelID

Alter Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)


Alter Table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

--PropertySplitAddress and PropertySplitCity are added into the table

Select *
From PortfolioProject.dbo.NashvilleHousing


---

Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing

Select 
Parsename(Replace(OwnerAddress,',','.'),3),
Parsename(Replace(OwnerAddress,',','.'),2),
Parsename(Replace(OwnerAddress,',','.'),1)
From PortfolioProject.dbo.NashvilleHousing
Order by ParcelID

Alter Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = Parsename(Replace(OwnerAddress,',','.'),3)


Alter Table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = Parsename(Replace(OwnerAddress,',','.'),2)

Alter Table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = Parsename(Replace(OwnerAddress,',','.'),1)

--Now, PropertySplitAddress, OwnerSplitCity and OwnerSplitState are added into the table


---Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant,
Case when SoldAsVacant = 'Y' Then 'Yes'
When SoldAsVacant = 'N' Then 'No'
Else SoldAsVacant
End
From PortfolioProject.dbo.NashvilleHousing
--Order by 1

Update NashvilleHousing
Set SoldAsVacant = Case when SoldAsVacant = 'Y' Then 'Yes'
When SoldAsVacant = 'N' Then 'No'
Else SoldAsVacant
End
From PortfolioProject.dbo.NashvilleHousing

------
With RowNumCTE AS(
Select*, 
ROW_Number() Over (
Partition By ParcelID,
			PropertyAddress,
			SalePrice,
			LegalReference
			ORDER by
			UniqueID
			) row_num
From PortfolioProject.dbo.NashvilleHousing
--Order by ParcelID
)

--Delete
--From RowNumCTE
--Where Row_Num > 1
----Order by PropertyAddress

Select*
From RowNumCTE
Where Row_Num > 1
Order by PropertyAddress

----Dublicates Removed

------------------------------

Select*
From PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop column ownerAddress, TaxDistrict, PropertyAddress

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop column SaleDate

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop column SalesDate3

---Old dateformat is being removed 

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop column SaleDate3

----Now unused columns also delected